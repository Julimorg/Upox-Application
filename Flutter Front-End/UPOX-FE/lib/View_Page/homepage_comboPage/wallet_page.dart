import 'dart:developer';

import 'package:first_app/Components/wallet_component/wallet_page_content.dart';
import 'package:first_app/Components/wallet_component/wallet_page_header.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WalletMainPage extends StatefulWidget {
  DateTime selectionDate = DateTime.now();
  WalletMainPage({super.key});
  WalletMainPage.reInitialize(this.selectionDate, {super.key});

  @override
  State<WalletMainPage> createState() => _WalletMainPage();
}



class _WalletMainPage extends State<WalletMainPage> {
  FetchingService fetchingService = FetchingService.initialize();
  late DateTime dateChoose;

  //Fetching
  Future<Expense> fetchingData(String month, String year) async{
    log("Expense fetching");

    funcCallBack() {
      return fetchingService.fetchExpense(month, year);
    }

    RequestController requestController = RequestController.withoutParameter(
      funcCallBack
    );

    fetchingService = FetchingService(requestController: requestController);

    return await requestController.request();
  }

  void reload(DateTime newSelectionDate){
    setState(() {
      dateChoose = newSelectionDate;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateChoose = widget.selectionDate;
    log("Month: ${dateChoose.month.toString()}");
    log("Year: ${dateChoose.year.toString()}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchingData(dateChoose.month.toString(), dateChoose.year.toString()),
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
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const WalletPageHeader(),
                      WalletPageContent(snapshot.data!, dateChoose, reload),
                    ],
                  ),
                ),
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
      ),
    );
  }
}
