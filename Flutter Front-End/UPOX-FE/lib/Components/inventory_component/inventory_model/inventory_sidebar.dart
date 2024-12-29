import 'dart:developer';

import 'package:first_app/Components/CommonComponent/textbutton.dart';
import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:first_app/Components/inventory_component/inventory_model/inventory_filter_button.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/model/track_user_product_response.dart';
import 'package:flutter/material.dart';

class InventorySidebar extends StatefulWidget {
  late Function reloadProductList;
  // late Map<String, dynamic> suggestionCategory;
  late Map<String,bool> reloadedChosenFilters = {};



  InventorySidebar({super.key});
  InventorySidebar.filter(this.reloadProductList, this.reloadedChosenFilters, {super.key});

  @override
  State<InventorySidebar> createState() => _InventorySidebarState();
}

class _InventorySidebarState extends State<InventorySidebar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<TrackedUserProductResponse> trackedUserProductList;

  //Số lượng filter
  late int NUM_OF_FILTERS;
  // Danh sách để theo dõi trạng thái chọn
  List<bool> selectedFilters = [];
      

  void resetFilters() {
    setState(() {
      selectedFilters = List.generate(selectedFilters.length, (index) => false);
    });
  }

  FetchingService fetchingService = FetchingService.initialize();

  Future<List<TrackedUserProductResponse>> fetchData() async{
    //fetch data from conditional inventory
    //trackedUserProductList = await fetchingService.fetchInventoryWithCondition();
    //return trackedUserProductList;
    log("Conditional Filter Inventory fetching");

    String category = setUpFilterValue("category");
    String status = setUpFilterValue("status");
    String lateness = setUpFilterValue("lateness");

    log("Category: $category - Status: $status - Lateness: $lateness");


    funcCallBack() {
      return fetchingService.fetchInventoryWithCondition(
        "null",
        category,
        status,
        lateness,
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



  String setUpFilterValue(String factor){
    //status [0,2]
    //lateness [3,5]
    //category [6, NUM_OF_FILTERS - 1]
    String filters = "";
    int start = 0;
    int end = 0;
    switch(factor){
      case "status":
        start = 0;
        end = 2;
      case "lateness":
        start = 3;
        end = 5;
      case "category":
        start = 6;
        end = NUM_OF_FILTERS - 1;
      default:
    }
    for(int i = start; i <= end; i++){
      String chosenFilter = widget.reloadedChosenFilters.keys.elementAt(i);
      widget.reloadedChosenFilters[chosenFilter] = selectedFilters[i];
      if(selectedFilters[i]){
        
        chosenFilter = chosenFilter.split("-")[1];
        if(i == start){
          filters = chosenFilter;
        }
        else{
          filters = "$filters-$chosenFilter";
        }
      }
    }
    return filters;
  }
  
  Widget _buildGrid(){
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _buildGridTileList()
    );
    // return GridView.extent(
    //   maxCrossAxisExtent: 170,//px (trái này đến trái kia) //crossAxisCount Chỉ cần biết số cột, count sẽ tự chia đều thành các hàng
    //   // padding: const EdgeInsets.all(4),
    //   mainAxisSpacing: 10,
    //   crossAxisSpacing: 10,
    //   children: _buildGridTileList()
    // );
  }

  List<Container> _buildGridTileList(){
    Map<String, bool> mp = widget.reloadedChosenFilters;
    int CATEGORY_FILTER_START_OF = 6;
    int size = NUM_OF_FILTERS - CATEGORY_FILTER_START_OF;
    int nextIndex = CATEGORY_FILTER_START_OF;

    log("NUM_OF_FILTERS SIDEBAR: $nextIndex");

    // return List.generate(size, (index) {
    //   return Container(
    //     child: Text("testing"),  
    //   );
    // },);
    return List.generate(size, 
      (i) {
        log("Debug sidebar (1)");
        String cateName = mp.keys.elementAt(nextIndex + i);
        
        
        log("Debug sidebar (2)");
        log("cateName: $cateName");
        return Container(
          child: InventoryFilterButton(
              filterName: cateName.split("-")[1],
              onPressed: () {
                setState(() {
                  selectedFilters[nextIndex + i] = !selectedFilters[nextIndex + i];
                });
              },
              isSelected: selectedFilters[nextIndex + i],
              widthFactor: 0.05,
              heightFactor: 0.05,
            ),
        );
      }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // log("Debug sidebar (2)");
    NUM_OF_FILTERS = widget.reloadedChosenFilters.length;
    
    selectedFilters = List.generate(NUM_OF_FILTERS, (index) {
      String cate = widget.reloadedChosenFilters.keys.elementAt(index);
      return widget.reloadedChosenFilters[cate]!;
    },);

    
    // log("Debug sidebar (2)");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30, left: 20),
              child: const TitleText(
                titleName: "Bộ Lọc",
                fontSize: 25,
                fontWeight: FontWeight.w700,
                fontFam: "Isak Web",
              ),
            ),
            const SizedBox(height: 20),
            //? Loại sản Phẩm Button
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //** Loại sản phẩm Filter
                  Container(  
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const TitleText(
                          titleName: "Loại sản phẩm",
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFam: "Isak Web",
                        ),
                        const SizedBox(height: 10),
                        //Chuyển đổi thành Grid
                        //Đổ suggestionCategories lên grid
                        Container(
                          child: _buildGrid(),
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 10),
                  // Span
                  Container(
                    color: const Color(0xffE3E3E3),
                    width: screenWidth * 0.7,
                    height: 0.5,
                  ),
                  const SizedBox(height: 10),
                  // ** Tình trạng sản phẩm FIlter
                  Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const TitleText(
                          titleName: "Tình trạng sản phẩm ",
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFam: "Isak Web",
                        ),
                        //? Row 1
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            // ** Hàng Sắp hết hạn
                            InventoryFilterButton(
                                filterName: "Hàng hết hạn",
                                onPressed: () {
                                  setState(() {
                                    selectedFilters[0] = !selectedFilters[0];
                                  });
                                },
                                isSelected: selectedFilters[0],
                                widthFactor: 0.05,
                                heightFactor: 0.05),
                            const SizedBox(width: 20),
                            // ** Hàng Bị Hỏng
                            InventoryFilterButton(
                                filterName: "Không dùng kịp",
                                onPressed: () {
                                  setState(() {
                                    selectedFilters[1] = !selectedFilters[1];
                                  });
                                },
                                isSelected: selectedFilters[1],
                                widthFactor: 0.05,
                                heightFactor: 0.05),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Row 2
                        Row(
                          children: [
                            // ** Hàng đang sử dụng
                            InventoryFilterButton(
                                filterName: "Đang sử dụng",
                                onPressed: () {
                                  setState(() {
                                    selectedFilters[2] = !selectedFilters[2];
                                  });
                                },
                                isSelected: selectedFilters[2],
                                widthFactor: 0.02,
                                heightFactor: 0.05),
                          ],
                        ),
                      ])),
                  const SizedBox(height: 10),
                  // Span
                  Container(
                    color: const Color(0xffE3E3E3),
                    width: screenWidth * 0.7,
                    height: 0.5,
                  ),
                  const SizedBox(height: 10),
                  // ** Cảnh báo dùng kịp FIlter
                  Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const TitleText(
                          titleName: "Dùng kịp trước",
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFam: "Isak Web",
                        ),
                        const SizedBox(height: 10),
                        //? Row 1
                        Row(
                          children: [
                            // ** Trước 1 mont
                            InventoryFilterButton(
                                filterName: "Trước 1 tháng",
                                onPressed: () {
                                  setState(() {
                                    selectedFilters[3] = !selectedFilters[3];
                                  });
                                },
                                isSelected: selectedFilters[3],
                                widthFactor: 0.05,
                                heightFactor: 0.05),
                            const SizedBox(width: 20),
                            // ** Trước 7 ngày
                            InventoryFilterButton(
                                filterName: "Trước 7 ngày",
                                onPressed: () {
                                  setState(() {
                                    selectedFilters[4] = !selectedFilters[4];
                                  });
                                },
                                isSelected: selectedFilters[4],
                                widthFactor: 0.05,
                                heightFactor: 0.05),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Row 2
                        Row(
                          children: [
                            //** Trước 3 ngày
                            InventoryFilterButton(
                                filterName: "Trước 3 ngày",
                                onPressed: () {
                                  setState(() {
                                    selectedFilters[5] = !selectedFilters[5];
                                  });
                                },
                                isSelected: selectedFilters[5],
                                widthFactor: 0.02,
                                heightFactor: 0.05),
                          ],
                        ),
                      ])),
                  const SizedBox(height: 10),
                  Container(
                    color: const Color(0xffE3E3E3),
                    width: screenWidth * 0.7,
                    height: 0.5,
                  ),
                  const SizedBox(height: 10),
                  
                  //** Edit and Confirm button
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomTextButton(
                          backgroundColor: Colors.white,
                          onPressed: resetFilters,
                          filterName: "Cài lại",
                          borderColor: Colors.blue,
                          textColor: Colors.blue,
                          widthFactor: 0.3,
                          heightFactor: 0.05,
                        ),
                        const SizedBox(width: 10),
                        CustomTextButton(
                          onPressed: () async {
                            //Truyền dữ liệu đã filter ngược lại cho InventoryMainPage
                            List<TrackedUserProductResponse> trackedUserProductList = await fetchData();
                            await widget.reloadProductList(trackedUserProductList, widget.reloadedChosenFilters);
                          },
                          filterName: "Áp dụng",
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          widthFactor: 0.3,
                          heightFactor: 0.05,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
