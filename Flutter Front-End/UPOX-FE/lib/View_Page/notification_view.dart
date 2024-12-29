import 'dart:developer';

import 'package:first_app/Components/CommonComponent/back_button_component.dart';
import 'package:first_app/Components/notification_component/noti_content.dart';
import 'package:first_app/Components/notification_component/noti_text_banner.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/View_Page/homepage_comboPage/homepage_content.dart';
import 'package:first_app/View_Page/homepage_comboPage/homepage_mainview.dart';
import 'package:first_app/model/notification.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}






class _NotificationViewState extends State<NotificationView> {

  FetchingService fetchingService = FetchingService.initialize();


  //Fetching notifications 
  Future<List<NotificationResponse>> fetchingData () async{
    log("Notification fetching");

    funcCallBack() {
      return fetchingService.fetchNotification();
    }

    RequestController requestController = RequestController.withoutParameter(
      funcCallBack
    );

    fetchingService = FetchingService(requestController: requestController);

    return await requestController.request();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: fetchingData(),
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
              	return SafeArea(
                  child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  const SizedBox(height: 10),
                  //  Back Button
                  Container(
                    child: const BackButtonComponent(
                      targetPage: HomepageContent(),
                      iconColor: Colors.blue,
                      textColor: Colors.blue,
                      labelText: "Back",
                    ),
                  ),
                  // Text Banner Noti
                  const SizedBox(height: 15),
                  Container(
                    margin:
                        EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                    child: const NotiTextBanner(),
                  ),
                  const SizedBox(height: 15),
                  
                      // Noti Content
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.03),
                            child: NotificationContent(snapshot.data!), //Truyền vào đây
                          ),
                        ),
                      )
                    ],
                  )
                );
            }
            //Failed case
            else{
              return const SnackBar(
                content: Text("Took too long to response"),
                backgroundColor: Colors.red,
              );
            }
          },
      )
    );
  }
}
