import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class EditSelectOptionBar extends StatelessWidget {
  final String labelText;
  final String weightText;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final VoidCallback onPressed;
  final double width;
  final double height;
  String iconImage = "assets/edit_button.png";
  
  //isEdited == true: 
   EditSelectOptionBar(
    {
    Key? key,
    required this.labelText,
    required this.weightText,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.onPressed,
    required this.width,
    required this.height,
  }) : super(key: key);

  EditSelectOptionBar.cantEdit({
    Key? key,
    required this.iconImage,
    required this.labelText,
    required this.weightText,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.onPressed,
    required this.width,
    required this.height,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    log("${this.labelText}");
    log("${this.weightText}");
    log("${this.gradientStartColor}");
    log("${this.gradientEndColor}");
    log("${this.onPressed}");
    log("${this.width}");
    log("${this.height}");
    log("${this.iconImage}");




    return Container(
      width: width * 0.965,
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
          Container(
            // color: Colors.yellow,
            width: width * 0.42,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.01,
            ),
            child: Text(
              "$labelText: ",
              style: const TextStyle(
                fontFamily: "inter",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xff363636),
              ),
            ),
          ),
          // Số khối lượng
          Container(
            // color: Colors.cyan,
            width: width * 0.35,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.00,
            ),
            // color: Colors.cyan,
            alignment: Alignment.centerLeft, // Ensure the text is centered
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
          Container(
            // margin: EdgeInsets.only(right: width*0.01),
            // color: Colors.yellowAccent,
            width: width * 0.1,
            child: TextButton.icon(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                overlayColor: Colors.transparent,
              ),
              label: iconImage!.isEmpty
              ? SizedBox(
                width: width * 0.05,
                  height: height * 0.05,
              )
              : Container(
                // color: Colors.teal,
                child: Image.asset(
                  iconImage,
                  width: width * 0.05,
                  height: height * 0.05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
