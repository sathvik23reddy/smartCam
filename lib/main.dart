import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smart_cam/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final cameraToUse = cameras.first;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.purple,
    ),
    home: Home(cameraToUse: cameraToUse),
  ));
}
