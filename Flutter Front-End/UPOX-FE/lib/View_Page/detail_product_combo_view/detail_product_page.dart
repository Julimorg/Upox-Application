import 'dart:developer';
import 'package:first_app/Components/Alert_Component/log_out_alert/alert_background.dart';
import 'package:first_app/Components/Alert_Component/warning_alert/aler_component.dart';
import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/CommonComponent/textbutton.dart';
import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:first_app/Components/detail_product_component/product_detail_info.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/View_Page/calendar_comboPage/EventDetailsPage.dart';
import 'package:first_app/View_Page/edit_page_comboView/edit_main_page.dart';
import 'package:first_app/View_Page/homepage_comboPage/inventory_main_page.dart';
import 'package:first_app/model/track_calendar_product.dart';
import 'package:first_app/model/track_user_product_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class DetailProductPage extends StatefulWidget {
  Map<String, dynamic> reloadSuggestionCategories = {};
  List<TrackedUserProductResponse> reloadedProductList = [];
  Map<String, bool> reloadedChosenFilters = {};

  List<TrackedUserProductResponse> displayedSameProducts =
      []; //(chung một productId)

  //từ trang lịch qua
  bool isFromCalendar = false;
  DateTime selectedDay = DateTime.now();
  Map<DateTime, List<TrackedCalendarProduct>> eventsOfWeek = {};

  //final Function(bool) onToggleOpen; //Bỏ

  DetailProductPage.initialize({super.key});
  DetailProductPage(this.reloadSuggestionCategories, this.reloadedProductList,
      this.reloadedChosenFilters, this.displayedSameProducts,
      {super.key});
  DetailProductPage.fromCalendar(this.eventsOfWeek, this.selectedDay,
      this.isFromCalendar, this.displayedSameProducts,
      {super.key});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  bool isClickedOpen =
      false; //Cờ để xét thông tin sản phẩm là inUse hay bình thường
