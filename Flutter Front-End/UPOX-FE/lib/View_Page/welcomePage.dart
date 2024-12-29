import 'package:first_app/Components/Alert_Component/time_out_connection/time_out_alert.dart';

import 'package:first_app/Components/welcomePage_Component/background.dart';
import 'package:first_app/Components/welcomePage_Component/buttonClick.dart';
import 'package:first_app/Components/welcomePage_Component/contentText.dart';
import 'package:first_app/Components/welcomePage_Component/headerText.dart';
// import 'connectivity_notifier.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Thoát ứng dụng khi bấm nút back
        // Sử dụng SystemNavigator.pop() để thoát ứng dụng
        SystemNavigator.pop();
        return false;
      },
      child: const Scaffold(
        body: SafeArea(
          child: BackgroundComponent(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //Component Header  (UPOX Text)
                HeaderAppText(),
                //Component Content (Content Text)
                const SizedBox(height: 100),
                ContentText(),
                // Component Button on click
                ButtonOnClick(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
