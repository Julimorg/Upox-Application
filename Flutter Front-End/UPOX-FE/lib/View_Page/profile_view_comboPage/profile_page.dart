import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/homepage_component/content_component.dart';
import 'package:first_app/Components/profile_component/profile_background.dart';
import 'package:first_app/Components/profile_component/profile_selectchoose.dart';
import 'package:first_app/Components/profile_component/profile_username.dart';
import 'package:first_app/View_Page/homepage_comboPage/homepage_content.dart';
import 'package:first_app/View_Page/homepage_comboPage/homepage_mainview.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: ProfileBackground(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Back Button
            const SizedBox(height: 10),
            const BackButtonComponent(
              targetPage: HomepageContent(),
              iconColor: Colors.white,
              textColor: Colors.white,
              labelText: "Back",
            ),
            const SizedBox(height: 20),
            Container(
                child: const Column(children: [
              ProfileUsername(),
              SizedBox(height: 20),
              ProfileSelectchoose(),
            ]))
          ],
        )),
      ),
    );
  }
}
