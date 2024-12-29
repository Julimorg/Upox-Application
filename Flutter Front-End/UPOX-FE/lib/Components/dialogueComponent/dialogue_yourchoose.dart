import 'dart:developer';

import 'package:first_app/View_Page/dialogue_comboPage/dialogue_addi_page.dart';
import 'package:first_app/View_Page/dialogue_comboPage/dialogue_outdate_page.dart';
import 'package:first_app/View_Page/manual_input._page.dart';
import 'package:first_app/model/track_user_product.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class DialogueChooseButton extends StatelessWidget {
  const DialogueChooseButton({super.key});

  @override
  Widget build(BuildContext context) {
    List<TrackedUserProduct> defaultProductList = [];

    return Column(
      children: [
        // Button 1
        Align(
          alignment: Alignment.centerLeft, // Đặt nút sang trái
          child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: ManualInputPage(defaultProductList),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 400)));
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xffececec),
              padding: const EdgeInsets.all(15),
            ),
            child: const Text(
              " Thêm đồ thôi Ulti ",
              style: TextStyle(
                fontFamily: "Cuprum",
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xff000000),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Button 2
        Align(
          alignment: Alignment.centerLeft, // Đặt nút sang trái
          child: TextButton(
            onPressed: () {
              //Comming soon
              log("Comming soon");
              // Navigator.push(
              //     context,
              //     PageTransition(
              //         child: const DialogueOutdatePage(),
              //         type: PageTransitionType.rightToLeft,
              //         duration: const Duration(milliseconds: 600)
              //     )
              // );
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xffececec),
              padding: const EdgeInsets.all(15),
            ),
            child: const Text(
              " Danh Sách các sản phẩm gần hết ",
              style: TextStyle(
                fontFamily: "Cuprum",
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xff000000),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
