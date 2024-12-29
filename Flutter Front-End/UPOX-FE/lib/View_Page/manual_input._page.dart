import 'dart:developer';

import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/manual_input_component/manual_history_input.dart';
import 'package:first_app/Components/manual_input_component/manual_history_text.dart';
import 'package:first_app/Components/manual_input_component/manual_input_textfield.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/View_Page/dialogue_comboPage/dialogue_addi_page.dart';
import 'package:first_app/View_Page/dialogue_comboPage/dialogue_main_page.dart';
import 'package:first_app/View_Page/edit_page_comboView/edit_main_page.dart';
import 'package:first_app/model/history_product_response.dart';
import 'package:first_app/model/product_default_response.dart';
import 'package:first_app/model/track_user_product.dart';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

class ManualInputPage extends StatelessWidget {
  List<TrackedUserProduct> trackedUserProductList = [];
  
  ManualInputPage(this.trackedUserProductList, {super.key});
  ManualInputPage.initialize({super.key});

  //FetchingHistoryProduct() //FutureBuilder

  FetchingService fetchingService = FetchingService.initialize();
  
  Future<HistoryProductResponse> fetchingHistoryProductList() async{
    log("History Product fetching");
    funcCallBack() {
      return fetchingService.fetchHistoryProductList();
    }
    RequestController requestController = RequestController.withoutParameter(
      funcCallBack
    );
    fetchingService = FetchingService(requestController: requestController);

    HistoryProductResponse res = await requestController.request();
    
    log("Fetching ${res.nameOfProducts.toString()}");

    return res;
  }

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
  
  //Navigate
  Future<void> navigateToEditPage(BuildContext context, ProductDefaultResponse productDefault) async{
    await Navigator.push(
      context,
      PageTransition(
        child: EditMainPage(trackedUserProductList, productDefault),
        type: PageTransitionType.rightToLeft,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      //FutureBuilder
      body: FutureBuilder(
        future: fetchingHistoryProductList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Colors.blue,
                size: 50,
              ),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return SafeArea(
                child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  Back Button
                    const SizedBox(height: 10),
                    const BackButtonComponent(
                      targetPage: DialoguePage(),
                      iconColor: Colors.blue,
                      textColor: Colors.blue,
                      labelText: "Back",
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ManualInputTextfield(searchController: searchController,), //searchController TextEditingController()
                              const SizedBox(height: 20),
                              const ManualHistoryText(),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ManualHistoryInput(
                                    snapshot.data!.nameOfProducts, 
                                    navigateToEditPage
                                  ), //List<HistoryProductResponse>
                                ],
                              ),
                              // Nút xác nhận
                              Container(
                                child: Center(
                                  child: TextButton(
                                    onPressed: () async{
                                      //Check Product hợp lệ
                                      if(searchController.text.isNotEmpty){
                                        ProductDefaultResponse productDefault = await checkProductExist(searchController.text);
                                        log(productDefault.productName.toString()); //Debug
                                        navigateToEditPage(context,productDefault);
                                      }
                                      else{
                                        log("It's empty");
                                      }
                                      
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      minimumSize: const Size(266, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: const Text(
                                      "Thêm sản phẩm!",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            );
          }
          else{
            return const SnackBar(
              content: Text("Took too long to response"),
              backgroundColor: Colors.red,
            );
          }
        },
      ),
    );
  }
}
