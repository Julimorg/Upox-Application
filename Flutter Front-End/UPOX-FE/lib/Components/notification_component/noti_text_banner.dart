import 'package:flutter/material.dart';

class NotiTextBanner extends StatelessWidget {
  const NotiTextBanner({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Container(
      child: Row(
        children: [
          // Text Banner
          Container(
              child: const Text(
            "Thông báo!",
            style: TextStyle(
              fontSize: 30,
              fontFamily: "inter",
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          )),
          const SizedBox(width: 10),
          // Logo Text Banner
          Container(
            child: Image.asset(
              "assets/bell_icon2.png",
              width: 28,
              height: 28,
            ),
          )
        ],
      ),
    );
  }
}