//  bool isOpen2 = true;

  int findIndex(String status) {
    switch (status) {
      case "NORMAL":
        return 0;
      case "MONTH_BEFORE":
        return 1;
      case "SEVEN_DAYS_BEFORE":
        return 2;
      case "THREE_DAYS_BEFORE":
        return 3;
      case "LATE":
        return 4;
      case "SPOILT":
        return 5;
      default:
        return -1;
    }
  }

  int currentIndex = 0; // Trạng thái hiện tại của Carousel
  int productIndex = 0;

  final List<Map<String, dynamic>> productStates = [
    {
      //? Default Status
      "textColor": const Color(0xff18A0FB),
      "gradientColors": [const Color(0xffC0E6FF), Colors.white],
      "itemText": const Color(0xff18A0FB),
    },
    {
      //? Status: 1 tháng
      "textColor": const Color(0xffFAE871),
      "gradientColors": [const Color(0xffFCFDC6), Colors.white],
      "itemText": const Color(0xffFAE871),
    },
    {
      //? Status: 7 ngày
      "textColor": const Color(0xffFDBF77),
      "gradientColors": [const Color(0xffFDE8C6), Colors.white],
      "itemText": const Color(0xffFDBF77),
    },
    {
      //? Status: 3 ngày
      "textColor": const Color(0xffF78888),
      "gradientColors": [const Color(0xffFDC6C6), Colors.white],
      "itemText": const Color(0xffF78888),
    },
    {
      //?S Status: Vượt Ngưỡng
      "textColor": const Color(0xffD288F7),
      "gradientColors": [const Color(0xffF6C6FD), Colors.white],
      "itemText": const Color(0xffD288F7),
    },
    {
      //? Status: hết hạn sử dụng
      "textColor": const Color(0xff363636),
      "gradientColors": [const Color(0xff363636), Colors.white],
      "itemText": const Color(0xffCCCCCC),
    },
  ];

  void showBlackDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: AlerComponent(
          'assets/alertPath/quahsd_banner.png',
        ),
      ),
    );
  }

  FetchingService fetchingService = FetchingService.initialize();

  Future<TrackedUserProductResponse> finishUsing() async {
    log("Finish using");
    String productId = displayedSameProducts[productIndex].productId!;
    String transactionId = displayedSameProducts[productIndex].transactionId!;

    funcCallBack() {
      return fetchingService.finishUsingProduct(productId, transactionId);
    }

    RequestController requestController =
        RequestController.withoutParameter(funcCallBack);

    fetchingService = FetchingService(requestController: requestController);

    return await requestController.request();
  }

  void _finishDialog(
      BuildContext context, double screenHeight, double screenWidth) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: AlertComponent(
            alertImagePath: 'assets/alertPath/dacapnhat_banner.png',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(height: 10),
                // Exit button
                Container(
                  margin: EdgeInsets.only(left: 250, top: 5),
                  width: 30,
                  height: 30,
                  // decoration: const BoxDecoration(color: Color(0xFF000000)),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                        // backgroundColor: Colors.amber,
                        minimumSize:
                            Size(screenWidth * 0.01, screenHeight * 0.01),
                        shape: const CircleBorder(
                          side: BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                      ),
                      label: SizedBox(
                        child: Image.asset(
                          "assets/exit_button.png",
                          color: Colors.white,
                          width: screenWidth * 0.02,
                          height: screenHeight * 0.02,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 68,
                  height: 30,
                  margin: EdgeInsets.only(left: 213, bottom: 10),
                  // decoration: const BoxDecoration(color: Color(0xFF000000)),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.02),
                      child: SizedBox(
                        width: screenWidth * 0.16,
                        height: screenHeight * 0.030,
                        child: OutlinedButton(
                          onPressed: () async {
                            //Call finishing product
                            TrackedUserProductResponse updatedProduct =
                                await finishUsing();
                            setState(() {
                              displayedSameProducts[productIndex] =
                                  updatedProduct;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              minimumSize:
                                  Size(screenWidth * 0.01, screenWidth * 0.01),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 1,
                              )),
                          child: const Text(
                            "Xác nhận",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  late List<TrackedUserProductResponse> displayedSameProducts;
  String originalPathBoxUnOpen = "assets/box/unopen/unopened_icon_";
  String originalPathBoxOpen = "assets/box/open/opened_icon_";
  String originalPathProduct = "assets/product";

  String convertToDateString(DateTime dateTime) {
    //Code here
    String formatter = "dd/MM/yyyy";
    return DateFormat(formatter).format(dateTime);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displayedSameProducts = widget.displayedSameProducts;
    currentIndex = findIndex(displayedSameProducts[0].statusName!);
    isClickedOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                //? Nên đặt trạng thái cho background ở đây
                color: productStates[currentIndex]["textColor"],
                //CHANGE
                child: Column(children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    // color: Colors.cyan,
                    height: screenHeight * 0.05,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: screenWidth * 0.03),
                            child: BackButtonComponent(
                              targetPage: widget.isFromCalendar
                                  ? EventDetailsPage(
                                      widget.selectedDay, widget.eventsOfWeek)
                                  : InventoryMainPage.reload(
                                      widget.reloadSuggestionCategories,
                                      widget.reloadedProductList,
                                      widget
                                          .reloadedChosenFilters), //Truyền lại dữ liệu
                              labelText: "Back",
                              iconColor: Colors.white,
                              textColor: Colors.white,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              displayedSameProducts
                                  .length, //thay bằng displayedSameProducts
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: productIndex == index
                                        ? Colors.white
                                        : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //? FINISH AND EDIT BUTTON
                          Container(
                            //CHƯA XỬ LÝ
                            // color: Colors.amber,
                            width: screenWidth * 0.19,
                            alignment: Alignment.centerRight,
                            child: Stack(children: [
                              displayedSameProducts[productIndex].isOpened! &&
                                      isClickedOpen //Là sản phẩm bình thường hay inUse
                                  ? CustomTextButton(
                                      // Finish
                                      onPressed: () {
                                        //Hiện dialog
                                        _finishDialog(
                                            context, screenHeight, screenWidth);
                                      },
                                      filterName: "Finish",
                                      backgroundColor: Colors.transparent,
                                      fontFamily: "inter",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      textColor: Colors.white,
                                    )
                                  : CustomTextButton(
                                      //Edit
                                      onPressed: () {
                                        //Chuyển sang Edit Main Page
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(
                                          PageTransition(
                                            child: EditMainPage
                                                .fromDetailProductPage(
                                                    productIndex,
                                                    true,
                                                    displayedSameProducts[
                                                            productIndex]
                                                        .isOpened!,
                                                    widget
                                                        .reloadSuggestionCategories,
                                                    widget.reloadedProductList,
                                                    widget
                                                        .reloadedChosenFilters,
                                                    displayedSameProducts),
                                            type:
                                                PageTransitionType.rightToLeft,
                                            duration: const Duration(
                                                milliseconds: 300),
                                          ),
                                        );
                                        log("Navigated to EditMainPage");
                                      },
                                      filterName: "Edit",
                                      backgroundColor: Colors.transparent,
                                      fontFamily: "inter",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      textColor: Colors.white,
                                    )
                            ]),
                          )
                        ],
                      ),
                    ),
                  ),
                  //** Items Content Detail */
                  //** --> Set Scroll ngang
                  Expanded(
                      child: Container(
                          // color: Colors.white,
                          // width: screenWidth * 0.5,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(500),
                                  topLeft: Radius.circular(500))),
                          //Lướt
                          child: PageView.builder(
                              itemCount: displayedSameProducts
                                  .length, //thay bằng displayedSameProducts
                              onPageChanged: (index) {
                                setState(() {
                                  String status =
                                      displayedSameProducts[index].statusName!;
                                  currentIndex = findIndex(
                                      status); //Cập nhật lại currentIndex (index status)
                                  productIndex = index;
                                  if (currentIndex ==
                                      productStates.length - 1) {
                                    //hết HSD (Phải xét xem product đó có hết hạn ko)
                                    showBlackDialog();
                                  }
                                });
                              },
                              itemBuilder: (context, index) {
                                // Container scroll
                                return Container(
                                    // color: Colors.amber,
                                    // width: screenWidth * 0.1,
                                    margin: const EdgeInsets.only(
                                        top: 30, left: 10, right: 10),
                                    // height: screenHeight * 0.3,
                                    child: Stack(children: [
                                      Column(
                                        //Thông tin product
                                        children: [
                                          SizedBox(
                                            //HSD
                                            child: TitleText(
                                              titleName: displayedSameProducts[
                                                              index]
                                                          .isOpened! &&
                                                      isClickedOpen
                                                  ? "HSD ${convertToDateString(displayedSameProducts[index].openedProductResponse!.openExpiryDate!)}"
                                                  : "HSD ${convertToDateString(displayedSameProducts[index].expiryDate!)}",
                                              fontFam: "inter",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              textColor: Color(0xff002454),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            //Hình sản phẩm
                                            width: screenWidth * 0.5,
                                            height: screenHeight * 0.2,
                                            child: Image.asset(
                                                "$originalPathProduct${displayedSameProducts[index].imagePath}.png"),
                                          ),
                                          const SizedBox(height: 10),
                                          ProductDetailInfo(
                                            //Thông tin chi tiết
                                            displayedSameProducts[index],
                                            textColor: productStates[
                                                    currentIndex] //index của màu phải tìm //đổi thành currentIndex
                                                ["textColor"],
                                            colorGradient:
                                                productStates[currentIndex]
                                                    ["gradientColors"],
                                            itemText:
                                                productStates[currentIndex]
                                                    ["itemText"],
                                            isClickedOpen: displayedSameProducts[
                                                        index]
                                                    .isOpened! &&
                                                isClickedOpen, //Đổi thông tin product thành inUse
                                            // colorGradient: ,
                                          ),
                                        ],
                                      ),
                                      displayedSameProducts[index].isOpened!
                                          ? Positioned(
                                              //Nút đổi thành inUse (nếu có) xét isOpened của product
                                              top: 30,
                                              right: 30,
                                              child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isClickedOpen =
                                                        !isClickedOpen; //Đổi thông tin thành inUse
                                                  });
                                                  // widget.onToggleOpen(isOpen);
                                                  log("Đã bấm");
                                                },
                                                style: TextButton.styleFrom(
                                                  shape: const CircleBorder(),
                                                  // padding: const EdgeInsets.all(10),
                                                  // backgroundColor: Colors.blue,
                                                  elevation: 0,
                                                  // side: const BorderSide(
                                                  //     width: 0, color: Colors.blue),
                                                ),
                                                child: Image.asset(
                                                  isClickedOpen
                                                      ? "$originalPathBoxUnOpen${displayedSameProducts[index].statusName}.png"
                                                      : "$originalPathBoxOpen${displayedSameProducts[index].statusName}.png",
                                                  width: 35,
                                                  height: 35,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ]));
                              })))
                ]))));
  }
}
