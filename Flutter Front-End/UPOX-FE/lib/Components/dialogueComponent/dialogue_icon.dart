import 'package:flutter/material.dart';

class DialogueContentIcon extends StatelessWidget {
  const DialogueContentIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        // Icon img
        child: Image.asset(
          'assets/logo_dialogue.png',
          width: 332,
          height: 377,
        ),
      ),
    );
  }
}
