import 'dart:developer';

import 'package:first_app/Components/CommonComponent/guide_button.dart';
import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:first_app/model/track_opened_product_response.dart';
import 'package:first_app/model/track_user_product_response.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductDetailInfo extends StatefulWidget {
  //Set biến thông tin để đổ lên
  late TrackedUserProductResponse productInfo;


  final bool isClickedOpen;
  final Color textColor;
  final Color itemText;
  final List<Color> colorGradient;
  ProductDetailInfo.initialize({
    super.key,
    this.textColor = const Color(0xff18A0FB),
    this.colorGradient = const [
      Color(0xffC0E6FF),
      Color(0xFFFFFFFF),
    ],
    this.itemText = const Color(0xff18A0FB),
    required this.isClickedOpen,
  });

  ProductDetailInfo(
  this.productInfo,
  {
    super.key,
    this.textColor = const Color(0xff18A0FB),
    this.colorGradient = const [
      Color(0xffC0E6FF),
      Color(0xFFFFFFFF),
    ],
    this.itemText = const Color(0xff18A0FB),
    required this.isClickedOpen,
  });

  @override
  State<ProductDetailInfo> createState() => _ProductDetailInfoState();
}

class _ProductDetailInfoState extends State<ProductDetailInfo> {
  late TrackedUserProductResponse productInformation;
  late TrackedOpenedProductResponse openedProductInformation;


  String convertToDateString(DateTime dateTime){
    //Code here
    String formatter = "dd/MM/yyyy";
    return DateFormat(formatter).format(dateTime);
  }

  String findWhenTheyUse(String days){
    switch(days){
      case "1":
        return "ngày";
      case "7":
        return "tuần";
      case "30":
        return "tháng";
      case "365":
        return "năm";
      default:
        return "";
    }
  }

  String convertFrequency(String frequency){
    List<String> fre = frequency.split("/");
    String times = fre[0];
    String days = findWhenTheyUse(fre[1]);
    return "$times lần/$days";
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productInformation = widget.productInfo;
    log("Hiển thị sản phẩm đang dùng: ${!widget.isClickedOpen}");
    if(productInformation.isOpened!){
      openedProductInformation = productInformation.openedProductResponse!;
    }
    else{
      openedProductInformation = TrackedOpenedProductResponse();
    }
  }

  String originalPathCategory = "assets/category";

