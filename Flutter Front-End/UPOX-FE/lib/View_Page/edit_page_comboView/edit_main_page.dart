import 'dart:developer';

import 'package:first_app/Components/Alert_Component/log_out_alert/alert_background.dart';
import 'package:first_app/Components/Alert_Component/warning_alert/aler_component.dart';
import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/edit_page_component/EditScroll_Model/edit_page_scroll_date_event.dart';
import 'package:first_app/Components/edit_page_component/EditScroll_Model/edit_page_scroll_quantity.dart';
import 'package:first_app/Components/edit_page_component/EditScroll_Model/edit_page_scroll_selectIntensity.dart';
import 'package:first_app/Components/edit_page_component/EditScroll_Model/edit_page_scroll_userNum.dart';
import 'package:first_app/Components/edit_page_component/SelectOptionCustom/edit_select_option_bar.dart';
import 'package:first_app/Components/edit_page_component/edit_price.dart';
import 'package:first_app/Components/edit_page_component/item_used_component.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/View_Page/detail_product_combo_view/detail_product_page.dart';
import 'package:first_app/View_Page/edit_page_comboView/edit_price_items.dart';
import 'package:first_app/View_Page/edit_page_comboView/edit_volume_items.dart';
import 'package:first_app/View_Page/manual_input._page.dart';
import 'package:first_app/View_Page/product_list_page.dart';
import 'package:first_app/model/payment.dart';
import 'package:first_app/model/product_default_response.dart';
import 'package:first_app/model/track_opened_product_response.dart';
import 'package:first_app/model/track_user_product.dart';
import 'package:first_app/model/track_user_product_response.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class EditMainPage extends StatefulWidget {
  //Đã đủ cờ
  bool isEdited = false; //Cờ edit (gửi từ DetailProductPage, ProductListPage)
  bool isBeingUsed =
      false; //Cờ có sản phẩm đang được sử dụng (gửi từ DetailProductPage)
  bool isFromDetailPage = false;

  //Product List Page
  List<TrackedUserProduct> trackedUserProductList =
      []; //Chuyển qua các Navigators
  ProductDefaultResponse productDefault = ProductDefaultResponse();
  TrackedUserProduct trackedUserProduct = TrackedUserProduct();
  int index = -1;

  //Detail Product Page
  int indexDetailPage = -1;
  Map<String, dynamic> reloadSuggestionCategories = {};
  List<TrackedUserProductResponse> reloadedProductList = [];
  Map<String, bool> reloadedChosenFilters = {};
  List<TrackedUserProductResponse> displayedSameProducts = [];

  EditMainPage(this.trackedUserProductList, this.productDefault, {super.key});
  EditMainPage.initialize({super.key});

  //(Sẽ được gọi từ DetailProductPage, ProductListPage)
  EditMainPage.edited(this.trackedUserProductList, this.trackedUserProduct,
      this.index, this.isEdited, this.isBeingUsed,
      {super.key});

  EditMainPage.fromDetailProductPage(
      this.indexDetailPage,
      this.isFromDetailPage,
      this.isBeingUsed,
      this.reloadSuggestionCategories,
      this.reloadedProductList,
      this.reloadedChosenFilters,
      this.displayedSameProducts,
      {super.key});

  @override
  State<EditMainPage> createState() => _EditMainPage();
}

class _EditMainPage extends State<EditMainPage> {
  //default product
  late ProductDefaultResponse productDefaultResponse;

  // default attributes
  int volume = 0; // Giá trị mặc định
  String expiredDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String dateBought = DateFormat('dd/MM/yyyy').format(DateTime.now());
  int quantity = 0;
  int usernum = 0;
  int intensity = 0; //frequency
  String unit = 'Ngày'; //unit
  int cost = 0;
  String imagePath = "";
  String productName = "";
  String preserveWay = "";
  String originalImagePath = "assets/product";
  bool isOpened = false;

