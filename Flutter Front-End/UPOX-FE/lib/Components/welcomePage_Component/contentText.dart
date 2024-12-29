import 'package:flutter/material.dart';

class ContentText extends StatelessWidget {
  const ContentText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text "Shopping vô lo!"
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shopping vô lo!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8), // Khoảng cách giữa 2 đoạn text
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thanh Span
                  Container(
                    width: 2,
                    height: 40,
                    color: Colors.lightBlueAccent,
                  ),

                  const SizedBox(width: 8), // Khoảng cách giữa 2 đoạn text

                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mua sắm thỏa thích',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      Text(
                        'Tiêu dùng thông minh',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 10),

          // Icon img
          Image.asset(
            'assets/Icon_box_lookDown.png',
            width: 69,
            height: 75,
          ),
        ],
      ),
    );
  }
}
