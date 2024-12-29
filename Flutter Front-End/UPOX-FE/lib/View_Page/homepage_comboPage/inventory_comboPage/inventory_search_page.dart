import 'dart:developer';

import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/CommonComponent/textbutton.dart';
import 'package:first_app/Components/CommonComponent/textbutton_imageicon_right.dart';
import 'package:first_app/Components/edit_page_component/SelectHistoryComponent/edit_select_history.dart';
import 'package:first_app/Components/inventory_component/inventory_history_search.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/View_Page/homepage_comboPage/inventory_main_page.dart';
import 'package:first_app/model/track_user_product_response.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class InventorySearchPage extends StatefulWidget {
  late Function reloadProductList; //CallBack
  //Trả về
  late Map<String, dynamic> reloadSuggestionCategories;
  late List<TrackedUserProductResponse> reloadedProductList;
  late Map<String,bool> reloadedChosenFilters;
  

  InventorySearchPage({super.key});
  InventorySearchPage.search(this.reloadProductList, this.reloadSuggestionCategories,
  this.reloadedProductList, this.reloadedChosenFilters, {super.key});

  @override
  State<InventorySearchPage> createState() => _InventorySearchPageState();
}

class _InventorySearchPageState extends State<InventorySearchPage> {
  // Giả định đây là danh sách sản phẩm nhận được từ API
  //Bỏ (Không kịp)
  final List<String> products = [
    "Kem Dưỡng Da Dove",
    "Kem Đánh Răng Colgate",
    "Sữa Tắm Nivea",
    "Xà Phòng Lifebuoy",
    "Nước Rửa Tay Dettol",
    "Sữa Dưỡng Thể Vaseline",
    "Kem Chống Nắng Nivea",
    "Nước Tẩy Trang Garnier",
    "Nước Hoa Hồng Some By Mi",
    "Sữa Tắm Dove"
  ];

  // Biến để kiểm soát việc hiển thị danh sách
  bool showMore = false;

  void _toggleShowMore() {
    setState(() {
      showMore = !showMore; // Đảo ngược giá trị của showMore
    });
  }

  FetchingService fetchingService = FetchingService.initialize();

  Future<List<TrackedUserProductResponse>> fetchData(String searchValue) async{
    //fetch data from conditional inventory
    //trackedUserProductList = await fetchingService.fetchInventoryWithCondition();
    //return trackedUserProductList;
    log("Conditional Categories Inventory fetching");

    funcCallBack() {
      return fetchingService.fetchInventoryWithCondition(
        searchValue,
        "null",
        "null",
        "null",
        "null",
        false
      );
    }

    RequestController requestController = RequestController.withoutParameter(
      funcCallBack
    );

    fetchingService = FetchingService(requestController: requestController);

    return await requestController.request();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    TextEditingController _controller = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            height: height * 0.97,
            // color: Colors.amber,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //? Back Button
                Container(
                  child: BackButtonComponent(
                    targetPage: InventoryMainPage(),
                    iconColor: Colors.blue,
                    textColor: Colors.blue,
                    labelText: "Back",
                  ),
                ),
                const SizedBox(height: 20),

                //? Search bar và nút Tìm Kiếm
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Tìm sản phẩm",
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                      const SizedBox(width: 10),
                      CustomTextButton(
                        onPressed: () async {
                          List<TrackedUserProductResponse> trackedUserProductList = await fetchData(_controller.text);
                          Navigator.of(context, rootNavigator: true).push(
                            PageTransition(
                              child: InventoryMainPage.reload(widget.reloadSuggestionCategories, trackedUserProductList, widget.reloadedChosenFilters),
                              type: PageTransitionType.leftToRight,
                              duration: const Duration(milliseconds: 300),
                            ),
                          );
                        },
                        filterName: "Tìm Kiếm",
                        backgroundColor: Colors.white,
                        textColor: Colors.blue,
                        fontWeight: FontWeight.w700,
                        widthFactor: 0.05,
                        heightFactor: 0.05,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),



                //? History search //Bỏ
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemCount: showMore ? products.length : 5,
                //   itemBuilder: (context, index) {
                //     String iconPath = index < 2
                //         ? "assets/newest_search.png"
                //         : "assets/oldest_search.png";
                //     return InventoryHistorySearch(
                //       onPressed: () {},
                //       historyText: products[index],
                //       iconSearch: iconPath,
                //       onDelete: () {
                //         setState(() {
                //           products.removeAt(index);
                //         });
                //       },
                //     );
                //   },
                // ),
                // const SizedBox(height: 5),
                // //? Nút "More"
                // Center(
                //   child: Container(
                //     width: width * 0.33,
                //     height: height * 0.05,
                //     child: CustomTextButtonImageIconRight(
                //       onPressed: _toggleShowMore,
                //       backgroundColor: Colors.white,
                //       filterName: showMore ? 'Ẩn bớt' : 'Xem thêm',
                //       textColor: const Color(0xffA7A7A7),
                //       iconImage: "assets/toggle_down.png",
                //       widthFactor: 0.2,
                //       iconHeight: 10,
                //       iconWidth: 10,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
