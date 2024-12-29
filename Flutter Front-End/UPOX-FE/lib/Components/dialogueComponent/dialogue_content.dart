import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogueContentText extends StatefulWidget {
  const DialogueContentText({super.key});

  @override
  _DialogueContentTextState createState() => _DialogueContentTextState();
}

class _DialogueContentTextState extends State<DialogueContentText> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Load username từ SharedPreferences khi widget khởi tạo
  }

  // Hàm để load tên người dùng đã lưu trong SharedPreferences
  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username =
          prefs.getString('username') ?? 'Guest'; // --> Set default cho tên
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color(0xfff5f5f5),
      ),
      child: Column(
        children: [
          Text(
            "Buổi Sáng vui vẻ nhé $_username !\nUti có thể giúp gì được cho bạn",
            style: const TextStyle(
              fontSize: 15,
              letterSpacing: 0.5,
              fontFamily: "Cuprum",
              fontWeight: FontWeight.w400,
              color: Color(0xff1d2f82),
            ),
          ),
        ],
      ),
    );
  }
}
