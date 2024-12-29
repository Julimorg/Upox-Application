import 'package:flutter/material.dart';

class PersonalEditSelection extends StatelessWidget {
  final String labelText;
  final String weightText;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final String? iconImage;
  final Color? dotColor;
  final String? fontFamily;
  final double? fontSize;
  final Color? textColor;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;

  const PersonalEditSelection({
    super.key,
    required this.labelText,
    required this.weightText,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.onPressed,
    required this.width,
    required this.height,
    this.iconImage,
    this.dotColor,
    this.fontFamily,
    this.fontSize,
    this.textColor,
    this.fontWeight,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.95,
      height: height * 0.045,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: [gradientStartColor, gradientEndColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Dấu chấm có thể thay đổi màu
              Container(
                width: 5,
                height: 5,
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: 8, // Khoảng cách giữa dấu chấm và Text
                ),
                decoration: BoxDecoration(
                  color: dotColor ?? Colors.grey, // Màu của dấu chấm
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                // color: Colors.amber,
                width: width * 0.57,
                child: Text(
                  labelText,
                  style: TextStyle(
                      fontFamily: fontFamily ?? "inter",
                      fontSize: fontSize ?? 20,
                      fontWeight: fontWeight ?? FontWeight.w700,
                      color: textColor ?? const Color.fromARGB(255, 7, 2, 2),
                      fontStyle: fontStyle ?? FontStyle.normal),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              weightText,
              style: const TextStyle(
                fontFamily: "inter",
                fontSize: 18,
                fontWeight: FontWeight.w200,
                color: Color(0xff7D7D7D),
              ),
            ),
          ),
          const SizedBox(width: 10),
          iconImage != null
              ? TextButton.icon(
                  onPressed: onPressed,
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: Colors.transparent,
                  ),
                  label: SizedBox(
                    child: Image.asset(
                      iconImage!,
                      width: width * 0.05,
                      height: height * 0.05,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
