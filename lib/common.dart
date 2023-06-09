// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:smart_cam/tflite/classifier.dart';
import 'package:smart_cam/tflite/classifier_quant.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_cam/cam.dart';
import 'package:smart_cam/objDetect.dart';
import 'package:smart_cam/textDetect.dart';

class commonUI extends StatefulWidget {
  const commonUI(
      {super.key, required this.cameraToUse, required this.pageIndex});
  final CameraDescription cameraToUse;
  final int pageIndex;
  @override
  State<commonUI> createState() => _commonUIState();
}

class _commonUIState extends State<commonUI> {
  //List of Languages supported
  late List<String> languages = [
    'Please select target language',
    'Albanian',
    'Bengali',
    'Chinese',
    'Croatian',
    'Dutch',
    'English',
    'Finnish',
    'French',
    'German',
    'Greek',
    'Gujarati',
    'Hindi',
    'Hungarian',
    'Indonesian',
    'Irish',
    'Italian',
    'Japanese',
    'Kannada',
    'Korean',
    'Spanish',
    'Tamil',
    'Turkish'
  ];
  late String dropdownValue = languages.first;
  Image? image;
  String? filepath;
  late Classifier _classifier;
  late int curPage;

  //Called upon initialisation, helps setup Classifier and set other values to Null
  @override
  void initState() {
    super.initState();
    image = null;
    filepath = null;
    curPage = widget.pageIndex;
    _classifier = ClassifierQuant();
  }

  //Called when Widget is disposed
  @override
  void dispose() {
    image = null;
    filepath = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Variables holding screenWidth and screenHeight (Relative to each device)
    final screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;

    //Updates current page to help reset Image
    if (curPage != widget.pageIndex) {
      curPage = widget.pageIndex;
      image = null;
      filepath = null;
    }

    //Common UI Widget
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              EdgeInsets.fromLTRB(0, screenHeight / 18, 0, screenHeight / 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                //Drop Down Button
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  alignment: Alignment.center,
                  style:
                      const TextStyle(color: Colors.deepPurple, fontSize: 18),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                      image = null;
                      filepath = null;
                    });
                  },
                  items: languages
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: SizedBox(
                              width: screenWidth / 1.4,
                              child: Text(value, textAlign: TextAlign.center),
                            ),
                          ))
                      .toList(),
                ),
              ),
              //Insert Image Box
              Column(
                children: [
                  image == null
                      ? getImageBox("Insert Image", screenWidth, screenHeight)
                      : SizedBox(
                          width: screenWidth,
                          height: screenHeight / 3.34,
                          child: image),
                  image == null
                      ? Container()
                      : Center(
                          child: TextButton(
                            child: const Text(
                              "Choose a different image",
                              style: TextStyle(color: Colors.purple),
                            ),
                            onPressed: () {
                              setState(() {
                                image = null;
                                filepath = null;

                                dialogBox();
                              });
                            },
                          ),
                        )
                ],
              ),
              //Results section (Unique to each mode)
              widget.pageIndex == 0
                  ? filepath == null
                      ? Container()
                      : objDetect(
                          filepath: filepath,
                          classifier: _classifier,
                          language: dropdownValue)
                  : filepath == null
                      ? Container()
                      : textDetect(filepath: filepath, language: dropdownValue)
            ],
          ),
        ),
      ),
    );
  }

  //Image Picker
  Widget getImageBox(String name, double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () => dialogBox(),
      child: SizedBox(
          width: screenWidth,
          height: screenHeight / 3.34,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: Icon(Icons.insert_photo_rounded)),
                Center(child: Text(name)),
              ],
            ),
          )),
    );
  }

  //Pop up window to get Gallery/Camera prompt
  Future dialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          return AlertDialog(
              title: const Text("Choose Image from..."),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: width / 4.5,
                    height: height / 11,
                    child: GestureDetector(
                      onTap: () async {
                        await _getFromGallery();
                        Navigator.pop(context);
                      },
                      child: Card(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.photo_album),
                              Text("Gallery")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 4.5,
                    height: height / 11,
                    child: GestureDetector(
                      onTap: () async {
                        await _getFromCamera();
                        Navigator.pop(context);
                      },
                      child: Card(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera),
                              Text("Camera")
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  //Function to get image from Gallery
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        filepath = pickedFile.path;
        image = Image(image: XFileImage(pickedFile));
        debugPrint("Gallery Image");
      });
    }
  }

  //Function to get image from Camera
  _getFromCamera() async {
    final filePath = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                customCamera(camera_to_use: widget.cameraToUse)));

    if (filePath != null) {
      setState(() {
        filepath = filePath;
        image = Image.file(File(filePath));
        debugPrint("Camera Image");
      });
    }
  }
}
