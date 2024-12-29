import 'package:flutter/material.dart';

class ManualHistoryText extends StatefulWidget {
  

  const ManualHistoryText({super.key});

  @override
  State<ManualHistoryText> createState() => _ManualHistoryText();
}

class _ManualHistoryText extends State<ManualHistoryText> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          " Sản phẩm đã thêm gần đây",
          style: TextStyle(
            fontFamily: "inter",
            fontWeight: FontWeight.w700,
            color: Color(0xff363636),
          ),
        ),
      ],
    );
  }
}
