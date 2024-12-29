import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String filterName;
  final VoidCallback onPressed;
  final double? widthFactor;
  final double? heightFactor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  const CustomTextButton({
    super.key,
    required this.filterName,
    required this.onPressed,
    this.widthFactor,
    this.heightFactor,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xffF3F3F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: borderColor ?? Colors.transparent),
          ),
          minimumSize: Size(
            (screenSize.width * (widthFactor ?? 0.08)),
            (screenSize.height * (heightFactor ?? 0.08)),
          ),
        ),
        child: Text(
          filterName,
          style: TextStyle(
            fontFamily: fontFamily ?? "Istok Web",
            fontWeight: fontWeight ?? FontWeight.w400,
            fontSize: fontSize ?? 15,
            color: textColor ?? Colors.black,
          ),
        ),
      ),
    );
  }
}
