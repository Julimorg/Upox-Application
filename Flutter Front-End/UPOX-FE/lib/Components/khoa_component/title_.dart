import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget {
  final String title;
  final String content;
  final double screenWidth;
  final double screenHeight;
  const MyTitle({super.key, required this.title, required this.content, 
  required this.screenWidth, required this.screenHeight});
  

  @override
  Widget build(BuildContext context) {
    return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    margin: const EdgeInsets.only(left: 24),
                    child: Text(title, 
                      style: const TextStyle(color: Color(0xFF18A0FB), 
                      fontSize: 25, 
                      fontWeight: FontWeight.w600,)
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    margin: const EdgeInsets.only(left: 24,right: 24+18),
                    child: Text(content, 
                      style: const TextStyle(color: Color(0xFF8BD3FF), 
                      fontSize: 15, 
                      fontWeight: FontWeight.w600,)
                    ),
                  )
                ],
              );
  }
}