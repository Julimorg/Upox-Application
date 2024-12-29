import 'package:flutter/material.dart';

class HeaderSignUpContext extends StatelessWidget {
  const HeaderSignUpContext({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width * 1,
      height: screenSize.height * 0.1,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kết bạn với UPOX nhé!",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                letterSpacing: 0.5),
          ),
          const Text(
            "Tạo tài khoản mới thôi.",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff8bd3ff),
                letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}
