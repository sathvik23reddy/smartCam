import 'dart:io';
import 'package:smart_cam/tflite/classifier.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class objDetect extends StatefulWidget {
  objDetect({super.key, required this.filepath, required this.classifier});
  final String? filepath;
  final Classifier classifier;
  @override
  State<objDetect> createState() => _objDetectState();
}

class _objDetectState extends State<objDetect> {
  Category? category;
  String? result;

  @override
  Widget build(BuildContext context) {
    processImage();
    return SizedBox(child: result == null ? (Text("")) : Text(result!));
  }

  void processImage() async {
    print("Inside process");
    img.Image imageInput =
        img.decodeImage(File(widget.filepath!).readAsBytesSync())!;
    var pred = widget.classifier.predict(imageInput);
    setState(() {
      this.category = pred;
    });
    print("Pred " + pred.toString());
    print(category!.label);
    print(category!.score.toStringAsFixed(3));
    setState(() {
      result = category!.label;
    });
  }
}
