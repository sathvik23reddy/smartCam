import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:smart_cam/results.dart';

class textDetect extends StatefulWidget {
  textDetect({super.key, required this.filepath, required this.language});
  String? filepath;
  String language;
  @override
  State<textDetect> createState() => _textDetectState();
}

class _textDetectState extends State<textDetect> {
  String? result;

  @override
  void initState() {
    super.initState();
    processText();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: result == null
            ? (Text(""))
            : Results(resultEng: result!, targetLanguage: widget.language));
  }

  void processText() async {
    print("Inside process Text");
    final InputImage inputImage = InputImage.fromFilePath(widget.filepath!);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    var buffer = StringBuffer();
    for (TextBlock block in recognizedText.blocks) {
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;
      String ret = "";
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          buffer.write(element.text);
        }
      }
      ret = buffer.toString();
      break;
    }
    setState(() {
      result = buffer.toString();
    });
  }
}
