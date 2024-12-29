import 'package:first_app/model/track_user_product.dart';
import 'package:first_app/model/track_user_product_response.dart';
import 'package:flutter/material.dart';

class InventoryItems extends StatefulWidget {
   String iconBox;
   String statusIcon;
   String itemImage;
   String itemTitle;
   Color itemTitleColor;
   String iconBox2;
   String itemQuantity;
   String itemDescrip;
   Color itemDescripBackgroundColor;
   VoidCallback onPressed;
   String statusName;
  List<TrackedUserProductResponse> trackedSameProduct = [];

  void setTrackedSameProduct(List<TrackedUserProductResponse> trackedSameProduct_){
    trackedSameProduct = trackedSameProduct_;
  }

  InventoryItems(
      {super.key,
      required this.iconBox,
      required this.itemImage,
      required this.itemTitle,
      required this.itemTitleColor,
      required this.iconBox2,
      required this.itemQuantity,
      required this.itemDescrip,
      required this.itemDescripBackgroundColor,
      required this.onPressed,
      required this.statusIcon,
      required this.statusName});

  @override
  State<InventoryItems> createState() => _InventoryItemsState();
}

class _InventoryItemsState extends State<InventoryItems> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.4,
      height: screenHeight * 0.34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 4, // Phạm vi bóng
            blurRadius: 5, // Độ mờ của bóng
            offset: const Offset(0, 4), // Vị trí bóng
          ),
        ],
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          children: [
            //? Header Items
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.statusIcon.isEmpty
                  ?SizedBox(
                    width: screenWidth * 0.1,
                    height: screenHeight * 0.05,
                  )
                  :Container(
                    child: Image.asset(
                      widget.statusIcon,
                      width: screenWidth * 0.1,
                      height: screenHeight * 0.05,
                    ),
                  ),
                  widget.iconBox.isEmpty
                  ?SizedBox(
                    width: screenWidth * 0.05,
                    height: screenHeight * 0.05,
                  )
                  :Container(
                    child: Image.asset(
                      widget.iconBox,
                      width: screenWidth * 0.1,
                      height: screenHeight * 0.05,
                    ),
                  ),
                ],
              ),
            ),
            //? Item Image
            Container(
              child: Image.asset(
                widget.itemImage,
                width: 140,
                height: 100,
              ),
            ),
            const SizedBox(height: 5),
            //? Content Items
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(
                      widget.itemTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Roboto",
                        color: widget.itemTitleColor,
                      ),
                    ),
                  ]),
                  Row(
                    children: [
                      Image.asset(
                        widget.iconBox2,
                        width: screenWidth * 0.07,
                        height: screenHeight * 0.05,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.itemQuantity,
                        style: const TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //? Just a Span
            Container(
              color: const Color(0xff8D8D8DE5),
              width: screenWidth * 0.35,
              height: 0.7,
            ),
            const SizedBox(height: 10),
            //? Description Item
            Container(
              
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
              decoration: BoxDecoration(
                color: widget.itemDescripBackgroundColor,
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  colors: [
                    widget.itemDescripBackgroundColor.withOpacity(0.3),
                  Colors.white,
                  ]
                )
              ),
              child: Text(
                widget.itemDescrip,
                style: const TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 11.5,
                  //backgroundColor: widget.itemDescripBackgroundColor,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
