import 'package:first_app/Components/Alert_Component/log_out_alert/alert_background.dart';
import 'package:first_app/View_Page/loginPage.dart';
import 'package:first_app/View_Page/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // để parse JSON

class AlertContainer extends StatelessWidget {
  const AlertContainer({super.key});
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Xóa token và các thông tin đăng nhập đã lưu
    await prefs.remove('TOKEN');
    await prefs.remove('REFRESH_TOKEN');
    // await prefs.remove('username');

    //Gọi logout

    


    // Chuyển sang WelcomePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Container(
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: AlertComponent(
          alertImagePath: 'assets/log_out_banner_alert.png',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
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

              // Log out button
              Container(
                width: 68,
                height: 30,
                margin: EdgeInsets.only(left: 213, bottom: 10),
                // decoration: const BoxDecoration(color: Color(0xFF000000)),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.02),
                    child: SizedBox(
                      width: screenWidth * 0.16,
                      height: screenHeight * 0.030,
                      child: OutlinedButton(
                        onPressed: () => logout(context),
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            minimumSize:
                                Size(screenWidth * 0.01, screenWidth * 0.01),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            )),
                        child: const Text(
                          "Đăng xuất",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
