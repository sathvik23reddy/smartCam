import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smart_cam/home.dart';

//Main Function
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  //Choosing back camera amongst all cameras on phone
  final cameraToUse = cameras.first;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.purple,
    ),
    //Passing back camera as parameter
    home: Home(cameraToUse: cameraToUse),
  ));
}
