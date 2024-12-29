import 'package:first_app/Components/CommonComponent/guide_button.dart';
import 'package:first_app/Components/CommonComponent/textbutton_imageicon_right.dart';
import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:first_app/View_Page/detail_product_combo_view/detail_product_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class WalletPageHeader extends StatelessWidget {
  const WalletPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      // color: Colors.amber,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            const TitleText(
              titleName: "Chi tiêu của bạn",
              fontSize: 25,
              fontWeight: FontWeight.w700,
              fontFam: "Inter",
            ),
            const SizedBox(width: 5),
            GuideButton(
              onPressed: () {},
            )
          ],
        ),
        CustomTextButtonImageIconRight(
          filterName: "",
          iconImage: "assets/more_icon.png",
          backgroundColor: Colors.white,
          widthFactor: 0.01,
          heightFactor: 0.01,
          iconWidth: 15,
          iconHeight: 15,
          onPressed: () {},
        )
      ]),
    );
  }
}
