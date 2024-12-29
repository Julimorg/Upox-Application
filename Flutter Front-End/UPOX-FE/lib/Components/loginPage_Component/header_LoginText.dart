import 'package:flutter/material.dart';

class HeaderContentText extends StatelessWidget {
  const HeaderContentText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: const Stack(
        children: [
          const Text(
            "Bạn quay trở lại rồi ư!",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                letterSpacing: 0.5),
          ),
          Positioned(
              top: 40,
              child: Text(
                "Đăng nhập vào tài khoảng thôi.",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff8bd3ff),
                    letterSpacing: 0.5),
              ))
        ],
      ),
    );
  }
}
