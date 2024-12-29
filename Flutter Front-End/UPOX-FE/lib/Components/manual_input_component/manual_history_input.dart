import 'dart:convert';
import 'dart:developer';

import 'package:first_app/Components/manual_input_component/manual_history_bar.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/View_Page/edit_page_comboView/edit_main_page.dart';
import 'package:first_app/model/history_product_response.dart';
import 'package:first_app/model/product_default_response.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ManualHistoryInput extends StatefulWidget {
  List<String> historyProductResponse = [];
  Function navigateToEditPage;
  
  ManualHistoryInput(this.historyProductResponse, this.navigateToEditPage, {super.key});

  @override
  State<ManualHistoryInput> createState() => _ManualHistoryInput();
}

class _ManualHistoryInput extends State<ManualHistoryInput> {
  // Giả lập fetch data từ API
  // final List<String> items = [
  //   "Kem dưỡng da Dove",
  //   "Sữa rửa mặt Pond's",
  //   "Dầu gội Sunsilk",
  //   "Kem đánh răng Colgate",
  //   "Nước hoa Chanel",
  //   "Phấn phủ Maybelline"
  // ];

  late List<String> historyProduct;

  FetchingService fetchingService = FetchingService.initialize();
  //Check User Product
  Future<ProductDefaultResponse> checkProductExist(String productName) async{
    log("Checking product exist");
    funcCallBack() {
      return fetchingService.checkProductExist(productName);
    }
    RequestController requestController = RequestController.withoutParameter(
      funcCallBack
    );
    fetchingService = FetchingService(requestController: requestController);
    return await requestController.request();
  }

  String fixEncoding(String input) {  
    // Chuyển đổi chuỗi thành byte  
    List<int> bytes = latin1.encode(input);  // Mã hóa chuỗi như ISO-8859-1 (Latin1)  
    
    // Chuyển đổi byte thành chuỗi UTF-8  
    String fixedString = utf8.decode(bytes);  
    
    return fixedString;  
  }  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    historyProduct = widget.historyProductResponse;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Center(
      child: Container(
        height: height * 0.55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Hiển thị danh sách
            historyProduct.length == 0
            ? Container()
            : Column(
              children: List.generate(
                historyProduct.length,
                (index) => Column(
                  children: [
                    ManualHistoryBar(
                      gradient: index < 3
                          ? const LinearGradient(
                              colors: [Color(0xffB0E0E6), Colors.white],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : const LinearGradient(
                              colors: [Colors.white, Colors.white],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                      text: fixEncoding(historyProduct[index]),
                      onTextPressed: () async {
                        //Check Product hợp lệ
                        ProductDefaultResponse productDefault = await checkProductExist(fixEncoding(historyProduct[index]));
                        print("${fixEncoding(historyProduct[index])} pressed!");
                        widget.navigateToEditPage(context,productDefault);
                      },
                      onClosePressed: () {
                        setState(() {
                          if (index < historyProduct.length) {
                            historyProduct.removeAt(index);
                          }
                        });
                        // print("${items[index]} closed!");
                      },
                    ),
                    // const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            //Vừa chuyển Button sang manual_input_page
          ],
        ),
      ),
    );
  }
}
