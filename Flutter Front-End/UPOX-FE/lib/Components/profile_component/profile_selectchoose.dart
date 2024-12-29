import 'dart:developer';

import 'package:first_app/Components/Alert_Component/log_out_alert/log_out_alert.dart';
import 'package:first_app/Components/Alert_Component/warning_alert/aler_component.dart';
import 'package:first_app/Components/profile_component/profile_selectoption_button.dart';
import 'package:first_app/View_Page/detail_product_combo_view/detail_product_page.dart';
import 'package:first_app/View_Page/notification_view.dart';
import 'package:first_app/View_Page/profile_view_comboPage/personal_profile_page.dart';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSelectchoose extends StatelessWidget {
  const ProfileSelectchoose({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Container(
        // color: Colors.blueAccent,
        margin:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.145),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          // Profile Button
          ProfileSelectoptionButton(
            label: "Trang cá nhân",
            iconPath: 'assets/user_profile_icon.png',
            onPressed: () {
              log("Comming soon");
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlerComponent('assets/alertPath/comingsoon_banner.png'); // Gọi AlertDialog
                },
              );
              // Navigator.push(
              //     context,
              //     PageTransition(
              //         // Xử lý tạm
              //         child: const PersonalProfilePage(),
              //         type: PageTransitionType.rightToLeft,
              //         duration: const Duration(milliseconds: 300))
              // );
            },
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),

          // Noti Button
          ProfileSelectoptionButton(
            label: "Thông báo",
            iconPath: 'assets/noti_icon.png',
            onPressed: () {
              //Show thông báo
              log('Notification List');
              Navigator.push(
                      context,
                      PageTransition(
                        child: const NotificationView(),
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 400),
                      ),
              );
            },
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          // Setting button
          ProfileSelectoptionButton(
            label: "Cài đặt",
            iconPath: 'assets/setting_icon.png',
            onPressed: () {
              log("Comming soon");
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlerComponent('assets/alertPath/comingsoon_banner.png'); // Gọi AlertDialog
                },
              );
              // Navigator.push(
              //     context,
              //     PageTransition(
              //         // Xử lý tạm
              //         child: const DetailProductPage(),
              //         type: PageTransitionType.rightToLeft,
              //         duration: const Duration(milliseconds: 300)));
            },
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),

          // Call button
          ProfileSelectoptionButton(
            label: "Chăm sóc khách hàng",
            iconPath: 'assets/call_icon.png',
            onPressed: () {
              log('Comming soon');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlerComponent('assets/alertPath/comingsoon_banner.png'); // Gọi AlertDialog
                },
              );
            },
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),

          const SizedBox(height: 40),

          // Logout button
          ProfileSelectoptionButton(
            label: "Đăng xuất!",
            iconPath: 'assets/logout_icon.png',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertContainer(); // Gọi AlertDialog
                },
              );
            },
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ]));
  }
}
