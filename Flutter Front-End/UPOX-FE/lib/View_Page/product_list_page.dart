import 'dart:developer';

import 'package:first_app/Components/Alert_Component/log_out_alert/alert_background.dart';
import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/CommonComponent/confirm_save_finish_button.dart';
import 'package:first_app/Components/product_list_component/product_add_list_button.dart';
import 'package:first_app/Components/product_list_component/product_list_items.dart';
import 'package:first_app/Components/profile_component/profile_background.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Controller/token_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/View_Page/homepage_comboPage/homepage_mainview.dart';
import 'package:first_app/View_Page/manual_input._page.dart';
import 'package:first_app/model/track_user_product.dart';
import 'package:first_app/model/track_user_product_response.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ProductListPage extends StatelessWidget {
  List<TrackedUserProduct> trackedUserProductList = [];
  
  ProductListPage(this.trackedUserProductList, {super.key});
  ProductListPage.initialize({super.key});

  //Fetching Service
  FetchingService fetchingService = FetchingService.initialize();
  
  //Check User Product
  Future<dynamic> saveTrackedUserProduct(List<TrackedUserProduct> list) async{
    log("Adding product");
    funcCallBack() {
      return fetchingService.addProduct(list);
    }
    RequestController requestController = RequestController.withoutParameter(
      funcCallBack
    );
    fetchingService = FetchingService(requestController: requestController);
    return await requestController.request();
  }

  void _showFinishDialog(BuildContext context, double screenHeight, double screenWidth) {
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
                ],
              ),
            ),
          );
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    log("count: ${trackedUserProductList.length}");
    TokenController tokenController = TokenController();
    tokenController.findToken();
     double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: SafeArea(
          child: ProfileBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Back Button
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonComponent(
                  targetPage: ManualInputPage(trackedUserProductList),
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  labelText: "Back",
                ),
                ConfirmSaveFinishButton(
                  buttonText: "Save",
                  textColor: Colors.white,
                  onPressed: () async {
                    //Calling saveProduct()
                    List<TrackedUserProductResponse> listResponse = await saveTrackedUserProduct(trackedUserProductList);
                    
                    log("Adding product successfully with List (${listResponse.length} products)");
                    _showFinishDialog(context, height, width);
                    await Navigator.push(
                      context,
                      PageTransition(
                          child: HomepageMainview(tokenController.getAccessToken(), tokenController.getRefreshToken()),
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 400)
                      )
                    );
                  },
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.055,
                  ),
                  // height: height * 0.75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ManualHistoryText(),
                      ProductListComponent(trackedUserProductList),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              //Truyền list tracked user product vào
              child: ProductAddListButton(trackedUserProductList),
            ),
            const SizedBox(height: 10),
          ],
        ),
      )),
    );
  }
}
