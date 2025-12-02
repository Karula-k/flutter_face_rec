import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class SimpleFaceStorageService {
  static const String _registeredFacesFile = 'registered_faces.json';
  static const String _imagesDir = 'face_images';

  List<Map<String, dynamic>> _registeredFaces = [];
  Interpreter? _interpreter;

  Future<void> initialize() async {
    try {
      // Load the FaceNet model
      _interpreter =
          await Interpreter.fromAsset('assets/models/mobilefacenet.tflite');
      print('MobileFaceNet model loaded successfully');

      // Check model input/output details
      var inputTensor = _interpreter!.getInputTensors().first;
      var outputTensor = _interpreter!.getOutputTensors().first;
      print('Input tensor shape: ${inputTensor.shape}');
      print('Output tensor shape: ${outputTensor.shape}');
      print('Input tensor type: ${inputTensor.type}');
      print('Output tensor type: ${outputTensor.type}');

      // Test model with various input formats
      print('Testing model with different input formats...');

      var testInput = Float32List(1 * 112 * 112 * 3);

      // Fill with test data using (pixel-128)/128 normalization
      for (int i = 0; i < 112 * 112 * 3; i++) {
        testInput[i] = ((i % 256) - 128) / 128;
      }

      var testInputReshaped = testInput.reshape([1, 112, 112, 3]);
      var testOutput = List.generate(1, (index) => List.filled(192, 0.0));

      try {
        _interpreter!.run(testInputReshaped, testOutput);

        final testResults = testOutput.reshape([192]).take(5).toList();
        print('approach test output: $testResults');
      } catch (e) {
        print(' approach test failed: $e');
      }

      // Load registered faces
      await _loadRegisteredFaces();

      // Ensure images directory exists
      await _ensureImagesDirectory();
    } catch (e) {
      print('Error initializing SimpleFaceStorageService: $e');
      throw e;
    }
  }

  Future<void> _ensureImagesDirectory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/$_imagesDir');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
    } catch (e) {
      print('Error creating images directory: $e');
    }
  }

  Future<void> _loadRegisteredFaces() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_registeredFacesFile');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonData = json.decode(jsonString) as List;
        _registeredFaces = jsonData.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error loading registered faces: $e');
      _registeredFaces = [];
    }
  }

  Future<void> _saveRegisteredFaces() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_registeredFacesFile');
      final jsonString = json.encode(_registeredFaces);
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving registered faces: $e');
    }
  }

  Future<String?> registerFace(
      Uint8List imageBytes, String userId, String userName) async {
    try {
      // Save image to storage
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/$_imagesDir');
      final imageFile = File('${imagesDir.path}/$userId.jpg');
      await imageFile.writeAsBytes(imageBytes);

      // Add to registered faces
      final faceData = {
        'userId': userId,
        'userName': userName,
        'imagePath': imageFile.path,
        'registeredAt': DateTime.now().toIso8601String(),
      };

      // Remove existing registration for this user
      _registeredFaces.removeWhere((face) => face['userId'] == userId);

      // Add new registration
      _registeredFaces.add(faceData);

      // Save to storage
      await _saveRegisteredFaces();

      return null; // Success
    } catch (e) {
      return 'Error registering face: $e';
    }
  }

  Future<List<double>> _extractFaceEmbedding(Uint8List imageBytes) async {
    try {
      if (_interpreter == null) {
        throw Exception('Model not initialized');
      }

      // Decode and resize image properly
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize to 112x112 as required by MobileFaceNet (
      img.Image resizedImage = img.copyResize(image, width: 112, height: 112);

      // Use preprocessing approach with (pixel-128)/128 normalization
      var inputBytes = Float32List(1 * 112 * 112 * 3);
      int pixelIndex = 0;

      // Convert image with  exact normalization
      for (int y = 0; y < 112; y++) {
        for (int x = 0; x < 112; x++) {
          final pixel = resizedImage.getPixel(x, y);

          // Extract RGB values using proper image package API
          final r = pixel.r;
          final g = pixel.g;
          final b = pixel.b;

          // normalization: (pixel - 128) / 128
          inputBytes[pixelIndex++] = (r - 128) / 128;
          inputBytes[pixelIndex++] = (g - 128) / 128;
          inputBytes[pixelIndex++] = (b - 128) / 128;
        }
      }

      // Reshape input to [1, 112, 112, 3]
      var input = inputBytes.reshape([1, 112, 112, 3]);

      print('Using approach: 112x112 input, (pixel-128)/128 normalization');

      // Create output buffer for 192-dimensional embedding (MobileFaceNet output)
      var output = List.generate(1, (index) => List.filled(192, 0.0));

      // Run inference
      _interpreter!.run(input, output);

      // Flatten output and convert to List<double>
      var flatOutput = output.reshape([192]);
      final outputList = flatOutput.cast<double>();

      print(
          'Generated embedding using approach, first few values: ${outputList.take(10).toList()}');

      return outputList;
    } catch (e) {
      print('Error extracting face embedding: $e');
      throw e;
    }
  }

  //COSINE SIMILARITY
  double _calculateSimilarity(
      List<double> embedding1, List<double> embedding2) {
    if (embedding1.length != embedding2.length) return 0.0;

    double dotProduct = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
      norm1 += embedding1[i] * embedding1[i];
      norm2 += embedding2[i] * embedding2[i];
    }

    if (norm1 == 0.0 || norm2 == 0.0) return 0.0;

    return dotProduct / (sqrt(norm1) * sqrt(norm2));
  }

  Future<Map<String, dynamic>?> findFaceByComparison(
      Uint8List inputImageBytes) async {
    if (_registeredFaces.isEmpty) {
      return {'recognized': false, 'message': 'No registered faces found'};
    }

    try {
      print('Extracting embedding for input image...');
      final inputEmbedding = await _extractFaceEmbedding(inputImageBytes);

      double bestSimilarity = 0.0;
      Map<String, dynamic>? bestMatch;

      print('Comparing with ${_registeredFaces.length} registered faces...');

      for (final face in _registeredFaces) {
        try {
          // Load the registered face image
          final imageFile = File(face['imagePath']);
          if (await imageFile.exists()) {
            final registeredImageBytes = await imageFile.readAsBytes();
            final registeredEmbedding =
                await _extractFaceEmbedding(registeredImageBytes);

            final similarity =
                _calculateSimilarity(inputEmbedding, registeredEmbedding);
            print(
                'Similarity with ${face['userName']}: ${similarity.toStringAsFixed(3)}');

            if (similarity > bestSimilarity) {
              bestSimilarity = similarity;
              bestMatch = face;
            }
          }
        } catch (e) {
          print('Error processing face ${face['userId']}: $e');
        }
      }

      const double threshold = 0.5; // similarity threshold

      if (bestMatch != null && bestSimilarity > threshold) {
        return {
          'recognized': true,
          'userId': bestMatch['userId'],
          'userName': bestMatch['userName'],
          'similarity': bestSimilarity,
          'imagePath': bestMatch['imagePath'],
          'message': 'Face recognized with ML comparison',
        };
      } else {
        return {
          'recognized': false,
          'message':
              'No matching face found (best similarity: ${bestSimilarity.toStringAsFixed(3)})',
          'bestSimilarity': bestSimilarity,
        };
      }
    } catch (e) {
      return {'recognized': false, 'error': 'Error in face recognition: $e'};
    }
  }

  List<Map<String, dynamic>> getRegisteredFaces() =>
      List.from(_registeredFaces);

  Future<void> deleteFace(String userId) async {
    try {
      // Remove from list
      _registeredFaces.removeWhere((face) => face['userId'] == userId);

      // Delete image file
      final directory = await getApplicationDocumentsDirectory();
      final imageFile = File('${directory.path}/$_imagesDir/$userId.jpg');
      if (await imageFile.exists()) {
        await imageFile.delete();
      }

      // Save updated list
      await _saveRegisteredFaces();
    } catch (e) {
      print('Error deleting face: $e');
    }
  }
}
