import 'package:flutter/material.dart';

class TimeOutBackground extends StatelessWidget {
  final String timeOutImagePath;
  final Widget child;

  const TimeOutBackground(
      {super.key, required this.timeOutImagePath, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(timeOutImagePath),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
