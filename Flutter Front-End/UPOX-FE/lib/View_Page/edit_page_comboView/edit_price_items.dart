import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/edit_page_component/edit_price.dart';
import 'package:first_app/Components/edit_page_component/edit_volume_page_fieldtext.dart';
import 'package:first_app/View_Page/edit_page_comboView/edit_main_page.dart';
import 'package:first_app/model/product_default_response.dart';
import 'package:first_app/model/track_user_product.dart';

import 'package:flutter/material.dart';

class EditPriceItemsPage extends StatelessWidget {
  Map<String,List<int>> costSuggested; //Đổ dữ liệu
  List<TrackedUserProduct> trackedUserProductList; //Truyền vào khi gọi return edit_main_page
  ProductDefaultResponse productDefault; //Truyền vào khi gọi return edit_main_page

  //IS EDITED
  bool isEdited = false;
  String dateBought = "";
  int? editedCost;

  EditPriceItemsPage(this.costSuggested, this.trackedUserProductList, 
  this.productDefault, {super.key});

  EditPriceItemsPage.isEdited(this.costSuggested, this.trackedUserProductList, 
  this.productDefault, this.isEdited, this.editedCost, this.dateBought, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Back Button
          const SizedBox(height: 10),
          BackButtonComponent(
            targetPage: EditMainPage(trackedUserProductList, productDefault),
            iconColor: Colors.blue,
            textColor: Colors.blue,
            labelText: "Back",
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isEdited
                    ? EditPrice.isEdited(costSuggested, editedCost, dateBought) //Cost đã được edit và ngày đã mua
                    : EditPrice(costSuggested),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      )),
    );
  }
}
