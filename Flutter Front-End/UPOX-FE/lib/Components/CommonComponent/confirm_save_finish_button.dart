import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ConfirmSaveFinishButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final VoidCallback onPressed;

  const ConfirmSaveFinishButton({
    super.key,
    required this.buttonText,
    this.textColor = Colors.white,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.only(right: 13, top: 8.0),
        child: TextButton(
          onPressed: onPressed, // Thực thi hàm truyền vào
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
