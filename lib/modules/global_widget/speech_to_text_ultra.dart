import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:visually_impaired/services/speech_service.dart';

class SpeechToTextUltra extends StatefulWidget {
  // final ValueChanged<String> callback;
  final Icon? toPauseIcon;
  final Icon? toStartIcon;
  final Color? pauseIconColor;
  final Color? startIconColor;
  final double? startIconSize;
  final double? pauseIconSize;

  // String combinedResponse = '';
  const SpeechToTextUltra(
      {super.key,
      this.toPauseIcon = const Icon(Icons.pause),
      this.toStartIcon = const Icon(Icons.mic),
      this.pauseIconColor = Colors.black,
      this.startIconColor = Colors.black,
      this.startIconSize = 24,
      this.pauseIconSize = 24});

  @override
  State<SpeechToTextUltra> createState() => _SpeechToTextUltraState();
}

class _SpeechToTextUltraState extends State<SpeechToTextUltra> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        return Get.find<SpeechService>().isListening.value
            ? IconButton(
                iconSize: widget.pauseIconSize,
                icon: widget.toPauseIcon!,
                color: widget.pauseIconColor,
                onPressed: () {
                  Get.find<SpeechService>().stopListening();
                },
              )
            : IconButton(
                iconSize: widget.startIconSize,
                color: widget.startIconColor,
                icon: widget.toStartIcon!,
                onPressed: () {
                  Get.find<SpeechService>().startListening();
                },
              );
      }),
    );
  }
}
