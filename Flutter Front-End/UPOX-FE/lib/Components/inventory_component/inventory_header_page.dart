import 'package:first_app/Components/CommonComponent/guide_button.dart';
import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InventoryHeaderPage extends StatefulWidget {
  const InventoryHeaderPage({super.key});

  @override
  State<InventoryHeaderPage> createState() => _InventoryHeaderPageState();
}

class _InventoryHeaderPageState extends State<InventoryHeaderPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Container(
      height: height * 0.12,
      margin: const EdgeInsets.only(
        top: 5,
        left: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                child: const TitleText(titleName: " Kho của bạn "),
              ),
              Container(
                child: Image.asset(
                  "assets/icon_lookAroundGif.gif",
                  height: height * 0.13,
                  width: width * 0.2,
                ),
              )
            ],
          ),
          Container(
            child: GuideButton(
              onPressed: () {
                print("Inventory");
              },
            ),
          ),
        ],
      ),
    );
  }
}
