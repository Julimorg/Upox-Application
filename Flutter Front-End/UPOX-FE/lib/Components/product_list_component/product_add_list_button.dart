import 'package:first_app/View_Page/manual_input._page.dart';
import 'package:first_app/model/track_user_product.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ProductAddListButton extends StatefulWidget {
  List<TrackedUserProduct> trackedUserProductList = [];
  
  ProductAddListButton(this.trackedUserProductList, {super.key});
  ProductAddListButton.initialize({super.key});

  @override
  State<ProductAddListButton> createState() => _ProductAddListButton();
}

class _ProductAddListButton extends State<ProductAddListButton> {
  @override
  Widget build(BuildContext context) {
    return //  Add Button
        Container(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: ManualInputPage(widget.trackedUserProductList),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 300)));
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          // Set border to none
          elevation: 0,
          side: const BorderSide(width: 0, color: Colors.blue),
          padding: const EdgeInsets.all(10), // Điều chỉnh kích thước padding
          backgroundColor: Colors.white, // Màu nền của nút
        ),
        child: Image.asset(
          'assets/plus_icon.png',
          color: Colors.blue,
          width: 35,
          height: 35,
        ),
      ),
    );
  }
}
