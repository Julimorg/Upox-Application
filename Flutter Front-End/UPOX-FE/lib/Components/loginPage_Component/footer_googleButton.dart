import 'dart:developer';

import 'package:first_app/Components/Alert_Component/loading_component/loading.dart';
import 'package:first_app/Controller/google_controller.dart';
import 'package:first_app/Controller/token_controller.dart';
import 'package:first_app/View_Page/homepage_comboPage/homepage_mainview.dart';
import 'package:first_app/View_Page/verify_screen.dart';
import 'package:flutter/material.dart';

class GoogleSignUpButton extends StatelessWidget {
  final bool isFirstTime;

  const GoogleSignUpButton(this.isFirstTime,{super.key});

  void navigateTo(BuildContext context, TokenController tokenController, String gmail){
    if(isFirstTime){
      log("Đăng ký google thành công !!!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyVerifyScreen.googleSignUp(true, gmail)),
      );
    }
    else{
      log("Đăng nhập google thành công !!!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  HomepageMainview(tokenController.getAccessToken(), tokenController.getRefreshToken())),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    GoogleController googleController = GoogleController();
    TokenController tokenController = TokenController();

    return Container(
      // width: width * 0.4,
      // color: Colors.amber,
      margin: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        onPressed: () async {
          //Loading Screen
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const LoadingProgress();
            },
          );

          try {
            await googleController.onGoogleLogin(isFirstTime);
            // await tokenController.findToken();
            // Tắt Loading Screen
            Navigator.of(context).pop();

            navigateTo(context,tokenController, googleController.getGmail());
            
          } catch (error) {
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Đăng nhập Google thất bại: $error"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          elevation: 0,
          side: const BorderSide(width: 0, color: Color(0xffd6d6d6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/google_icon.png', // Đường dẫn tới ảnh
              width: 24, // Kích thước ảnh
              height: 24,
            ),
            const SizedBox(width: 10), // Khoảng cách giữa ảnh và text
            const Text(
              'Google Account',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
