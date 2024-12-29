import 'package:flutter/material.dart';

class AlertComponent extends StatelessWidget {
  final String alertImagePath;
  final Widget child;

  const AlertComponent(
      {super.key, required this.alertImagePath, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(alertImagePath),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
