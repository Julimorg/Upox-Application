import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUsername extends StatefulWidget {
  const ProfileUsername({super.key});

  @override
  _ProfileUsername createState() => _ProfileUsername();
}

class _ProfileUsername extends State<ProfileUsername> {
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
          prefs.getString('USER_NAME') ?? 'Guest'; // --> Set default cho tên
    });
  }

  @override
  Widget build(BuildContext context) {
    double leftMargin = MediaQuery.of(context).size.width * 0.035;
    return Container(
      child: Row(
        children: [
          // First Char username
          Container(
            margin: EdgeInsets.only(left: leftMargin),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xfff58639C),
            ),
            child: Text(
              _username.isNotEmpty ? _username[0].toUpperCase() : 'G',
              style: const TextStyle(
                fontSize: 30,
                letterSpacing: 0.5,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
                color: Color(0xffFFFFFF),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // FullName user
          Container(
            child: Text(
              "$_username",
              style: const TextStyle(
                fontSize: 22,
                letterSpacing: 0.5,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
                color: Color(0xffFFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
