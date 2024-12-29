import 'package:flutter/material.dart';

class Customeonpressedbutton extends StatelessWidget {
  final String filterName;
  final Color textColor;
  final String fontFamily;
  final FontWeight fontWeight;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? bottomBorderColor;

  const Customeonpressedbutton({
    Key? key,
    required this.filterName,
    required this.textColor,
    required this.fontFamily,
    required this.fontWeight,
    required this.onPressed,
    required this.backgroundColor,
    this.bottomBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4.0),
        splashColor: Colors.blue.withOpacity(0.2),
        highlightColor: Colors.blue.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: bottomBorderColor != null
                ? Border(
                    bottom: BorderSide(
                      color: bottomBorderColor!,
                      width: 2.0,
                    ),
                  )
                : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            filterName,
            style: TextStyle(
              color: textColor,
              fontFamily: fontFamily,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
