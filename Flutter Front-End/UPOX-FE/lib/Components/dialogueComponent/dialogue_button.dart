import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:flutter/material.dart';

class DialogueButton extends StatelessWidget {
  final String? title;
  final VoidCallback onPressed;
  const DialogueButton({super.key, this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xffececec),
        padding: const EdgeInsets.all(15),
      ),
      child: TitleText(
        titleName: title!,
        fontFam: "Cuprum",
        fontWeight: FontWeight.w400,
        fontSize: 15,
        textColor: const Color(0xff000000),
      ),
    );
  }
}
