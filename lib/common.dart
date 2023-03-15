import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_cam/cam.dart';

class commonUI extends StatefulWidget {
  const commonUI({super.key, required this.cameraToUse});
  final CameraDescription cameraToUse;

  @override
  State<commonUI> createState() => _commonUIState();
}

class _commonUIState extends State<commonUI> {
  late List<String> languages = [
    'Please select target language',
    'English',
    'Hindi'
  ];
  late String dropdownValue = languages.first;
  Image? image;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: screenHeight / 25,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                alignment: Alignment.center,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
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
            SizedBox(
              height: screenHeight / 6,
            ),
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
                              dialogBox();
                            });
                          },
                        ),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }

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

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      Uint8List imageByte = await pickedFile.readAsBytes();
      setState(() {
        image = Image(image: XFileImage(pickedFile));
        debugPrint("Gallery Image");
      });
    }
  }

  _getFromCamera() async {
    final filePath = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                customCamera(camera_to_use: widget.cameraToUse)));

    if (filePath != null) {
      Uint8List imageByte = await File(filePath as String).readAsBytes();
      setState(() {
        image = Image.file(File(filePath));
        debugPrint("Camera Image");
      });
    }
  }
}
