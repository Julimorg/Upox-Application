import 'dart:convert';
import 'dart:developer';

import 'package:first_app/Components/homepage_component/content_component.dart';
import 'package:first_app/Components/homepage_component/header_component.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/model/homepage_information.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomepageContent extends StatefulWidget {
  const HomepageContent({super.key});

  @override
  State<HomepageContent> createState() => _HomepageContentState();
}


class _HomepageContentState extends State<HomepageContent> {

  FetchingService fetchingService = FetchingService.initialize();
  HomePageInformation homePageInformation = HomePageInformation.initialize();

  
  Future<HomePageInformation> fetchingData() async{
    log("HomePage fetching");

    funcCallBack() {
      return fetchingService.fetchHomeScreenData();
    }

    RequestController requestController = RequestController.withoutParameter(
      funcCallBack
    );

    fetchingService = FetchingService(requestController: requestController);

    return await requestController.request();
  }

  // @override
  // void initState() {

  //   log("Home page fetching");

  //   funcCallBack() async {
  //     return homePageInformation = await fetchingService.fetchHomeScreenData();
  //   }
  //   RequestController requestController = RequestController.withoutParameter(
  //     funcCallBack
  //   );

  //   try{
  //     requestController.request();
  //   }catch(e){
  //     log(e.toString());
  //   }

  //   // TODO: implement initState
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Thoát ứng dụng khi bấm nút back
        // Sử dụng SystemNavigator.pop() để thoát ứng dụng
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: FutureBuilder(
          future: fetchingData(),
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
                  children: [
                    // Header
                    HeaderHomePage(snapshot.data!.notifications),
                    // Nội dung cuộn
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              child: Center(child: ContentHomePage(snapshot.data!.warningCategories)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
            } 
            else{
              return const SnackBar(
                content: Text("Took too long to response"),
                backgroundColor: Colors.red,
              );
            }
          },
        ),
      ),
    );
  }
}

