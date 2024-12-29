import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String titleName;
  final double? fontSize;
  final Color? textColor;
  final FontWeight? fontWeight;
  final String? fontFam;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  const TitleText({
    super.key,
    required this.titleName,
    this.fontSize,
    this.textColor,
    this.fontWeight,
    this.fontFam,
    this.fontStyle,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        titleName,
        textAlign: textAlign ?? TextAlign.left,
        style: TextStyle(
          fontSize: fontSize ?? 30,
          fontWeight: fontWeight ?? FontWeight.w700,
          color: textColor ?? Colors.black,
          fontFamily: fontFam,
          fontStyle: fontStyle ?? FontStyle.normal,
        ),
      ),
    );
  }
}
