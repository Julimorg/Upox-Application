import 'package:flutter/material.dart';

class TextbuttonImageiconLeft extends StatelessWidget {
  final String? filterName;
  final VoidCallback onPressed;
  final double? widthFactor;
  final double? heightFactor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? iconImage;
  final Color? iconColor;
  final double? iconWidth;
  final double? iconHeight;
  const TextbuttonImageiconLeft({
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
    this.iconImage,
    this.iconColor,
    this.iconWidth,
    this.iconHeight,
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
          fixedSize: Size(
            (screenSize.width * (widthFactor ?? 0.08)),
            (screenSize.height * (heightFactor ?? 0.08)),
          ),
        ),
        child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconImage!,
                color: iconColor,
                height: iconWidth,
                width: iconHeight,
              ),
              const SizedBox(width: 10),
              Text(
                filterName ?? "",
                style: TextStyle(
                  fontFamily: fontFamily ?? "Istok Web",
                  fontWeight: fontWeight ?? FontWeight.w400,
                  fontSize: fontSize ?? 15,
                  color: textColor ?? Colors.black,
                ),
              ),
              // const SizedBox(width: 10),
            ]),
      ),
    );
  }
}
