import 'package:flutter/material.dart';

class AlertComponent extends StatelessWidget {
  final String alertImagePath;
  final Widget child;

  const AlertComponent(
      {super.key, required this.alertImagePath, required this.child});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Stack(
      children: [
        Container(
          width: screenWidth,
          decoration: BoxDecoration(
            // color: Colors.amber,
            image: DecorationImage(
              image: AssetImage(alertImagePath,),
              fit: BoxFit.contain
            ),
          ),
        ),
        child,
      ],
    );
  }
}
