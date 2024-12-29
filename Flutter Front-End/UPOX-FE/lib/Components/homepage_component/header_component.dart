

import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:first_app/View_Page/notification_view.dart';

import 'package:first_app/View_Page/profile_view_comboPage/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/model/notification.dart';
import 'dart:developer';

class HeaderHomePage extends StatefulWidget {
  List<NotificationResponse>? notifications = [];

  HeaderHomePage(this.notifications, {super.key});//,this.notifications

  @override
  _HeaderHomePageState createState() => _HeaderHomePageState();
}

class _HeaderHomePageState extends State<HeaderHomePage> {
  String _username = '';

  int getNumOfUnreadNotification(){
    int count = 0;
    widget.notifications!.forEach((noti) {
      if(noti.type!.contains("UNREAD")){
        count++;
      }
    },);
    return count;
  }

  @override
  void initState() {
    log('notifications: ${getNumOfUnreadNotification()}');
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
  
    int? numOfNotifications = widget.notifications?.length;
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.12,
      color: const Color.fromARGB(226, 25, 57, 174),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(
                    text: "Ngày mới năng lượng nhé, ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(190, 167, 207, 255),
                    ),
                  ),
                  TextSpan(
                    text: _username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Bell ring Icon
          Container(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: const NotificationView(),
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 400),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.white,
                    side: const BorderSide(width: 0, color: Colors.white),
                  ),
                  child: Image.asset(
                    'assets/bell_icon.png',
                    color: Colors.blue,
                    width: 25,
                    height: 25,
                  ),
                ),
                // Số thông báo
                Positioned(
                  top: -5,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: TitleText(
                      titleName: "${getNumOfUnreadNotification()}",
                      textColor: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),
          // User Icon
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      // Xử lý tạm
                      child: const ProfilePage(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 400)));
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              backgroundColor: Colors.white,
              side: const BorderSide(width: 0, color: Colors.white),
            ),
            child: Image.asset(
              'assets/user_icon.png',
              width: 25,
              height: 25,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
