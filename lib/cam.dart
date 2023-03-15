import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class customCamera extends StatefulWidget {
  const customCamera({super.key, required this.camera_to_use});
  final CameraDescription camera_to_use;
  @override
  State<customCamera> createState() => __cameraState();
}

class __cameraState extends State<customCamera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera_to_use,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a picture'),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            if (!mounted) return;

            Navigator.pop(context, image.path);
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
