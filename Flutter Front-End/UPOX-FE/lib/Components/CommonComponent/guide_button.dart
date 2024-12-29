import 'package:flutter/material.dart';

class GuideButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GuideButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Container(
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory, // Bỏ hoạt ảnh splash
          overlayColor: Colors.transparent,
        ),
        label: Image.asset(
          "assets/guide_icon.png",
          width: width * 0.1,
          height: height * 0.04,
        ),
      ),
    );
  }
}
