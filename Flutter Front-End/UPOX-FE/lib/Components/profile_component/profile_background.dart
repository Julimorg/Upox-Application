import 'package:flutter/material.dart';

class ProfileBackground extends StatelessWidget {
  final Widget child;

  const ProfileBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Đây có thể là hình nền hoặc màu nền
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/profile_background.png"), // Đảm bảo ảnh tồn tại trong folder assets
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
