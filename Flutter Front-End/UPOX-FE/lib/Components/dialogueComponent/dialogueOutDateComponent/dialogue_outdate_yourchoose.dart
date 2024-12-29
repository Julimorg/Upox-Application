import 'package:flutter/material.dart';

class DialogueOutdateYourchoose extends StatelessWidget {
  const DialogueOutdateYourchoose({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Button 1
        Align(
          alignment: Alignment.centerLeft, // Đặt nút sang trái
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xffececec),
              padding: const EdgeInsets.all(15),
            ),
            child: const Text(
              " Cho tôi xem các sản phẩm đó ",
              style: TextStyle(
                fontFamily: "Cuprum",
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xff000000),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Button 2
        Align(
          alignment: Alignment.centerLeft, // Đặt nút sang trái
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xffececec),
              padding: const EdgeInsets.all(15),
            ),
            child: const Text(
              " Thông báo sau cho tôi nha ",
              style: TextStyle(
                fontFamily: "Cuprum",
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xff000000),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
