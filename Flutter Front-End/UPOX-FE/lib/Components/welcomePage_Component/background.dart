import 'package:flutter/material.dart';

class BackgroundComponent extends StatelessWidget {
  final Widget child;

  const BackgroundComponent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Đây có thể là hình nền hoặc màu nền
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/welcome_screen.png"), // Đảm bảo ảnh tồn tại trong folder assets
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Widget con được truyền vào
        child,
      ],
    );
  }
}