  //Gía trị unitVolume không cần truyền vào TrackedUserProduct constructor
  //Chỉ dùng với mục đích hiển thị
  String volumeUnit = "";

  //Suggested Cost
  late Map<String, List<int>> mapSuggestedCost; //Chuyển qua edit_price_items

  //Suggested Volume
  late Map<String, List<int>> mapSuggestedVolume; //Chuyển qua edit_volume_items

  void onConfirm() {
    //On confirm để add vào list
    TrackedUserProduct trackedUserProduct = TrackedUserProduct();
    trackedUserProduct.setProductName(productName);
    //Set up lại ngày giờ truyền vào (yyyy-MM-dd HH:mm)
    //DateFormat('yyyy-MM-dd HH:mm').format(now);
    //DateFormat format = DateFormat('yyyy-MM-dd HH:mm');
    //DateTime parsedDate = format.parse(dateString);

    trackedUserProduct.setExpiryDate(
        parseIntoDifDateFormat("dd/MM/yyyy", "yyyy-MM-dd HH:mm", expiredDate));
    trackedUserProduct.setQuantity(quantity);
    trackedUserProduct.setPeopleUse(usernum);
    trackedUserProduct.setWayPreserve(preserveWay);
    trackedUserProduct.setOpened(isOpened);
    trackedUserProduct.setCost(cost);
    //Set up lại ngày giờ truyền vào
    trackedUserProduct.setDateBought(
        parseIntoDifDateFormat("dd/MM/yyyy", "yyyy-MM-dd HH:mm", dateBought));
    trackedUserProduct.setVolume(volume);
    String frequency = "$intensity/${returnUnitToInt(unit)}";
    trackedUserProduct.setFrequency(frequency);
    trackedUserProduct.setImagePath(imagePath);
    trackedUserProduct.setVolumeUnit(volumeUnit);

    widget.trackedUserProductList.add(trackedUserProduct);
  }

  void onReconfirm() {
    //On reconfirm để chỉnh product đã add vào list
    widget.trackedUserProductList[widget.index].setProductName(productName);
    //Set up lại ngày giờ truyền vào (yyyy-MM-dd HH:mm)
    //DateFormat('yyyy-MM-dd HH:mm').format(now);
    //DateFormat format = DateFormat('yyyy-MM-dd HH:mm');
    //DateTime parsedDate = format.parse(dateString);

    widget.trackedUserProductList[widget.index].setExpiryDate(
        parseIntoDifDateFormat("dd/MM/yyyy", "yyyy-MM-dd HH:mm", expiredDate));
    widget.trackedUserProductList[widget.index].setQuantity(quantity);
    widget.trackedUserProductList[widget.index].setPeopleUse(usernum);
    widget.trackedUserProductList[widget.index].setWayPreserve(preserveWay);
    widget.trackedUserProductList[widget.index].setOpened(isOpened);
    widget.trackedUserProductList[widget.index].setCost(cost);
    //Set up lại ngày giờ truyền vào
    widget.trackedUserProductList[widget.index].setDateBought(
        parseIntoDifDateFormat("dd/MM/yyyy", "yyyy-MM-dd HH:mm", dateBought));
    widget.trackedUserProductList[widget.index].setVolume(volume);
    String frequency = "$intensity/${returnUnitToInt(unit)}";
    widget.trackedUserProductList[widget.index].setFrequency(frequency);
    widget.trackedUserProductList[widget.index].setImagePath(imagePath);
    widget.trackedUserProductList[widget.index].setVolumeUnit(volumeUnit);
  }

