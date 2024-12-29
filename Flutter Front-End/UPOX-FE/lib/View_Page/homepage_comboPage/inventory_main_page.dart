import 'dart:convert';
import 'dart:developer';

import 'package:first_app/Components/CommonComponent/title_text.dart';

import 'package:first_app/Components/inventory_component/inventory_header_page.dart';
import 'package:first_app/Components/inventory_component/inventory_model/inventory_filter_tags.dart';
import 'package:first_app/Components/inventory_component/inventory_model/inventory_items.dart';
import 'package:first_app/Components/inventory_component/inventory_model/inventory_searchButton.dart';
import 'package:first_app/Components/inventory_component/inventory_model/inventory_sidebar.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/View_Page/detail_product_combo_view/detail_product_page.dart';
import 'package:first_app/model/inventory_response.dart';
import 'package:first_app/model/track_user_product_response.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class InventoryMainPage extends StatefulWidget {
  Map<String, dynamic>? reloadSuggestionCategories = {};
  List<TrackedUserProductResponse>? reloadedProductList = [];
  Map<String, bool>? reloadedChosenFilters = {};

  //Dùng để truyền qua DetailProductPage (để khi back còn truyền lại được)

  InventoryMainPage({super.key});
  InventoryMainPage.reload(this.reloadSuggestionCategories,
      this.reloadedProductList, this.reloadedChosenFilters,
      {super.key});

  @override
  State<InventoryMainPage> createState() => _InventoryMainPage();
}

class _InventoryMainPage extends State<InventoryMainPage> {
  late Map<String, dynamic>? suggestionCategories = {};
  late List<TrackedUserProductResponse>? displayedProductList = [];

  //name: loại filter-tên filter
  Map<String, bool> chosenFilters = {
    //Status
    "status-SPOILT": false,
    "status-LATE": false,
    "status-IN_USE": false,
    //Lateness
    "lateness-MONTH_BEFORE": false,
    "lateness-SEVEN_DAYS_BEFORE": false,
    "lateness-THREE_DAYS_BEFORE": false,
    //Categories
    //[6] từ item thứ 7
    //Dựa vào suggestionCategories
  };

  int _imageState = 0;
  void _toggleImageState() {
    //String sortBy = EXPIRY_DATE
    setState(() {
      _imageState = (_imageState + 1) % 3;
      if(_imageState == 1 || _imageState == 0){
        displayedProductList!.sort(
          (a, b) {
            return a.expiryDate!.compareTo(b.expiryDate!);
          },
        );
      }
      else if(_imageState == 2){
        displayedProductList!.sort(
          (a, b) {
            return b.expiryDate!.compareTo(a.expiryDate!);
          },
        );
      }
      
    });
  }

  int _imageState2 = 0;
  void _toggleImageState2() {
    //String sortBy = QUANTITY
    setState(() {
      _imageState2 = (_imageState2 + 1) % 3;
      if(_imageState2 == 1){
        displayedProductList!.sort(
          (a, b) {
            return a.quantity!.compareTo(b.quantity!);
          },
        );
      }
      else if(_imageState2 == 2 || _imageState2 == 0){
        displayedProductList!.sort(
          (a, b) {
            return b.quantity!.compareTo(a.quantity!);
          },
        );
      }
    });
  }

  // bool isProductDetailOpen = false;
  // void toggleProductDetail(bool isOpen) {
  //   setState(() {
  //     isProductDetailOpen = isOpen;
  //   });
  // }

  int selectedIndex = -1;
  void _onTagPressed(int index, String categories) async {
    displayedProductList = await fetchFilterData(categories);
    //String categories
    setState(() {
      selectedIndex = index;
    });
  }

