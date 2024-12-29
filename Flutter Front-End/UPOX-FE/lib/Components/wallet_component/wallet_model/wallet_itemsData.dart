import 'dart:developer';

import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WalletItemsdata extends StatelessWidget {
  final String itemName;
  final String itemImage;
  final String itemPrice;
  final String progressNum;
  final Color statusColor;
  final VoidCallback onPressed;
  final double percent;

  const WalletItemsdata(
      {super.key,
      required this.itemName,
      required this.itemImage,
      required this.itemPrice,
      required this.onPressed,
      required this.progressNum,
      required this.statusColor,
      required this.percent});

  @override
  Widget build(BuildContext context) {
    log( "Color: ${statusColor.toString()}");
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(

      width: screenWidth * 0.8,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Color(0xffE3E3E3)),
        ),
        // color: Colors.amberAccent
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Item Image
                Container(
                  // color: Colors.brown,
                  child: Image.asset(
                    itemImage,
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 15),
                // Item Content
                Container(
                  // color: Colors.brown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(
                        titleName: itemName,
                        fontFam: "inter",
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        textColor: Colors.black,
                      ),
                      TitleText(
                        titleName: itemPrice,
                        fontFam: "inter",
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        textColor: const Color(0xffB1B1B1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Progress Data
            Container(
              // color: Colors.brown,
              width: screenWidth * 0.2,
              height: screenHeight * 0.055,
              child: CircularPercentIndicator(
                radius: 20.0,
                lineWidth: 2.5,
                percent: percent,
                center: TitleText(
                  titleName: progressNum,
                  fontFam: "inter",
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.black,
                ),
                progressColor: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
