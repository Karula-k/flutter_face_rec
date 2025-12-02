import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_face_rec/core/services/face_recognition_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  final SimpleFaceStorageService _faceService = SimpleFaceStorageService();
  String _status = 'Initializing ML model...';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      await _faceService.initialize();
      setState(() {
        _isInitialized = true;
        _status = 'Ready - ML model loaded';
      });
    } catch (e) {
      setState(() {
        _status = 'ML initialization failed: $e';
      });
    }
  }

  Future<void> _takePhoto() async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ML model not ready yet')),
      );
      return;
    }

    setState(() => _status = 'Opening camera...');

    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() => _status = 'Processing face embedding...');

        final imageBytes = await photo.readAsBytes();
        final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        final userName = 'User ${DateTime.now().millisecondsSinceEpoch}';

        final error =
            await _faceService.registerFace(imageBytes, userId, userName);

        if (error != null) {
          setState(() => _status = 'Registration failed: $error');
        } else {
          setState(() => _status = 'Face registered successfully with ML!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Face registered as $userName')),
          );
        }
      } else {
        setState(() => _status = 'Camera cancelled');
      }
    } catch (e) {
      setState(() => _status = 'Camera error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ML model not ready yet')),
      );
      return;
    }

    setState(() => _status = 'Opening gallery...');

    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        setState(() => _status = 'Processing face embedding...');

        final imageBytes = await photo.readAsBytes();
        final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        final userName = 'User ${DateTime.now().millisecondsSinceEpoch}';

        final error =
            await _faceService.registerFace(imageBytes, userId, userName);

        if (error != null) {
          setState(() => _status = 'Registration failed: $error');
        } else {
          setState(() => _status = 'Face registered successfully with ML!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Face registered as $userName')),
          );
        }
      } else {
        setState(() => _status = 'Gallery cancelled');
      }
    } catch (e) {
      setState(() => _status = 'Gallery error: $e');
    }
  }

  Future<void> _recognizeFace() async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ML model not ready yet')),
      );
      return;
    }

    setState(() => _status = 'Opening camera for recognition...');

    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() => _status = 'Running ML face recognition...');

        final imageBytes = await photo.readAsBytes();
        final result = await _faceService.findFaceByComparison(imageBytes);

        if (result != null && result['recognized'] == true) {
          setState(() => _status = 'Face recognized: ${result['userName']}');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Face Recognized!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User: ${result['userName'] ?? 'Unknown'}'),
                  Text('ID: ${result['userId'] ?? 'Unknown'}'),
                  Text(
                      'Confidence: ${((result['similarity'] as double? ?? 0.0) * 100).toStringAsFixed(1)}%'),
                  const SizedBox(height: 8),
                  const Text('✅ ML Recognition Success'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          setState(() => _status = 'No registered face found');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Face Not Found'),
              content:
                  Text(result?['message'] ?? 'No matching face in database'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        setState(() => _status = 'Recognition cancelled');
      }
    } catch (e) {
      setState(() => _status = 'Recognition error: $e');
    }
  }

  Future<void> _recognizeFaceFromGallery() async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ML model not ready yet')),
      );
      return;
    }

    setState(() => _status = 'Opening gallery for recognition...');

    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        setState(() => _status = 'Running ML face recognition...');

        final imageBytes = await photo.readAsBytes();
        final result = await _faceService.findFaceByComparison(imageBytes);

        if (result != null && result['recognized'] == true) {
          setState(() => _status = 'Face recognized: ${result['userName']}');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Face Recognized!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User: ${result['userName'] ?? 'Unknown'}'),
                  Text('ID: ${result['userId'] ?? 'Unknown'}'),
                  Text(
                      'Confidence: ${((result['similarity'] as double? ?? 0.0) * 100).toStringAsFixed(1)}%'),
                  const SizedBox(height: 8),
                  const Text('✅ ML Recognition Success from Gallery'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          setState(() => _status = 'No registered face found');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Face Not Found'),
              content:
                  Text(result?['message'] ?? 'No matching face in database'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        setState(() => _status = 'Recognition cancelled');
      }
    } catch (e) {
      setState(() => _status = 'Recognition error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Status: $_status',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Register from Camera'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Register from Gallery'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _recognizeFace,
              icon: const Icon(Icons.face),
              label: const Text('Recognize from Camera'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _recognizeFaceFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Recognize from Gallery'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showDatabase,
              icon: const Icon(Icons.storage),
              label: const Text('View Database'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatabase() async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ML model not ready yet')),
      );
      return;
    }

    final registeredFaces = _faceService.getRegisteredFaces();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Face Database'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: registeredFaces.isEmpty
              ? const Center(child: Text('No faces registered'))
              : ListView.builder(
                  itemCount: registeredFaces.length,
                  itemBuilder: (context, index) {
                    final face = registeredFaces[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(face['userName'] ?? 'Unknown'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${face['userId']}'),
                            Text('Path: ${face['imagePath']}'),
                            Text('Registered: ${face['registeredAt']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _faceService.deleteFace(face['userId']);
                            Navigator.of(context).pop();
                            _showDatabase(); // Refresh the dialog
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