  @override
  Widget build(BuildContext context) {
    
    
    //? Định dạng tiền tệ bên ngoài
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final price = formatter.format(147000000); // --> giá đã mua
    // bool isOpen = false;

    // void _toggleOpen(bool value) {
    //   setState(() {
    //     isOpen = value;
    //   });
    // }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: Container(
        // color: Colors.grey,
        width: screenWidth * 0.95,
        child: Column(children: [
          Container(
            // color: Colors.green,
            height: screenHeight * 0.05,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.asset(
                            "$originalPathCategory${productInformation.categoryImagePath}.png"),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        color: widget.textColor,
                        width: 2,
                        height: screenHeight * 0.05,
                      ),
                      const SizedBox(width: 10),
                      //**  Khi gắn 1 module titleName vào thì bỏ const đi
                       TitleText(
                        titleName: "${productInformation.categoryName}",
                        fontFam: "inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        textColor: Color(0xffBCBCBC),
                      )
                    ],
                  ),
                  SizedBox(child: GuideButton(onPressed: () {}))
                ]),
          ),
          const SizedBox(height: 10),
          Container(
            width: screenWidth * 1,
            height: screenHeight * 0.05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                colors: widget.colorGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child:
                //**  Khi gắn 1 module titleName vào thì bỏ const đi
                TitleText(
              titleName: "${productInformation.productName}",
              fontFam: "inter",
              fontWeight: FontWeight.w700,
              fontSize: 25,
              textColor: widget.textColor,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 5),
          //**  Khi gắn 1 module titleName vào thì bỏ const đi
           TitleText(
            titleName: "Số lượng sản phẩm: ${productInformation.quantity !- (productInformation.numberOfProductsHasFinished! - (productInformation.isOpened! ? 1 : 0))}",
            fontFam: "inter",
            fontWeight: FontWeight.w400,
            fontSize: 15,
            //! Default Color
            textColor: Color(0xff002454),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),

          //**  Khi gắn 1 module titleName vào thì bỏ const đi
          //productInformation.isOpened
          productInformation.isOpened!
          ?TitleText(
            titleName: "Đang sử dụng: 1", //"Đang sử dụng: 1"
            fontFam: "inter",
            fontWeight: FontWeight.w400,
            fontSize: 15,
            textColor: widget.textColor,
            textAlign: TextAlign.center,
          )
          :Container(),

          const SizedBox(height: 10),

          //* DETAIL INFORMATION BAR
          Expanded(
            child: Container(
            // color: Colors.green,
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: widget.isClickedOpen == false
                ? Column(
                    children: [
                      // ** PRICE
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleText(
                              titleName: "Giá đã mua:",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: Color(0xff363636),
                              // textAlign: TextAlign.center,
                            ),
                            TitleText(
                              titleName: formatter.format(productInformation.cost),
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: widget.itemText,
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ** VOLUME
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleText(
                              titleName: "Khối lượng tịnh:",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: Color(0xff363636),
                              // textAlign: TextAlign.center,
                            ),
                            TitleText(
                              titleName: "${productInformation.volume} ${productInformation.volumeUnit}",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: widget.itemText,
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ** DATE
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleText(
                              titleName: "Ngày mua:", 
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: Color(0xff363636),
                              // textAlign: TextAlign.center,
                            ),
                            TitleText(
                              titleName: convertToDateString(productInformation.dateBought!),
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: widget.itemText,
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ** NUMBER OF USER
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleText(
                              titleName: "Số người dùng:",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: Color(0xff363636),
                              // textAlign: TextAlign.center,
                            ),
                            TitleText(
                              titleName: "${productInformation.peopleUse} người",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: widget.itemText,
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ** QUANTITY
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleText(
                              titleName: "Cường độ dùng",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: Color(0xff363636),
                              // textAlign: TextAlign.center,
                            ),
                            TitleText(
                              titleName: convertFrequency(productInformation.frequency!),
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: widget.itemText,
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleText(
                              titleName: "Cách bảo quản:",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: Color(0xff363636),
                              // textAlign: TextAlign.center,
                            ),
                            TitleText(
                              titleName: "${productInformation.wayPreserve}",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: widget.itemText,
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 10),
                    ],
                  )

                : Column( //In Use
                    children: [
                      // ** VOLUME
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleText(
                              titleName: "Khối lượng tịnh còn lại :",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: Color(0xff363636),
                              // textAlign: TextAlign.center,
                            ),
                            TitleText(
                              titleName: "${openedProductInformation.volumeLeft} ${productInformation.volumeUnit}",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: widget.itemText,
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ** DATE
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleText(
                              titleName: "Ngày mở nắp:",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: Color(0xff363636),
                              // textAlign: TextAlign.center,
                            ),
                            TitleText(
                              titleName: convertToDateString(openedProductInformation.dateOpen!),
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: widget.itemText,
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ** NUMBER OF USER
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleText(
                              titleName: "Số người dùng:",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: Color(0xff363636),
                              // textAlign: TextAlign.center,
                            ),
                            TitleText(
                              titleName: "${productInformation.peopleUse} người",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: widget.itemText,
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ** QUANTITY
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleText(
                              titleName: "Cường độ dùng",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: Color(0xff363636),
                              // textAlign: TextAlign.center,
                            ),
                            TitleText(
                              titleName: convertFrequency(productInformation.frequency!),
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: widget.itemText,
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleText(
                              titleName: "Cách bảo quản:",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: Color(0xff363636),
                              // textAlign: TextAlign.center,
                            ),
                            TitleText(
                              titleName:"${productInformation.wayPreserve}",
                              fontFam: "inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              textColor: widget.itemText,
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 10),
                    ],
                  ),
          ))
        ]),
      ),
    );
  }
}
