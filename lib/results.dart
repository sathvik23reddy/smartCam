import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Results extends StatefulWidget {
  Results({super.key, required this.resultEng, required this.targetLanguage});
  String resultEng, targetLanguage;
  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  String? resultGoalLang;
  bool isLoading = false;
  FlutterTts ftts = FlutterTts();

  @override
  void initState() {
    super.initState();
    translateText(widget.resultEng, widget.targetLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;

    return isLoading
        ? SizedBox(
            height: screenHeight / 3.5,
            child: Center(child: CircularProgressIndicator()))
        : Column(children: [
            Padding(
              padding:
                  EdgeInsets.fromLTRB(screenWidth / 6, 0, screenWidth / 6, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "English: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      GestureDetector(
                          onTap: () => speakText(widget.resultEng),
                          child: Icon(
                            Icons.volume_down_alt,
                            size: 35,
                          ))
                    ],
                  ),
                  Text(
                    widget.resultEng,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 21),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
              child: Divider(color: Colors.black, height: 4),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(screenWidth / 6, 0, screenWidth / 6, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.targetLanguage == "Please select target language"
                            ? "English: "
                            : "${widget.targetLanguage}: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      GestureDetector(
                          onTap: () => speakText(resultGoalLang!),
                          child: Icon(
                            Icons.volume_down_alt,
                            size: 35,
                          ))
                    ],
                  ),
                  Text(
                    resultGoalLang!,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 21),
                  )
                ],
              ),
            )
          ]);
  }

  void translateText(String result, String goalLanguage) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> languageMap = {
      'Please select target language': TranslateLanguage.english,
      'Albanian': TranslateLanguage.albanian,
      'Bengali': TranslateLanguage.bengali,
      'Chinese': TranslateLanguage.chinese,
      'Croatian': TranslateLanguage.croatian,
      'Dutch': TranslateLanguage.dutch,
      'English': TranslateLanguage.english,
      'Finnish': TranslateLanguage.finnish,
      'French': TranslateLanguage.french,
      'German': TranslateLanguage.german,
      'Greek': TranslateLanguage.greek,
      'Gujarati': TranslateLanguage.gujarati,
      'Hindi': TranslateLanguage.hindi,
      'Hungarian': TranslateLanguage.hungarian,
      'Indonesian': TranslateLanguage.indonesian,
      'Irish': TranslateLanguage.irish,
      'Italian': TranslateLanguage.italian,
      'Japanese': TranslateLanguage.japanese,
      'Kannada': TranslateLanguage.kannada,
      'Korean': TranslateLanguage.korean,
      'Spanish': TranslateLanguage.spanish,
      'Tamil': TranslateLanguage.tamil,
      'Turkish': TranslateLanguage.turkish
    };
    print("Inside Translate");
    final onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english,
        targetLanguage: languageMap[goalLanguage]);
    final String response = await onDeviceTranslator.translateText(result);
    setState(() {
      isLoading = false;
      resultGoalLang = response;
    });
    print("Take bro " + response);
  }

  void speakText(String resultEng) async {
    var result = await ftts.speak(resultEng);
    if (result == 1) {
      //speaking
    } else {
      //not speaking
    }
  }
}