  int selectedIndex_secondFilter = -1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Dữ liệu mock hoặc lấy từ API
  List<Map<String, dynamic>> items = [
    {
      "imageUrl": "assets/category/nuocsucmieng_banner.png",
      "title": "Phấn mắt",
      "description": "1 sản phẩm đang sử dụng",
      "quantity": 2,
    },
    {
      "imageUrl": "assets/category/nuocsucmieng_banner.png",
      "title": "Son môi",
      "description": "3 sản phẩm đang sử dụng",
      "quantity": 5,
    },
  ];

  void reload(List<TrackedUserProductResponse> filterProductList, Map<String, bool> newFilters) {
    //InventorySlideBar gọi hàm này
    setState(() {
      //Sẽ được gọi khi filter bên InventorySlideBar cập nhật
      displayedProductList = filterProductList;
      chosenFilters = newFilters;
    });
  }

  FetchingService fetchingService = FetchingService.initialize();
  Future<InventoryResponse> fetchData() async {
    log("Inventory fetching");

    funcCallBack() {
      return fetchingService.fetchInventoryInitial();
    }

    RequestController requestController =
        RequestController.withoutParameter(funcCallBack);

    fetchingService = FetchingService(requestController: requestController);

    return await requestController.request();
  }

  Future<List<TrackedUserProductResponse>> fetchFilterData(
      String categories) async {
    //displayedProductList = await fetchingService.fetchInventoryWithCondition();
    log("Conditional Categories Inventory fetching");

    funcCallBack() {
      return fetchingService.fetchInventoryWithCondition(
          "null", categories, "null", "null", "null", false);
    }

    RequestController requestController =
        RequestController.withoutParameter(funcCallBack);

    fetchingService = FetchingService(requestController: requestController);

    return await requestController.request();
  }

  Future<dynamic> fetchInitialData() async {
    log("Calling Fetching Inventory");

    bool conditionWidget = widget.reloadedProductList!.isEmpty;
    bool conditionState = displayedProductList!.isEmpty;

    log("Calling Fetching Inventory Next");

    log("widget.reloadedProductList isNull: $conditionWidget");
    log("displayedProductList isNull: $conditionState");

    //Chỉ fetch getInitialInventory
    //Chỉ fetch khi displayedProductList == null

    //Case 1: DetailProductPage call back và InventorySearchPage call back
    //(widget.reloadedProductList != null && displayedProductList == null)
    //Nó chỉ đúng khi DetailProductPage back ngược lại
    //suggestionCategories = widget.reloadSuggestionCategories ?? {};
    //displayedProductList = widget.reloadedProductList ?? [];
    //chosenFilters sẽ thay đổi
    //updateChosenFilters(false);
    if (!conditionWidget && conditionState) {
      log("RELOAD INVENTORY");
      suggestionCategories = widget.reloadSuggestionCategories!;
      displayedProductList = widget.reloadedProductList!;
      chosenFilters = widget.reloadedChosenFilters!;
    }

    //Case 2: Initial (widget.reloadedProductList == null && displayedProductList == null)
    //chosenFilters sẽ thay đổi
    //updateChosenFilters(true);
    else if (conditionWidget && conditionState) {
      log("INITIAL INVENTORY");
      InventoryResponse inventoryResponse = await fetchData();
      displayedProductList = inventoryResponse.trackedUserProductResponse;
      suggestionCategories = inventoryResponse.suggestionCategories;
      updateChosenFilters(true);
    }

    //Case 3: filter từ tag và từ sidebar (displayedProductList != null)
    //displayedProductList được cập nhật
    //chosenFilters sẽ thay đổi
    //updateChosenFilters(false);
    else if (!conditionState) {
      log("FILTER INVENTORY");
      widget.reloadedProductList = [];
      updateChosenFilters(false);
    }

    //Trả về List<TrackedUserProductResponse>
    return displayedProductList;
  }

  String fixEncoding(String input) {
    // Chuyển đổi chuỗi thành byte
    List<int> bytes =
        latin1.encode(input); // Mã hóa chuỗi như ISO-8859-1 (Latin1)

    // Chuyển đổi byte thành chuỗi UTF-8
    String fixedString = utf8.decode(bytes);

    return fixedString;
  }

