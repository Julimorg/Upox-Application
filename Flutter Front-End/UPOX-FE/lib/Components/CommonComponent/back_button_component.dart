import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class BackButtonComponent extends StatelessWidget {
  final Widget targetPage;
  final Color iconColor;
  final Color textColor;
  final String labelText;

  const BackButtonComponent({
    super.key,
    required this.targetPage,
    this.iconColor = Colors.blue,
    this.textColor = Colors.blue,
    this.labelText = "Back",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: .0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: targetPage,
                    type: PageTransitionType.leftToRight,
                    duration: const Duration(milliseconds: 300)));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: iconColor,
                size: 16,
              ),
              const SizedBox(width: 1),
              Text(
                labelText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
