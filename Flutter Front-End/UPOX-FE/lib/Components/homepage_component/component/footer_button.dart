import 'package:flutter/material.dart';

class FooterSelectButton extends StatelessWidget {
  //?Default element attributes
  final VoidCallback onPressed;
  final String imagePath;
  final Color backgroundColor;
  final double imageSize;
  final Color imageColor;

  const FooterSelectButton({
    Key? key,
    required this.onPressed,
    required this.imagePath,
    this.backgroundColor = Colors.blue,
    this.imageSize = 25.0,
    this.imageColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Truyền sự kiện
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        backgroundColor: backgroundColor,
        elevation: 0,
        side: BorderSide(width: 0, color: backgroundColor),
      ),
      child: Image.asset(
        imagePath,
        color: imageColor,
        width: imageSize,
        height: imageSize,
      ),
    );
  }
}
