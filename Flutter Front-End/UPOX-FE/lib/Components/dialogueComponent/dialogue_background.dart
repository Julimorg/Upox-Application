import 'package:flutter/material.dart';

class DialogueBackground extends StatelessWidget {
  final Widget child;

  const DialogueBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Đây có thể là hình nền hoặc màu nền
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/dialogue_background.png"), // Đảm bảo ảnh tồn tại trong folder assets
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
