import 'dart:developer';

import 'package:first_app/View_Page/homepage_comboPage/homepage_mainview.dart';
import 'package:first_app/View_Page/loginPage.dart';
import 'package:first_app/View_Page/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ButtonOnClick extends StatelessWidget {
  const ButtonOnClick({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: const LoginPage(),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 600)));
          },
          child: const Text('Đăng nhập'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () {
            // Xử lý khi nhấn Tạo tài khoản
            // Xử lý nút Đăng Kí
            Navigator.push(
                context,
                PageTransition(
                    child: const SignUpPage(),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 600)));
          },
          child: const Text('Tạo tài khoản'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            minimumSize: const Size(200, 50),
            side: const BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            log("Đây là điều khoản của chúng tôi!!!");
            // Navigator.push(
            //     context,
            //     PageTransition(
            //         // Xử lý tạm
            //         child: const HomepageMainview("NOT A TOKEN", "NOT A TOKEN"),
            //         type: PageTransitionType.rightToLeft,
            //         duration: const Duration(milliseconds: 600)));
          },
          child: const Text(
            'Chính sách và Điều khoản',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
