import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<bool> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final storageStatus = await Permission.storage.request();

    return cameraStatus.isGranted && storageStatus.isGranted;
  }

  Future<Uint8List?> takePicture() async {
    try {
      final hasPermissions = await requestPermissions();
      if (!hasPermissions) {
        throw 'Camera permissions not granted';
      }

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (photo == null) return null;

      return await photo.readAsBytes();
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  Future<Uint8List?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image == null) return null;

      return await image.readAsBytes();
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }
}
