import 'package:first_app/View_Page/manual_input._page.dart';
import 'package:first_app/model/track_user_product.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class DialogueAddButton extends StatelessWidget {
  const DialogueAddButton({super.key});

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
                      // Xử lý tạm
                      child: ManualInputPage(defaultProductList),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 600)));
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xffececec),
              padding: const EdgeInsets.all(15),
            ),
            child: const Text(
              " Nhập thủ công, đồ quan trọng! ",
              style: TextStyle(
                fontFamily: "Cuprum",
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xff000000),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Button 2
        Align(
          alignment: Alignment.centerLeft, // Đặt nút sang trái
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xffececec),
              padding: const EdgeInsets.all(15),
            ),
            child: const Text(
              " Tôi chưa shopping gì đâu",
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
