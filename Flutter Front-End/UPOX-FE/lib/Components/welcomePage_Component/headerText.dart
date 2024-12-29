import 'package:flutter/material.dart';

class HeaderAppText extends StatelessWidget {
  const HeaderAppText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter, // Đặt chữ ở trên cùng và căn giữa
      child: Text(
        "UPOX",
        style: TextStyle(
          fontSize: 55, // Kích thước lớn hơn
          fontWeight: FontWeight.bold,
          fontFamily: 'Halvar Breitschrift',
          color: Colors.white,
        ),
      ),
    );
  }
}