  void updateChosenFilters(bool isCalledFromOtherPages) {
    //Bước 1: Thêm categories
    //isCalledFromOtherPages == true
    //thêm categories vào trong chosenFilters dựa vào suggestionCategories
    //category-<tên category>:false
    if (isCalledFromOtherPages) {
      suggestionCategories!.forEach(
        (key, value) {
          log("Create: category-${fixEncoding(key)}");
          chosenFilters["category-${fixEncoding(key)}"] = false;
        },
      );
    }

    //Bước 2: Đánh dấu những categories đang được xuất hiện
    //dựa vào displayedProductList để đánh dấu
    //category-<tên category>:true
    displayedProductList!.forEach(
      (element) {
        chosenFilters["category-${element.categoryName}"] = true;
        log("Setting: category-${element.categoryName}");
      },
    );

    // log("Total chosenFilters: ${chosenFilters.length}");
  }

  List<Widget> _buildSuggestionCategories() {
    return List.generate(
      suggestionCategories!.length, //suggestionCategories.length
      (index) {
        String key = suggestionCategories!.keys.elementAt(index);

        return Container(
          margin: const EdgeInsets.only(right: 10),
          child: InventoryFilterTags(
            initialBackgroundColor:
                selectedIndex == index ? Colors.blue : Colors.white,
            initialTextColor:
                selectedIndex == index ? Colors.white : Colors.black,
            tagName: '${fixEncoding(key)}',
            onPressed: () => _onTagPressed(index, fixEncoding(key)),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String originalPathBoxUnOpen = "assets/box/unopen/unopened_icon_";
  String originalPathBoxOpenNoBackground = "assets/box/open/no_background/opened_icon_";
  String originalPathIconStatus = "assets/status/";
  String originalPathProduct = "assets/product";

  Set<String> chosenDisplayedCategories(){
    Set<String> chosenDisplayedCategories = {};

    log("displayedProductList.length: ${displayedProductList!.length}");

    displayedProductList!.forEach(
      (element) {
        chosenDisplayedCategories.add(element.categoryName!);
      },
    );
    return chosenDisplayedCategories;
  }

  List<Container> _buildDisplayedContainerProductList(
    double screenHeight, double screenWidth) {
    Set<String> chosenFilters = chosenDisplayedCategories();
    int size = chosenFilters.length;

    log("chosenFilters.length: ${chosenFilters.length}");
    log("size: ${size}");

    return List.generate(
      size,
      (index) {
        return Container(
          margin: EdgeInsets.only(bottom: 15),
            child: Column(
          children: [
            Container(
              // color: Colors.amberAccent,
              width: screenWidth * 0.6,
              margin: EdgeInsets.only(right: screenWidth * 0.25),
              child: TitleText(
                textAlign: TextAlign.start,
                titleName: chosenFilters.elementAt(index),
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              // color: Colors.blueGrey,
              width: screenWidth * 0.828,
              child: Wrap(
                  //một dạng giống row
                  // alignment: WrapAlignment.start,
                  spacing: 10,
                  runSpacing: 15,
                  children: _buildDisplayedProductList(
                    chosenFilters.elementAt(index)
                  )
              ),
            ),
          ],
        ));
      },
    );
  }

  Map<String, Map<String, Color>> colorOfStatus = {
    "NORMAL": {
      "itemTitleColor": const Color(0xff18A0FB),
      "itemDescripBackgroundColor": const Color(0xff89D4FF)
    },
    "MONTH_BEFORE": {
      "itemTitleColor": const Color(0xffF6E14F),
      "itemDescripBackgroundColor": const Color(0xffFAE871)
    },
    "SEVEN_DAYS_BEFORE": {
      "itemTitleColor": const Color(0xffF5BC42),
      "itemDescripBackgroundColor": const Color(0xffFDBF77)
    },
    "THREE_DAYS_BEFORE": {
      "itemTitleColor": const Color(0xffF36565),
      "itemDescripBackgroundColor": const Color(0xffF78888)
    },
    "LATE": {
      "itemTitleColor": const Color(0xffD75AED),
      "itemDescripBackgroundColor": const Color(0xffD288F7)
    },
    "SPOILT": {
      "itemTitleColor": const Color(0xffA0A0A0),
      "itemDescripBackgroundColor": const Color(0xff89D4FF)
    },
  };

  Map<String, int> rankOfStatus = {
    "NORMAL": 6,
    "MONTH_BEFORE": 5,
    "SEVEN_DAYS_BEFORE": 4,
    "THREE_DAYS_BEFORE": 3,
    "LATE": 2,
    "SPOILT": 1
  };

  void sortByExpiredDate(List<TrackedUserProductResponse> trackedUserProduct){
    trackedUserProduct.sort((a, b) {
      return a.expiryDate!.compareTo(b.expiryDate!);
    },);
  }

  InventoryItems mergingDisplayedProducts(InventoryItems oldWidget, TrackedUserProductResponse newProduct, List<TrackedUserProductResponse> updatedProducts){
    int productsHaveBeenUsed = newProduct.isOpened! ? (newProduct.numberOfProductsHasFinished! - 1)
    : newProduct.numberOfProductsHasFinished!;
    
    
    int newQuantity = int.parse(oldWidget.itemQuantity.split(" ")[0]) + newProduct.quantity! - productsHaveBeenUsed;
    
    

    bool isAlreadyOpened = oldWidget.iconBox.isEmpty? false:true;
    bool newIsOpened = isAlreadyOpened? isAlreadyOpened : newProduct.isOpened!;
    int checkStatusValue = rankOfStatus[newProduct.statusName]!;
    int oldStatusValue = rankOfStatus[oldWidget.statusName]!;
    String newStatus = "";
    if(checkStatusValue < oldStatusValue){
      newStatus = newProduct.statusName!;
    }
    else{
      newStatus = oldWidget.statusName;
    }
    
    //quantity
    oldWidget.itemQuantity = "$newQuantity sản phẩm";
    //iconBox
    oldWidget.iconBox = newIsOpened
                  ? "$originalPathBoxOpenNoBackground$newStatus.png" : "";

    //statusIcon
    oldWidget.statusIcon = newStatus.contains("NORMAL")
              ? "" : "$originalPathIconStatus${newStatus}.png";
    
    //itemTitleColor
    oldWidget.itemTitleColor = colorOfStatus[newStatus]!["itemTitleColor"]!;

    //itemDescrip
    oldWidget.itemDescrip = newStatus.contains("SPOILT")
              ? "Sản phẩm đã hỏng!"
              : "${newIsOpened ? 1 : 0} sản phẩm đang dùng";

    //itemDescripBackgroundColor
    oldWidget.itemDescripBackgroundColor = colorOfStatus[newStatus]![
              "itemDescripBackgroundColor"]!;

    //statusName
    oldWidget.statusName = newStatus;
    
    //iconBox2
    oldWidget.iconBox2 = "$originalPathBoxUnOpen$newStatus.png";
    
    //trackedSamedProduct
    sortByExpiredDate(updatedProducts);
    oldWidget.trackedSameProduct = updatedProducts;

    //onPress
    oldWidget.onPressed = () {
      Navigator.push(
        context,
        PageTransition(
          child: DetailProductPage(suggestionCategories!, displayedProductList!,
              chosenFilters, updatedProducts), //Truyền thông tin product vào
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 300),
        ),
      );
    };
    return oldWidget;
    
  }

  List<Widget> _buildDisplayedProductList(String categoryName) {
    List<TrackedUserProductResponse> tmp = [];
    displayedProductList!.forEach(
      (element) {
        if (element.categoryName!.contains(categoryName)) {
          tmp.add(element);
        }
      },
    );
    int size = tmp.length;
    Map<String, List<TrackedUserProductResponse>> mergingMap = {}; //productID, trackedSameProducts
    Map<String, int> tempIndex = {}; //productID, index
    List<InventoryItems> displayedProducts = [];
    for(int i = 0; i < size; i++){
      final item = tmp[i];
      if(mergingMap.containsKey(item.productId)){
          mergingMap[item.productId]!.add(item);
          int oldIndex = tempIndex[item.productId!]!;
          InventoryItems oldWidget = displayedProducts[oldIndex];
          displayedProducts[oldIndex] = mergingDisplayedProducts(oldWidget, item, mergingMap[item.productId]!);

      }
      else{
        mergingMap[item.productId!] = [item];
        tempIndex[item.productId!] = i;
        InventoryItems product = InventoryItems(
          //Sản phẩm thu nhỏ
          iconBox: //Chỉ hiển thị khi có sản phẩm inUse //Dựa vào status chọn màu
              item.isOpened!
                  ? "$originalPathBoxOpenNoBackground${item.statusName}.png"
                  : "",
          //"$originalPathBoxOpenNoBackground${item.statusName}.png"

          statusIcon: //Dựa vào status chọn icon
              item.statusName!.contains("NORMAL")
              ?""
              :"$originalPathIconStatus${item.statusName}.png",
          //"$originalPathIconStatus${item.statusName}.png"

          itemImage:
              "$originalPathProduct${item.imagePath}.png", //Product Image
          //"$originalPathProduct${item.imagePath}.png"

          itemTitle: "${item.productName}", //Tên sản phẩm
          itemTitleColor: colorOfStatus[item.statusName]![
              "itemTitleColor"]!, //Dựa vào status chọn màu

          iconBox2: //ảnh đại diện quanity //Dựa vào status chọn màu
              "$originalPathBoxUnOpen${item.statusName}.png",
          //"$originalPathBoxUnOpen${item.statusName}.png"

          itemQuantity: //quantity
              "${item.quantity !- (item.numberOfProductsHasFinished! - (item.isOpened! ? 1 : 0))} sản phẩm",

          itemDescrip: item.statusName!.contains("SPOILT")
              ? "Sản phẩm đã hỏng!"
              : "${item.isOpened! ? 1 : 0} sản phẩm đang dùng", //Số phẩm đang được sử dụng
          //Xét product inUse
          itemDescripBackgroundColor: colorOfStatus[item.statusName]![
              "itemDescripBackgroundColor"]!, //Dựa vào status chọn màu
          
          statusName: item.statusName!,
          
          onPressed: () {
            //Bấm vào chi tiết sản phẩm (Chưa xử lý)
            Navigator.push(
              context,
              PageTransition(
                child: DetailProductPage(suggestionCategories!, displayedProductList!, chosenFilters, mergingMap[item.productId!]!), //Truyền thông tin product vào
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 300),
              ),
            );
          },
        );
        product.setTrackedSameProduct(mergingMap[item.productId!]!);
        displayedProducts.add(product);
      }
    }
    return displayedProducts;
  }

  @override
  Widget build(BuildContext context) {
    //Prepare
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String tagImage = "assets/sortfilter/filter_tag_icon.png";
    String tagImage2 = "assets/sortfilter/filter_tag_icon.png";

    Color backgroundColor = Colors.white;
    Color textColor = Colors.black;
    Color backgroundColor2 = Colors.white;
    Color textColor2 = Colors.black;
    //** Filter cho HSD */
    if (_imageState == 1) {
      tagImage = "assets/sortfilter/sort-up.png";
      backgroundColor = Colors.blue;
      textColor = Colors.white;
    } else if (_imageState == 2) {
      tagImage = "assets/sortfilter/sort-down.png";
      backgroundColor = Colors.blue;
      textColor = Colors.white;
    }
    //** Filter cho Số lượng */
    if (_imageState2 == 1) {
      tagImage2 = "assets/sortfilter/sort-up.png";
      backgroundColor2 = Colors.blue;
      textColor2 = Colors.white;
    } else if (_imageState2 == 2) {
      tagImage2 = "assets/sortfilter/sort-down.png";
      backgroundColor2 = Colors.blue;
      textColor2 = Colors.white;
    }

    //Hiển thị
    //FutureBuilder()
    return FutureBuilder(
      future: fetchInitialData(),
      builder: (context, snapshot) {
        //Pending
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: Colors.blue,
              size: 50,
            ),
          );
        }
        //Worked case
        if (snapshot.hasData && snapshot.data != null) {
          return Scaffold(
              key: _scaffoldKey,
              //? Gọi trực tiếp cho Drawer
              endDrawer: InventorySidebar.filter(
                  //reload
                  //chosenFilter
                  reload,
                  chosenFilters), // --> Drawer thì từ trái sang phải || endDrawer là từ phải sang trái
              //? Event vuốt cho sidebdar
                body: GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails details) {
                    if (details.primaryVelocity! < 0) {
                      _scaffoldKey.currentState
                          ?.openDrawer(); // Vuốt từ phải sang trái
                    }
                  },
                  child: SafeArea(
                      child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const InventoryHeaderPage(),
                        // const SizedBox(height: 5),
                        // InventoryContent(),
                        InventorySearchButton.search(
                            reload,
                            suggestionCategories!,
                            displayedProductList!,
                            chosenFilters),
                        Container(
                          height: screenHeight * 0.695,
                          // color: Colors.amber,
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // const InventorySearchButton(),
                                const SizedBox(height: 5),
                                //Filter Selection 1
                                Container(
                                  // color: Colors.amber,
                                  height: screenHeight * 0.065,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // scroll ngang
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, bottom: 5),
                                      child: Row(
                                          children:
                                              _buildSuggestionCategories()),
                                    ),
                                  ),
                                ),
                                //Filter Selection 2
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Row(
                                        //Sort
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Row1
                                          Row(
                                            children: [
                                              InventoryFilterTags(
                                                initialBackgroundColor:
                                                    backgroundColor,
                                                initialTextColor: textColor,
                                                tagName: 'Hạn sử dụng',
                                                initialWidth: 0.5,
                                                tagImage: tagImage,
                                                onPressed: () {
                                                  _toggleImageState(); //EXPIRY_DATE
                                                },
                                              ),
                                              const SizedBox(width: 10),
                                              InventoryFilterTags(
                                                initialBackgroundColor:
                                                    backgroundColor2,
                                                initialTextColor: textColor2,
                                                tagName: 'Số lượng',
                                                initialWidth: 0.5,
                                                tagImage: tagImage2,
                                                onPressed: () {
                                                  _toggleImageState2(); //QUANTITY
                                                },
                                              ),
                                            ],
                                          ),
                                          // SideBar Button
                                          TextButton.icon(
                                            onPressed: () {
                                              _scaffoldKey.currentState
                                                  ?.openEndDrawer();
                                            },
                                            style: TextButton.styleFrom(
                                              splashFactory:
                                                  NoSplash.splashFactory,
                                              overlayColor: Colors.transparent,
                                            ),
                                            label: Image.asset(
                                              "assets/button_open_filter.png",
                                              width: screenWidth * 0.08,
                                              height: screenHeight * 0.08,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),

                                // Item List
                                Container(
                                  // height: screenHeight * 0.53,
                                  child: Column(
                                    children: [
                                      //List<Container>
                                      //** Category 1 */
                                      Container(
                                          child: Column(
                                              children:
                                                  _buildDisplayedContainerProductList(
                                                      screenHeight,
                                                      screenWidth))),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ))));
        }

        //Failed case
        else {
          return const SnackBar(
            content: Text("Took too long to response"),
            backgroundColor: Colors.red,
          );
        }
      },
    );
  }
}
