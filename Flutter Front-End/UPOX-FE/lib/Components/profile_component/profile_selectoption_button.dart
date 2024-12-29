import 'package:flutter/material.dart';

class ProfileSelectoptionButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const ProfileSelectoptionButton({
    Key? key,
    required this.label,
    required this.iconPath,
    required this.onPressed,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      width: width * 0.8,
      height: height * 0.08,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.transparent,
          side: const BorderSide(width: 0, color: Colors.transparent),
          minimumSize: Size(width * 0.8, height * 0.08),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image.asset(
            iconPath,
            width: width * 0.09,
            height: height * 0.09,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Inter",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: Colors.white,
            ),
          ),
        ]),
      ),
    );
  }
}
