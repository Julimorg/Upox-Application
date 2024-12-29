import 'package:flutter/material.dart';

class ItemUsedComponent extends StatelessWidget {
  bool isOpened = false;
  final String? itemImage;
  final VoidCallback onPressed;
  ItemUsedComponent(this.isOpened, {super.key, this.itemImage, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    String originalImagePath = "assets/product/inUse";
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Container(

      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Opacity(
          opacity: !isOpened? 0.4 : 1.0,
          child: Image.asset(
            "$originalImagePath${itemImage!}_inUse.png",
            height: 60,
            width: 60,
          ),
        ),
      ),
    );
  }
}
