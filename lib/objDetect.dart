import 'dart:io';
import 'package:smart_cam/results.dart';
import 'package:smart_cam/tflite/classifier.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class objDetect extends StatefulWidget {
  objDetect(
      {super.key,
      required this.filepath,
      required this.classifier,
      required this.language});
  final String? filepath;
  String language;
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
    return SizedBox(
        child: result == null
            ? Container()
            : Results(
                resultEng: result!,
                targetLanguage: widget.language,
              ));
  }

  //Processes the image using TFLite model, assigns output to result variable
  void processImage() async {
    img.Image imageInput =
        img.decodeImage(File(widget.filepath!).readAsBytesSync())!;
    var pred = widget.classifier.predict(imageInput);
    setState(() {
      category = pred;
    });
    setState(() {
      result = category!.label;
    });
  }
}
