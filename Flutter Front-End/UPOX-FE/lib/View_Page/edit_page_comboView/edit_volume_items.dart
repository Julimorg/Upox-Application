import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/edit_page_component/edit_volume_page_fieldtext.dart';
import 'package:first_app/View_Page/edit_page_comboView/edit_main_page.dart';
import 'package:first_app/model/product_default_response.dart';
import 'package:first_app/model/track_user_product.dart';

import 'package:flutter/material.dart';

class EditVolumeItemsPage extends StatelessWidget {
  Map<String,List<int>> volumeSuggested; //Đổ dữ liệu
  List<TrackedUserProduct> trackedUserProductList; //Truyền vào khi gọi return edit_main_page
  ProductDefaultResponse productDefault; //Truyền vào khi gọi return edit_main_page
  //volumeUnit hiển thị
  String volumeUnit = "";
  int? editedVolume;
  bool isEdited = false;


  EditVolumeItemsPage(this.volumeSuggested, this.volumeUnit, this.trackedUserProductList, 
  this.productDefault, {super.key});

  EditVolumeItemsPage.isEdited(this.volumeSuggested, this.volumeUnit, this.trackedUserProductList, 
  this.productDefault, this.isEdited, this.editedVolume, {super.key});


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
            targetPage: EditMainPage(trackedUserProductList, productDefault), //Đổ dữ liệu lại
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
                    ?EditVolumePageFieldtext.isEdited(volumeSuggested, volumeUnit, editedVolume)
                    :EditVolumePageFieldtext(volumeSuggested, volumeUnit),
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