  //TrackedUserProductResponse
  FetchingService fetchingService = FetchingService.initialize();
  Future<void> onEdited() async{
    TrackedUserProduct editedTrackedUserProduct = TrackedUserProduct();
    TrackedUserProductResponse askForEditProduct = widget.displayedSameProducts[widget.indexDetailPage];
    //Chỉnh sửa
    log("isOpened $isOpened");
    editedTrackedUserProduct.setPeopleUse(usernum);
    String frequency = "$intensity/${returnUnitToInt(unit)}";
    editedTrackedUserProduct.setFrequency(frequency);
    editedTrackedUserProduct.setOpened(isOpened);
    //Lưu vào Db

    log("Inventory fetching");

    funcCallBack() {
      return fetchingService.updateProduct(askForEditProduct.productId!,
      askForEditProduct.transactionId!, editedTrackedUserProduct);
    }

    RequestController requestController =
        RequestController.withoutParameter(funcCallBack);

    fetchingService = FetchingService(requestController: requestController);

    widget.displayedSameProducts[widget.indexDetailPage] = await requestController.request();

    //Chuyển qua

    widget.reloadedProductList = widget.displayedSameProducts;

    Navigator.of(context, rootNavigator: true).push(
      PageTransition(
        child: DetailProductPage(widget.reloadSuggestionCategories, widget.reloadedProductList, 
        widget.reloadedChosenFilters, widget.displayedSameProducts),
        type: PageTransitionType.leftToRight,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  String parseIntoDifDateFormat(
      String currentDateFormat, String parseDateFormat, String dateString) {
    DateFormat dateFormat = DateFormat(currentDateFormat);
    DateTime dateTime = dateFormat.parse(dateString);
    return DateFormat(parseDateFormat).format(dateTime);
  }

  String fixEncoding(String input) {
    // Chuyển đổi chuỗi thành byte
    List<int> bytes =
        latin1.encode(input); // Mã hóa chuỗi như ISO-8859-1 (Latin1)

    // Chuyển đổi byte thành chuỗi UTF-8
    String fixedString = utf8.decode(bytes);

    return fixedString;
  }

  int returnUnitToInt(String local_unit) {
    switch (local_unit) {
      case ("Ngày"):
        return 1;
      case ("Tuần"):
        return 7;
      case ("Tháng"):
        return 30;
      case ("Năm"):
        return 365;
      default:
        return -1;
    }
  }

  String returnIntToUnit(int days) {
    switch (days) {
      case (1):
        return "Ngày";
      case (7):
        return "Tuần";
      case (30):
        return "Tháng";
      case (365):
        return "Năm";
      default:
        return "";
    }
  }

  void processDefaultValue() {
    log("NEW PRODUCT");
    productDefaultResponse = widget.productDefault; //Chuyển qua các Navigators

    //Tên
    log(productDefaultResponse.productName.toString());
    productName = fixEncoding(productDefaultResponse.productName.toString());

    //Cost
    log(productDefaultResponse.defCost.toString());
    //Xử lý Json
    mapSuggestedCost =
        generateJson(productDefaultResponse.defCost.toString(), false);

    //Volume
    log(productDefaultResponse.defVolume.toString());
    //Xử lý Json
    mapSuggestedVolume =
        generateJson(productDefaultResponse.defVolume.toString(), true);

    //HSD
    log(productDefaultResponse.defExpiryDate.toString());
    //Xử lý ngày hết hạn default
    expiredDate = calculateDefaultExpiredDay(
        productDefaultResponse.defExpiryDate.toString());

    //Way preserve
    log(productDefaultResponse.defPreserveWay.toString());
    preserveWay = fixEncoding(productDefaultResponse.defPreserveWay.toString());

    //ImagePath
    log(productDefaultResponse.imagePath.toString());
    imagePath = productDefaultResponse.imagePath.toString();
  }

  void processExistedValue() {
    //Dùng cho edit từ Product List
    log("EDIT PRODUCT");

    TrackedUserProduct editedTrackedUserProduct = widget.trackedUserProduct;
    //Product Name
    productName = editedTrackedUserProduct.getProductName().toString();
    log(productName);

    //Cost
    cost = editedTrackedUserProduct.getCost()!.toInt();
    log(cost.toString());

    //Quantity
    quantity = editedTrackedUserProduct.getQuantity()!.toInt();
    log(quantity.toString());

    //People use
    usernum = editedTrackedUserProduct.getPeopleUse()!.toInt();
    log(usernum.toString());

    //Frequency
    List<String> frequencyParts =
        editedTrackedUserProduct.getFrequency().toString().split("/");
    intensity = int.parse(frequencyParts[0]);
    unit = returnIntToUnit(int.parse(frequencyParts[1]));

    //Volume
    volume = editedTrackedUserProduct.getVolume()!.toInt();
    log(volume.toString());

    //HSD
    expiredDate = parseIntoDifDateFormat("yyyy-MM-dd HH:mm", "dd/MM/yyyy",
        editedTrackedUserProduct.getExpiryDate().toString());
    log(expiredDate);

    //Way preserve
    preserveWay = editedTrackedUserProduct.getWayPreserve().toString();
    log(preserveWay);

    //ImagePath
    imagePath = editedTrackedUserProduct.getImagePath().toString();
    log(imagePath);

    //Date Bought
    dateBought = parseIntoDifDateFormat("yyyy-MM-dd HH:mm", "dd/MM/yyyy",
        editedTrackedUserProduct.getDateBought().toString());
    log(dateBought);

    //Volume Unit
    volumeUnit = editedTrackedUserProduct.getVolumeUnit().toString();
    log(volumeUnit);

    //Is Opened
    isOpened = editedTrackedUserProduct.isOpened();
  }

  //TrackedUserProductResponse
  void processOldValue() {
    log("EDIT PRODUCT EXIST");
    TrackedUserProductResponse askForEditProduct = widget.displayedSameProducts[widget.indexDetailPage];
    //Product Name
    productName = askForEditProduct.productName.toString();
    log(productName);

    //Cost
    cost = askForEditProduct.cost!;
    log(cost.toString());

    //Quantity
    quantity = askForEditProduct.quantity!;
    log(quantity.toString());

    //People use
    usernum = askForEditProduct.peopleUse!;
    log(usernum.toString());

    //Frequency
    List<String> frequencyParts =
        askForEditProduct.frequency!.split("/");
    intensity = int.parse(frequencyParts[0]);
    unit = returnIntToUnit(int.parse(frequencyParts[1]));

    //Volume
    volume = askForEditProduct.volume!;
    log(volume.toString());

    //HSD
    expiredDate = askForEditProduct.getDateExpiredAsString();
    log(expiredDate);

    //Way preserve
    preserveWay = askForEditProduct.wayPreserve.toString();
    log(preserveWay);

    //ImagePath
    imagePath = askForEditProduct.imagePath.toString();
    log(imagePath);

    //Date Bought
    dateBought = askForEditProduct.getDateBoughtAsString();
    log(dateBought);

    //Volume Unit
    volumeUnit = askForEditProduct.volumeUnit.toString();
    log(volumeUnit);

    //Is Opened
    isOpened = false;
    //Đã có sản phẩm đang được sử dụng r, thì sẽ không được mở nữa

  }

  DateTime covertToDateTime(String dateString, String dateStringFormat) {
    DateFormat dateFormat = DateFormat(dateStringFormat);
    return dateFormat.parse(dateString);
  }

  Map<String, List<int>> generateJson(String jsonString, bool isAboutVolume) {
    // print(jsonString);
    dynamic testType = jsonDecode(jsonString);
    log(testType);
    log(testType.runtimeType.toString());
    // testType = jsonDecode(testType);
    // log(testType.runtimeType.toString());
    Map<String, dynamic> jsonMap = jsonDecode(testType);
    Map<String, List<int>> suggestedValues = {};

    List<dynamic> tempCommonValue = jsonMap["common"];
    List<int> commonValue = tempCommonValue.map(
      (e) {
        isAboutVolume
            ? volumeUnit = e.toString().split(" ")[1]
            : volumeUnit = "";
        return (double.parse(e.toString().split(" ")[0])).toInt();
      },
    ).toList();

    suggestedValues["common"] = commonValue;

    //.map((e) => e as String).toList();
    if (jsonMap.containsKey("lessCommon")) {
      List<dynamic> tempLessCommonValue = jsonMap["lessCommon"];
      List<int> lessCommonValue = tempLessCommonValue.map(
        (e) {
          return int.parse(e.toString().split(" ")[0]);
        },
      ).toList();

      suggestedValues["lessCommon"] = lessCommonValue;
    }
    return suggestedValues;
  }

  String calculateDefaultExpiredDay(String differenceFromExpiry) {
    int minusOneDay = 7; //Trừ lùi lại 1 tuần
    DateTime currentDate = DateTime.now();

    //Giả định ngày lên kệ cách NSX khoảng một tuần
    DateTime manufacturedDate =
        currentDate.subtract(Duration(days: minusOneDay));

    //Tính toán ngày hết hạn
    List<String> tempDiff = differenceFromExpiry.split(" ");
    int value = int.parse(tempDiff[0]);
    String dateUnit = tempDiff[1];
    DateTime local_expiredDate =
        calculateDifference(value, dateUnit, manufacturedDate);
    return DateFormat('dd/MM/yyyy').format(local_expiredDate);
  }

  DateTime calculateDifference(
      int value, String dateUnit, DateTime manufacturedDate) {
    int difference = 0;
    late DateTime local_expiredDate;
    switch (dateUnit) {
      case ("years"):
      case ("year"):
        difference = value * 365;
        local_expiredDate = manufacturedDate.add(Duration(days: difference));
        return local_expiredDate;
      case ("month"):
      case ("months"):
        difference = value * 30;
        local_expiredDate = manufacturedDate.add(Duration(days: difference));
        return local_expiredDate;
      default:
        return DateTime.now();
    }
  }

  String turnToMoneyFormat(int moneyString) {
    final moneyFormat = NumberFormat.currency(locale: "vi_VN", symbol: "₫");
    return moneyFormat.format(moneyString);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!widget.isEdited && !widget.isFromDetailPage){ //Default
      processDefaultValue();
    }
    else if(widget.isEdited && !widget.isFromDetailPage){//Product List Page
      processExistedValue();
    } 
    else if (!widget.isEdited && widget.isFromDetailPage){//Detail Product Page
      processOldValue();
    } 
    // !widget.isEdited ? processDefaultValue() : processExistedValue();
    //Xử lý product default
    //Gán giá trị default
  }

  
  Future<bool> checkProductBeenUsing(String productName) async{
    log("check Product Been Using");


    funcCallBack() {
      return fetchingService.checkProductBeenUsing(productName);
    }

    RequestController requestController = RequestController.withoutParameter(
      funcCallBack
    );

    fetchingService = FetchingService(requestController: requestController);

    return await requestController.request();
  }


  void _showWarinigDialog(BuildContext context, double screenHeight, double screenWidth, String bannerPath) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            content: AlertComponent(
              alertImagePath: 'assets/alertPath/$bannerPath.png',
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
                ],
              ),
            ),
          );
        },
      );
    }


  @override
  Widget build(BuildContext context) {

    log("widget.isFromDetailPage ${widget.isFromDetailPage}");

    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Back Button
            const SizedBox(height: 10),
            BackButtonComponent(
              targetPage: widget.isFromDetailPage
                  ? DetailProductPage(
                      widget.reloadSuggestionCategories,
                      widget.reloadedProductList,
                      widget.reloadedChosenFilters,
                      widget.displayedSameProducts)
                  : ManualInputPage(widget.trackedUserProductList),
              iconColor: Colors.blue,
              textColor: Colors.blue,
              labelText: "Back",
            ),
            const SizedBox(height: 20),
            Container(
              // color: Colors.brown,
              height: height * 0.88,
              margin: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      //Container bự
                      margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.045,
                      ),
                      child: Row(
                        children: [
                          Container(
                            //Hình sản phẩm
                            child: Image.asset(
                              "$originalImagePath$imagePath.png",
                              width: width * 0.3,
                              height: height * 0.1,
                            ),
                          ),
                          Container(
                              //Tên sản phẩm
                              child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // name item text
                              Text(
                                //Product Name
                                productName,
                                style: const TextStyle(
                                  fontFamily: "inter",
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff18A0FB),
                                ),
                              ),
                              // Useless Span
                              Container(
                                //Đường kẻ
                                width: width * 0.6,
                                height: height * 0.003,
                                color: const Color(0xff18A0FB),
                              ),
                              const SizedBox(height: 10),
                              // Bonus text
                              const Text(
                                //Subtitle
                                "*Chọn và chỉnh sửa các thông tin!",
                                style: TextStyle(
                                  fontFamily: "inter",
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff18A0FB),
                                ),
                              ),
                            ],
                          ))
                        ],
                      )),
                  const SizedBox(height: 20),
                  Row(
                    //Thông tin chỉnh sửa

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          // margin: EdgeInsets.only(right: 20),
                          // color: Colors.amber,
                          height: height * 0.4,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Container Select History Input
                                Container(
                                  child: Column(children: [
                                    //? Option1 : Khối lượng
                                    !productName.contains("Mặt nạ") //Mặt nạ thì không có khối lượng tịnh
                                        ? widget.isFromDetailPage
                                          ? EditSelectOptionBar.cantEdit(
                                              labelText: "Khối lượng tịnh",
                                              weightText: "$volume $volumeUnit",
                                              iconImage: "",
                                              gradientStartColor:
                                                  Colors.white,
                                              gradientEndColor: Colors.white,
                                              onPressed: () async {
                                              },
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,)
                                          : EditSelectOptionBar(
                                              labelText: "Khối lượng tịnh",
                                              weightText: "$volume $volumeUnit",
                                              gradientStartColor:
                                                  const Color(0xffB0E0E6),
                                              gradientEndColor: Colors.white,
                                              onPressed: () async {
                                                // Mở EditVolumePageFieldtext và nhận giá trị trả về
                                                final result =
                                                    await Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    child: widget.isEdited
                                                        //Map<String,List<int>> mapSuggestedVolume
                                                        //List<TrackedUserProduct> trackedUserProductList
                                                        //ProductDefault productDefaultResponse
                                                        //String volumeUnit

                                                        ? EditVolumeItemsPage.isEdited(
                                                            mapSuggestedVolume,
                                                            volumeUnit,
                                                            widget
                                                                .trackedUserProductList,
                                                            productDefaultResponse,
                                                            true,
                                                            volume)
                                                        : EditVolumeItemsPage(
                                                            mapSuggestedVolume,
                                                            volumeUnit,
                                                            widget
                                                                .trackedUserProductList,
                                                            productDefaultResponse),
                                                    type: PageTransitionType
                                                        .rightToLeft,
                                                    duration: const Duration(
                                                        milliseconds: 400),
                                                  ),
                                                );

                                                if (result != null) {
                                                  setState(() {
                                                    //Cập nhật lại volume
                                                    volume = (double.tryParse(
                                                                result) ??
                                                            0.0)
                                                        .toInt(); // Cập nhật giá trị
                                                  });
                                                }
                                              },
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                            )
                                          
                                        : Container(),

                                    const SizedBox(height: 10),
                                    //? Option2 : Số lượng
                                    widget.isFromDetailPage

                                    ? EditSelectOptionBar.cantEdit(
                                        labelText: "Số lượng",
                                        weightText: "$quantity sản phẩm",
                                        iconImage: "",
                                        gradientStartColor:
                                            Colors.white,
                                        gradientEndColor: Colors.white,
                                        onPressed: () {
                                        },
                                        width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                      )
                                    : EditSelectOptionBar(
                                        labelText: "Số lượng",
                                        weightText: "$quantity sản phẩm",
                                        gradientStartColor:
                                            const Color(0xffB0E0E6),
                                        gradientEndColor: Colors.white,
                                        onPressed: () {
                                          //Component
                                          showEditQuantityDialog(context,
                                              (selectedQuantity) {
                                            setState(() {
                                              //Cập nhật lại quantity
                                              quantity = selectedQuantity;
                                            });
                                          });
                                        },
                                        width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                      ),
                                    

                                    const SizedBox(height: 10),
                                    //? Option3 : HSD
                                    widget.isFromDetailPage
                                    ? EditSelectOptionBar.cantEdit(
                                        labelText: "HSD",
                                        iconImage: "",
                                        weightText: "$expiredDate",
                                        gradientStartColor: Colors.white,
                                        gradientEndColor: Colors.white,
                                        onPressed: () {
                                        },
                                        width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                      )
                                    : EditSelectOptionBar(
                                        labelText: "HSD",
                                        weightText: "$expiredDate",
                                        gradientStartColor: Color(0xffB0E0E6),
                                        gradientEndColor: Colors.white,
                                        onPressed: () {
                                          // Gọi dialog để chọn ngày
                                          // Component
                                          showEditDateDialog(
                                            context,
                                            covertToDateTime(expiredDate,
                                                "dd/MM/yyyy"), // Hoặc giá trị ngày giờ hiện tại hoặc giá trị ngày bạn muốn
                                            (selectedDate) {
                                              setState(() {
                                                //Cập nhật lại HSD
                                                expiredDate =
                                                    selectedDate; // Cập nhật ngày đã chọn
                                              });
                                            },
                                          );
                                        },
                                        width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                      ),
                                     
                                   
                                    const SizedBox(height: 10),
                                    //? Option4 : Người dùng
                                    EditSelectOptionBar(
                                      labelText: "Người dùng",
                                      weightText: "$usernum người",
                                      gradientStartColor: Color(0xffB0E0E6),
                                      gradientEndColor: Colors.white,
                                      onPressed: () {
                                        ShowUserNum(context,
                                            (onUserNumSelected) {
                                          setState(() {
                                            //Cập nhật lại số lượng người sử dụng
                                            usernum = onUserNumSelected;
                                          });
                                        });
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                    ),
                                    
                                    const SizedBox(height: 10),
                                    //? Option5 : Cường độ
                                    EditSelectOptionBar(
                                      labelText: "Cường độ",
                                      weightText: "$intensity lần/$unit",
                                      gradientStartColor: Color(0xffB0E0E6),
                                      gradientEndColor: Colors.white,
                                      onPressed: () {
                                        ShowIntensitySelected(context,
                                            (onIntensitySelected,
                                                selectedUnit) {
                                          setState(() {
                                            //Cập nhật lại cường độ sử dụng
                                            intensity = onIntensitySelected;
                                            unit = selectedUnit;
                                          });
                                        });
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                    ),
                                    
                                    const SizedBox(height: 10),
                                    EditSelectOptionBar(
                                        labelText: "Cách bảo quản",
                                        weightText: preserveWay,
                                        gradientStartColor: Colors.white,
                                        gradientEndColor: Colors.white,
                                        onPressed: () {},
                                        width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                      ),
                                    
                                    const SizedBox(height: 10),
                                    // Option7 : Giá
                                    widget.isFromDetailPage
                                    ? EditSelectOptionBar.cantEdit(
                                        labelText: "Giá",
                                        weightText: turnToMoneyFormat(cost),
                                        iconImage: "", // Cập nhật hiển thị giá
                                        gradientStartColor: Colors.white,
                                        gradientEndColor: Colors.white,
                                        onPressed: () async {
                                        },
                                        width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                      )
                                    : EditSelectOptionBar(
                                        labelText: "Giá",
                                        weightText: turnToMoneyFormat(
                                            cost), // Cập nhật hiển thị giá
                                        gradientStartColor: Color(0xffB0E0E6),
                                        gradientEndColor: Colors.white,
                                        onPressed: () async {
                                          // Sử dụng await để lấy giá trị từ EditPrice
                                          //Map<String,List<int>> cost
                                          //List<TrackedUserProduct>
                                          //ProductDefault

                                          final selectedPrice =
                                              await Navigator.push(
                                            context,
                                            PageTransition(
                                              child: widget.isEdited
                                                  ? EditPriceItemsPage.isEdited(
                                                      mapSuggestedCost,
                                                      widget
                                                          .trackedUserProductList,
                                                      productDefaultResponse,
                                                      true,
                                                      cost, //Cost đã thêm
                                                      dateBought) //Ngày đã mua
                                                  : EditPriceItemsPage(
                                                      mapSuggestedCost,
                                                      widget
                                                          .trackedUserProductList,
                                                      productDefaultResponse),
                                              type:
                                                  PageTransitionType.rightToLeft,
                                              duration: const Duration(
                                                  milliseconds: 600),
                                            ),
                                          );

                                          // Kiểm tra nếu selectedPrice không null và là kiểu String
                                          if (selectedPrice != null &&
                                              selectedPrice is Payment) {
                                            setState(() {
                                              // Cập nhật giá trị cho cost
                                              cost = (double.tryParse(selectedPrice
                                                          .getPriceOfProduct()) ??
                                                      0.0)
                                                  .toInt(); // Chuyển đổi từ String sang int
                                              dateBought =
                                                  selectedPrice.getDateBought();
                                            });
                                          }
                                        },
                                        width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                      ) 

                                    // const SizedBox(height: 10),
                                    ]
                                  ),
                                ),

                                //Kết thúc Row
                              ]),
                        ),
                      ) // Sẽ nằm giữa màn hình
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  (widget.isFromDetailPage && widget.isBeingUsed) //Sản phẩm đang được sử dụng sẽ không được dùng thêm
                      //(Thường sẽ từ DetailProductPage)
                      ? Container(
                          // color: Colors.black,
                          child: const Text(
                            //Subtitle
                            "*Bạn hiện tại đang sử dụng sản phẩm này!",
                            style: TextStyle(
                              fontFamily: "inter",
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff18A0FB),
                            ),
                          ),
                        )
                      : Container(
                          // color: Colors.red,
                          //Chọn sản phẩm dùng liền

                          height: height * 0.204,
                          // color: Colors.green[50],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Trash banner
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        "Bạn có muốn sử dụng ngay 1 ${productName.toLowerCase()}?",
                                        style: const TextStyle(
                                          fontFamily: "inter",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff363636),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: const Text(
                                        "*Hệ thống sẽ hiểu bạn đang sử dụng 1 sản phẩm",
                                        style: TextStyle(
                                            fontFamily: "inter",
                                            color: Color(0xff18A0FB),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // ? FETCH Dữ liệt ở đây
                                    Container(
                                        height: height * 0.1,
                                        width: width * 1,
                                        // color: Colors.green[100],
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ItemUsedComponent(
                                              isOpened,
                                              onPressed: () async{
                                                //Check product been using
                                                bool isBeenUsing = await checkProductBeenUsing(productName);
                                                if(!isBeenUsing){
                                                  setState(() {
                                                    isOpened = !isOpened;
                                                  });
                                                }
                                                else{
                                                  _showWarinigDialog(context, height, width, "chamlai1chut_banner");
                                                }
                                              },
                                              itemImage: imagePath,
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    // Container confirm button
                    // color: Colors.blueGrey,
                    child: Center(
                      child: TextButton(
                        onPressed: () async{
                          //Chỉnh sửa thông tin
                          if(widget.isFromDetailPage){
                            await onEdited();
                            _showWarinigDialog(context, height, width, "dacapnhat_banner");
                          }
                          else{
                            widget.isEdited ? onReconfirm() : onConfirm();
                            Navigator.push(
                              context,
                              PageTransition(
                                child: ProductListPage(
                                    widget.trackedUserProductList),
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 300),
                              ),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(266, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text("Xác nhận!",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // const SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}
