import 'package:first_app/Components/product_list_component/show_list_items/list_items.dart';
import 'package:first_app/View_Page/edit_page_comboView/edit_main_page.dart';
import 'package:first_app/View_Page/manual_input._page.dart';
import 'package:first_app/model/track_user_product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class ProductListComponent extends StatefulWidget {
  //Truyền vào List<TrackedUserProduct> trackedUserProductList;
  List<TrackedUserProduct> trackedUserProductList = [];
  ProductListComponent(this.trackedUserProductList, {super.key});

  @override
  State<ProductListComponent> createState() => _ProductListComponent();
}



class _ProductListComponent extends State<ProductListComponent> {


  Future<void> navigateToEditMainPage(BuildContext context, TrackedUserProduct trackedUserProduct, int index) async{
    await Navigator.push(
      context,
      PageTransition(
        child: EditMainPage.edited(widget.trackedUserProductList, trackedUserProduct, index, true, false),
        type: PageTransitionType.rightToLeft,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }


  List<Container> _buildProductList(BuildContext context){
    //Code here
    int size = widget.trackedUserProductList.length;
    return List.generate(size, (i) => 
      Container(
        child: widget.trackedUserProductList[i].isOpened()
        ? ListItems(
          imageList: widget.trackedUserProductList[i].getImagePath(), 
          imageTag: 'assets/tag_icon.png', 
          statusTag: "Dùng ngay", 
          itemName: widget.trackedUserProductList[i].getProductName(), 
          expireDate: parseIntoDifDateFormat("yyyy-MM-dd HH:mm", "dd/MM/yyyy", widget.trackedUserProductList[i].getExpiryDate()), 
          quantity: widget.trackedUserProductList[i].getQuantity().toString(), 
          onPressed: (){
            navigateToEditMainPage(context, widget.trackedUserProductList[i], i);
          })
        
        : ListItems.notOpened(
          imageList: widget.trackedUserProductList[i].getImagePath(), 
          itemName: widget.trackedUserProductList[i].getProductName(), 
          expireDate: parseIntoDifDateFormat("yyyy-MM-dd HH:mm", "dd/MM/yyyy", widget.trackedUserProductList[i].getExpiryDate()), 
          quantity: widget.trackedUserProductList[i].getQuantity().toString(), 
          onPressed: (){
            navigateToEditMainPage(context, widget.trackedUserProductList[i], i);
          })
      )
    );
  }

    String parseIntoDifDateFormat(String currentDateFormat, String parseDateFormat, String? dateString){
    DateFormat dateFormat = DateFormat(currentDateFormat); 
    DateTime dateTime = dateFormat.parse(dateString.toString());
    return DateFormat(parseDateFormat).format(dateTime) ;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Container(
        width: width * 0.9,
        child: Column(
          children: _buildProductList(context)
          // [ //Đổ lại
          //   // Item 1
          //   ListItems(
          //     imageList: "assets/category/product_list_1.png", //assets/product/imagePath
          //     imageTag: 'assets/tag_icon.png',//isOpened? ListItems():ListItems.notOpened()
          //     statusTag: 'Dùng ngay!', //isOpened? ListItems():ListItems.notOpened()
          //     itemName: 'Kem dưỡng da', //.productName
          //     expireDate: '27/3/2025', //.expiryDate
          //     quantity: '3', //.quantity
          //     onPressed: () {}, //EditMainPage.onEdit()
          //   ),

          //   const SizedBox(height: 15),
          // ],
        ));
  }
}
