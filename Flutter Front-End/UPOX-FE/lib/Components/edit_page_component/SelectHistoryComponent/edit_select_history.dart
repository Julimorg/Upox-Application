import 'package:flutter/material.dart';

class SelectHistoryButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color? iconColor; // Màu icon (nếu có)
  final double width;
  final double height;
  final double borderRadius;
  final String? iconPath; // Đường dẫn icon (tùy chọn)
  final VoidCallback onPressed;

  const SelectHistoryButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.iconColor,
    required this.width,
    required this.height,
    this.borderRadius = 20.0,
    this.iconPath,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(4.5),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(width: 2, color: borderColor),
          ),
        ),
        icon: iconPath != null
            ? Image.asset(
                iconPath!,
                width: width * 0.18,
                height: height * 0.8,
                color: iconColor,
                fit: BoxFit.contain,
              )
            : const SizedBox.shrink(),
        label: Text(
          text,
          style: TextStyle(
            fontFamily: "inter",
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
