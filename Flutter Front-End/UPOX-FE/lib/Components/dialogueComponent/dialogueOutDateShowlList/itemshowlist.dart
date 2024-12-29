import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:flutter/material.dart';

class Itemshowlist extends StatelessWidget {
  final String? itemName;
  final String? itemCount;
  const Itemshowlist({super.key, this.itemName, this.itemCount});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      // color: Colors.amber,
      width: screenWidth * 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleText(
            titleName: itemName!,
            fontFam: "Cuprum",
            fontWeight: FontWeight.w400,
            fontSize: 15,
            textColor: const Color(0xff1D2F82),
          ),
          TitleText(
            titleName: "x $itemCount",
            fontFam: "Cuprum",
            fontWeight: FontWeight.w400,
            fontSize: 15,
            textColor: const Color(0xff1D2F82),
          ),
        ],
      ),
    );
  }
}
