import 'dart:developer';

import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/model/track_calendar_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemDisplayComponent extends StatelessWidget {
  // final String? warningTag;
  // final String? warningTagCount;
  final String? itemImage;
  final String? itemName;
  final String? itemStatus;
  final String? itemTag;
  final String? itemTagName;
  final String? itemSecondTagName;
  final String? itemCount;
  final String? itemExpireDate;
  final String? itemDescription;
  final VoidCallback onPressed;
  const ItemDisplayComponent({
    super.key,
    this.itemImage,
    this.itemName,
    this.itemStatus,
    this.itemTag,
    this.itemCount,
    this.itemExpireDate,
    this.itemDescription,
    required this.onPressed,
    // this.warningTag,
    this.itemTagName,
    this.itemSecondTagName,
    // this.warningTagCount,
  });


  String findStatusName(String status){
    switch(status){
      case("MONTH_BEFORE"):
        return("1 tháng");
      case("SEVEN_DAYS_BEFORE"):
        return("7 ngày");
      case("THREE_DAYS_BEFORE"):
        return("3 ngày");
      case("LATE"):
        return "Trễ";
      case("SPOILT"):
        return "Hết hạn";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    String originalPath = "assets/product";
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Container(
      width: width * 0.9,
      height: height * 0.2,
      decoration: const BoxDecoration(
        // color: Colors.amber[50],
        border: Border(
          bottom: BorderSide(
            color: Color(0xff9F9F9F),
            width: 1.0,
          ),
        ),
      ),
      child: TextButton(
          onPressed: onPressed, //Chuyển sang Detail Product Page
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Column(children: [
            // // Warning Item
            // SizedBox(
            //   child: Row(children: [
            //     TitleText(
            //       titleName: warningTag!, //Cảnh báo hạn sử dụng
            //       fontSize: 20,
            //       textColor: const Color(0xff858585),
            //       fontWeight: FontWeight.w600,
            //       fontFam: "inter",
            //     ),
            //     const SizedBox(width: 5),
            //     TitleText(
            //       titleName: "($warningTagCount)", //Số lượng sản phẩm hiển thị cho từng mục
            //       fontSize: 20,
            //       textColor: const Color(0xff858585),
            //       fontWeight: FontWeight.w600,
            //       fontFam: "inter",
            //     ),
            //   ]),
            // ),
            // const SizedBox(height: 10),
            // Item
            
            Container(
              margin: const EdgeInsets.only(top: 12),
              // color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Items Image
                  Container(
                    // color: Colors.amber,
                    child: Image.asset(
                      "$originalPath${itemImage!}.png",
                      width: 90,
                      height: 90,
                    ),
                  ),
                  // Item Content
                  Container(
                      height: height * 0.12,
                      // color: Colors.green[50],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Item content header
                          SizedBox(
                            child: Row(
                              children: [
                                TitleText(
                                  titleName: itemName!, //Tên sản phẩm
                                  fontFam: "inter",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                                const SizedBox(width: 5),
                                TitleText(
                                  titleName: "(${findStatusName(itemStatus!)})", //Tình trạng (Hết hạn, 1 tháng, 7 ngày, 3 ngày)
                                  fontFam: "inter",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  textColor: const Color(0xff363636),
                                )
                              ],
                            ),
                          ),
                          //Item Content Tag
                          Container(
                              width: width * 0.55,
                              // color: Colors.green[50],
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // ROw 1
                                    itemTagName!.isEmpty
                                    ? Container()
                                    : Row(
                                      children: [
                                        Image.asset(
                                          itemTag!, //Xét điều kiện
                                          width: 12,
                                          height: 12,
                                        ),
                                        const SizedBox(width: 3,),
                                        TitleText(
                                          titleName: itemTagName!, //Xét điều kiện
                                          fontFam: "Roboto",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          textColor: const Color(0xff363636),
                                        )
                                      ],
                                    ),
                                    // Row 2
                                    itemSecondTagName!.isEmpty
                                    ? Container()
                                    : Row(
                                      children: [
                                        Image.asset(
                                          itemTag!, //Xét điều kiện
                                          width: 10,
                                          height: 10,
                                        ),
                                        TitleText(
                                          titleName: itemSecondTagName!, //Xét điều kiện
                                          fontFam: "Roboto",
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          textColor: const Color(0xff363636),
                                        )
                                      ],
                                    ),
                                  ])),
                          // Item Content Count and Expired Date
                          SizedBox(
                            child: Row(
                              children: [
                                TitleText(
                                  titleName: "Số lượng: $itemCount",
                                  fontFam: "inter",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  textColor: const Color(0xff9F9F9F),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  color: const Color(0xff9F9F9F),
                                  height: 10,
                                  width: 2,
                                ),
                                const SizedBox(width: 10),
                                TitleText(
                                  titleName: "HSD: $itemExpireDate",
                                  fontFam: "inter",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  textColor: const Color(0xff4094EA),
                                )
                              ],
                            ),
                          ),
                          // Item Content Description
                          SizedBox(
                            child: TitleText(
                              titleName: "Ngành: $itemDescription",
                              fontFam: "inter",
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              textColor: const Color(0xff9F9F9F),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ])),
    );
  }
}
