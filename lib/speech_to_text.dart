import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stts;

// https://www.youtube.com/watch?v=M4gyFL1Nqq4

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({super.key});

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  var _SpeechToText = stts.SpeechToText();
  bool isListening = false;
  String text = 'Press the button and start speaking';
  void listen() async {
    if (!isListening) {
      bool available = await _SpeechToText.initialize(
        onStatus: (status) => print("$status"),
        onError: (errorNotifiaction) => print("$errorNotifiaction"),
      );
      if (available) {
        setState(() {
          isListening = true;
        });
        _SpeechToText.listen(
          onResult: (result) => setState(() {
            text = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        isListening = false;
      });
      _SpeechToText.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    _SpeechToText = stts.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to text'),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          margin: EdgeInsets.only(bottom: 150),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        repeat: true,
        glowColor: Colors.blue,
        duration: Duration(milliseconds: 1000),
        child: FloatingActionButton(
          onPressed: () {
            listen();
          },
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}
