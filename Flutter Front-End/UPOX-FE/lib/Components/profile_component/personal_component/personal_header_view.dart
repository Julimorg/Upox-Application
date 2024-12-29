import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/CommonComponent/textbutton.dart';
import 'package:first_app/View_Page/profile_view_comboPage/profile_page.dart';
import 'package:flutter/material.dart';

class PersonalHeaderView extends StatelessWidget {
  const PersonalHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 1,
      height: screenHeight * 0.08,
      // color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: const BackButtonComponent(
              targetPage: ProfilePage(),
              iconColor: Colors.blue,
              textColor: Colors.blue,
              labelText: "Back",
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: CustomTextButton(
              filterName: "Save",
              fontFamily: "Inter",
              fontSize: 15,
              fontWeight: FontWeight.w700,
              widthFactor: 0.03,
              heightFactor: 0.03,
              backgroundColor: Colors.white,
              textColor: const Color(0x8018A0FB),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
