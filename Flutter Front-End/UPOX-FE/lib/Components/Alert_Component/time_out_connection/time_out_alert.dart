import 'package:first_app/Components/Alert_Component/log_out_alert/alert_background.dart';
import 'package:flutter/material.dart';

class TimeOutAlert extends StatelessWidget {
  const TimeOutAlert({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Container(
      child: const AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: AlertComponent(
          alertImagePath: 'assets/time_out_banner.png',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Exit button
              // Container(
              //   margin: EdgeInsets.only(left: 245, bottom: 75),
              //   width: 30,
              //   height: 30,
              //   // decoration: const BoxDecoration(color: Color(0xFF000000)),
              //   child: Align(
              //     alignment: Alignment.centerRight,
              //     child: TextButton.icon(
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //       },
              //       style: TextButton.styleFrom(
              //         padding: const EdgeInsets.all(5),
              //         // backgroundColor: Colors.amber,
              //         minimumSize:
              //             Size(screenWidth * 0.01, screenHeight * 0.01),
              //         shape: const CircleBorder(
              //           side: BorderSide(
              //             color: Colors.white,
              //             width: 1,
              //           ),
              //         ),
              //       ),
              //       label: SizedBox(
              //         child: Image.asset(
              //           "assets/exit_button.png",
              //           color: Colors.white,
              //           width: screenWidth * 0.02,
              //           height: screenHeight * 0.02,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
