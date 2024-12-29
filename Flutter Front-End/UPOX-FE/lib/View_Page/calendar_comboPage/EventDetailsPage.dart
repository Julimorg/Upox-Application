import 'dart:developer';

import 'package:first_app/Components/Calendar_Component/onPressedButton/customeOnPressedButton.dart';
import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/CommonComponent/textbutton.dart';
import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/View_Page/calendar_comboPage/calendar_main_page.dart';
import 'package:first_app/Components/Calendar_Component/item_display/item_display_component.dart';
import 'package:first_app/View_Page/detail_product_combo_view/detail_product_page.dart';
import 'package:first_app/model/track_calendar_product.dart';
import 'package:first_app/model/track_user_product_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class EventDetailsPage extends StatefulWidget {
  final DateTime selectedDay;
  Map<DateTime,List<TrackedCalendarProduct>> eventsOfWeek = {};

  EventDetailsPage(this.selectedDay, this.eventsOfWeek, {Key? key});



  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  int selectedButtonIndex = -1;
  late DateTime selectionDate;
  String originalPath = "assets/calendarstatus/calendar_status";

  late List<TrackedCalendarProduct> displayedList;
  late List<TrackedCalendarProduct> displayedLateList;
  late List<TrackedCalendarProduct> displayedSpoiltList;



  void changeDate(DateTime chosenDate){
    setState(() {
      selectionDate = chosenDate;
      displayedList = widget.eventsOfWeek[selectionDate]!;
      selectedButtonIndex = -1;
      separateProductList();
    });
  }


  String _getDateStatus(DateTime dateDisplay){
    int count = widget.eventsOfWeek[dateDisplay]!.length;
    switch(count){
      case (>= 1 && <= 3):
        return "_3PRODUCTS.png";
      case (>= 4 && <= 7):
        return "_7PRODUCTS.png";
      case (>= 8 && <= 10):
        return "_10PRODUCTS.png";
      case (> 10):
        return "_OVER10.png";
      default:
        return "_NOTHING.png";
    }
  }

  FetchingService fetchingService = FetchingService.initialize();
  Future<List<TrackedUserProductResponse>> getAllProductSameName(String productName) async{
    log("Getting all same product name");

    funcCallBack() {
      return fetchingService.getAllProductSameName(productName);
    }

    RequestController requestController = RequestController.withoutParameter(
      funcCallBack
    );

    fetchingService = FetchingService(requestController: requestController);

    return await requestController.request();
  }


  List<Container> _buildProductList(bool isSpoilt){
  
    log("Build");
    
    return List.generate(
      isSpoilt? displayedSpoiltList.length : displayedLateList.length,
      (index) {
        final item = isSpoilt? displayedSpoiltList[index] : displayedLateList[index];
        int calculatedQuantity = item.trackedUserProductResponse.quantity!;
        int numOfUsed = item.trackedUserProductResponse.isOpened! 
        ? (item.trackedUserProductResponse.numberOfProductsHasFinished! - 1)
        : (item.trackedUserProductResponse.numberOfProductsHasFinished!);
        calculatedQuantity -= numOfUsed;
        
        return Container(
          child: ItemDisplayComponent(
            //Gía trị của trackedUserProduct
            itemName: item.trackedUserProductResponse.productName,
            itemStatus: item.statusDisplay, //Tình trạng (Hết hạn, 1 tháng, 7 ngày, 3 ngày, Trễ)
            itemCount: calculatedQuantity.toString(), //Quantity
            itemExpireDate: item.trackedUserProductResponse.getDateExpiredAsString(),
            itemDescription: item.trackedUserProductResponse.categoryName, //Category
            itemTagName: isSpoilt? "Hết hạn sử dụng" : "", //Need to have condition to check
            itemSecondTagName: item.trackedUserProductResponse.isOpened! ? "Đang được sử dụng" : "", //Need to have condition to check
            itemImage: item.trackedUserProductResponse.imagePath, //Hình ảnh sản phẩm
            itemTag: isSpoilt || item.trackedUserProductResponse.isOpened! ? "assets/tag_icon.png" : "", //Need to have condition to check
            
            onPressed: () async { 
              log("Nhấn");
              //Dẫn vào Detail Product Page
              List<TrackedUserProductResponse> list = await getAllProductSameName(item.trackedUserProductResponse.productName!);
              Navigator.push(
                context,
                PageTransition(
                  child: DetailProductPage.fromCalendar(widget.eventsOfWeek, selectionDate, true, list), //Truyền thông tin product vào
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 300),
                ),
              );
              // Hành động khi bấm vào item
            },
          ),
        );
      },
    );
  }

  void separateProductList(){
    log("Display Calendar Product List: ${displayedList.length}");
    displayedSpoiltList = [];
    displayedLateList = [];
    for (var element in displayedList) {
      log("Status Calendar Chosen Date: ${element.statusDisplay!}");

      if(element.statusDisplay!.contains("SPOILT")){
        log("SPOILT");
        displayedSpoiltList.add(element);
      }
      else if (!element.statusDisplay!.contains("SPOILT") && 
      !element.statusDisplay!.contains("NORMAL")){
        log("LATE");
        displayedLateList.add(element);
      }
    }
  }


  @override
  void initState() {  
    super.initState();
    selectionDate = widget.selectedDay;
    //Xử lý product hiển thị ngày được chọn đầu tiên (selectionDate)
    displayedList = widget.eventsOfWeek[selectionDate]!;
    separateProductList();
    selectedButtonIndex = -1;
  }  


  @override
  Widget build(BuildContext context) {
    
    log("Selection index: $selectedButtonIndex");
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    DateTime startOfWeek = widget.selectedDay
        .subtract(Duration(days: widget.selectedDay.weekday - 1));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          // color: Colors.brown,
          child: Column(
            children: [
              // Header
              Container(
                margin: const EdgeInsets.only(right: 290),
                
                height: height * 0.06,
                // color: Colors.green,
                child: BackButtonComponent(
                  targetPage: CalendarMainPage(),
                  iconColor: Colors.blue,
                  textColor: Colors.blue,
                  labelText: "Back",
                ),
              ),
              const SizedBox(height: 5),
              // Hiển thị các ngày trong tuần
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white, //white
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 5.0,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        DateTime currentDay =
                            startOfWeek.add(Duration(days: index));
                        bool isSelected =
                            currentDay.day == selectionDate.day;
                        return GestureDetector(
                          onTap: () {
                            // TODO: Hành động khi chọn ngày khác
                            // Đổ lại dữ liệu trong tuần
                            changeDate(currentDay);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(//Date
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.transparent,//Hiển thị status date nếu có 
                                  image: isSelected
                                    ? null
                                    : DecorationImage(
                                      image: AssetImage("$originalPath${_getDateStatus(currentDay)}"),
                                      fit: BoxFit.cover,
                                    ),
                                  shape: BoxShape.circle,
                                  // gradient: isSelected
                                  //     ? const LinearGradient(
                                  //         colors: [
                                  //           Colors.blue,
                                  //           Colors.lightBlueAccent
                                  //         ],
                                  //         begin: Alignment.topLeft,
                                  //         end: Alignment.bottomRight,
                                  //       )
                                  //     : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${currentDay.day}',
                                  style: TextStyle(
                                    color:
                                        isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
          
                              const SizedBox(height: 8),
                              Text( //Thứ
                                DateFormat('E').format(currentDay),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      width: width * 0.9,
                      child: TitleText(
                        titleName:
                            '- ${DateFormat('dd/MM/yyyy').format(widget.selectedDay)} -',
                        fontFam: "Roboto",
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        textColor: const Color(0xff363636),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              // Các nút filter
              Container(
                width: width * 0.9,
                height: height * 0.055,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
          
                      Customeonpressedbutton(
                        filterName: "CẢNH BÁO HẾT HẠN SỬ DỤNG",
                        textColor: selectedButtonIndex == 0 ? Colors.blue : Color(0xff363636),
                        fontFamily: "inter",
                        fontWeight: FontWeight.w700,
                        backgroundColor: Colors.white,
                        bottomBorderColor:
                            selectedButtonIndex == 0 ? Colors.blue : Colors.white,
                        onPressed: () {
                          displayedSpoiltList.isNotEmpty
                          ? setState(() {
                            selectedButtonIndex = selectedButtonIndex != 0 ? 0 : -1; //(-1 || 1)
                            
                            //selectedButtonIndex = 1 (không dùng kịp đã đc chọn)
          
                            //Filter status của trackedUserProduct
                            //.productStatus.isEqual("SPOILT")
                          })
                          :log("Nothing");
                        },
                      ),
                      const SizedBox(width: 26),
                      Customeonpressedbutton(
                        filterName: "CẢNH BÁO KHÔNG DÙNG KỊP",
                        textColor: selectedButtonIndex == 1 ? Colors.blue : Color(0xff363636),
                        fontFamily: "inter",
                        fontWeight: FontWeight.w700,
                        backgroundColor: Colors.white,
                        bottomBorderColor:
                            selectedButtonIndex == 1 ? Colors.blue : Colors.white,
                        onPressed: () {
                          displayedLateList.isNotEmpty
                          ? setState(() {
                            selectedButtonIndex = selectedButtonIndex != 1 ? 1 : -1; //(-1 || 1)
                            
                            //Filter status của trackedUserProduct
                            //.productStatus.isEqual("LATE")//MONTH_BEFORE, SEVEN_DAYS_BEFORE, THREE_DAYS_BEFORE
                          })
                          :log("Nothing");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Danh sách item
              
              Container(
                // color: Colors.green,
                width: width * 0.9,
                height: height * 0.55,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      displayedSpoiltList.isNotEmpty //(-1 và 0)
                      ? Container( //SPOIL
                        // color: Colors.amber,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const TitleText(
                                  titleName: "Cảnh báo hết hạn sử dụng", //Cảnh báo hạn sử dụng
                                  fontSize: 20,
                                  textColor: const Color(0xff858585),
                                  fontWeight: FontWeight.w600,
                                  fontFam: "inter",
                                ),
                                const SizedBox(width: 5),
                                TitleText(
                                  titleName: "(${displayedSpoiltList.length})", //Số lượng sản phẩm hiển thị cho từng mục
                                  fontSize: 20,
                                  textColor: const Color(0xff858585),
                                  fontWeight: FontWeight.w600,
                                  fontFam: "inter",
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            //List of spoil product
                            Container(
                              height: (height * 0.55),
                              child: ListView(
                                children: _buildProductList(true),
                              )
                            )
                          ],
                        ),
                      )
                      :Container(), 
                      
                      displayedLateList.isNotEmpty //(-1 và 1)
                      ? Container( //LATE
                        // color: const Color.fromARGB(255, 255, 229, 150),
                        child: Column(
                          children:[
                            Row(
                              children: [
                                const TitleText(
                                  titleName: "Cảnh báo không dùng kịp", //Cảnh báo hạn sử dụng
                                  fontSize: 20,
                                  textColor: const Color(0xff858585),
                                  fontWeight: FontWeight.w600,
                                  fontFam: "inter",
                                ),
                                const SizedBox(width: 5),
                                TitleText(
                                  titleName: "(${displayedLateList.length})", //Số lượng sản phẩm hiển thị cho từng mục
                                  fontSize: 20,
                                  textColor: const Color(0xff858585),
                                  fontWeight: FontWeight.w600,
                                  fontFam: "inter",
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: (height * 0.55),
                              child: ListView(
                                children: _buildProductList(false),
                              )
                            )
                            // ListView(
                            //   children: _buildProductList(false),
                            // )
                            //List of late product
                            
                          ]
                        ),
                      )
                      : Container(), 
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
