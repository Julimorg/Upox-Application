import 'package:first_app/Components/Alert_Component/log_out_alert/alert_background.dart';
import 'package:flutter/material.dart';

class AlerComponent extends StatelessWidget {
  final String? imagePath;

  const AlerComponent(this.imagePath,{super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
        // width: screenWidth * 0.07,
        // height: screenHeight * 0.13,
        // color: Colors.blueGrey,
        child: AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: AlertComponent(
            alertImagePath: imagePath!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              // Exit button
              Container(
                  // color: Colors.amber,
                  margin: EdgeInsets.only(left: 250, bottom: 50),
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
              ],
            ),
          ),
        ));
  }
}
