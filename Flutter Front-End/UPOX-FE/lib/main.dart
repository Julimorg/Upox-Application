import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/Components/api_internet_component/dependency_injection.dart';
import 'package:first_app/Controller/firebase_controller.dart';
import 'package:first_app/Service/notification_service.dart';
import 'package:first_app/View_Page/homepage_comboPage/homepage_mainview.dart';
import 'package:first_app/View_Page/welcomePage.dart';
import 'package:first_app/model/token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey: "AIzaSyCUKM4CPC6TzX1WY4TFMBdiN7B22tZ2Ih0", 
      authDomain: "upox-5a6c9.firebaseapp.com",
      appId: "1:181011005119:web:e9aa53f73465a58352100a", 
      messagingSenderId: "181011005119", 
      projectId: "upox-5a6c9",
      storageBucket: "upox-5a6c9.firebasestorage.app",
      measurementId: "G-J21V4HXJNE")
    );
  }else{
    await Firebase.initializeApp();
    NotificationService notificationService = NotificationService();
    await notificationService.init();
    FirebaseController firebaseController = FirebaseController();
    await firebaseController.getPermissionPushNotification();
    await firebaseController.getFirebaseToken();
  }

  runApp(const MyApp());
  // ? Check WIFI connection
  DependencyInjection.init();
  // ? Set lock screen
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // removeExistedToken();
    
      return const GetMaterialApp(
      home: InitialScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Lớp khởi tạo để kiểm tra trạng thái token
class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  Future<Token> _checkToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString("TOKEN", "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI5MDYwIC0gTmd1eeG7hW4gQsO5aSBBbmggS2hvYSIsInNjb3BlIjoiVVNFUiIsImlzcyI6IlVQT1guY29tIiwiZXhwIjoxNzM0MTk3ODA4LCJpYXQiOjE3MzQxOTQyMDgsInVzZXJJZCI6IjZlYzg0ODlmLTI3ZGEtNGMzNi1iMjY0LTMxMDZjNmJhNjBjMyIsImp0aSI6IjkzZTcwNTg0LWY3MWYtNDA3NC04YzVjLWVlNmEwY2IxN2U4ZSJ9.Fs_B76ZqzGSrHYOk7bUQLLB-Se2YN_xTwAymPtqlF_E1Ki_mtl_f7O4oOrwvl3PuJrr6sZKwgP2M7TGpnArCDA");
    // await prefs.setString("REFRESH_TOKEN", "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI5MDYwIC0gTmd1eeG7hW4gQsO5aSBBbmggS2hvYSIsInNjb3BlIjoiVVNFUiIsImlzcyI6IlVQT1guY29tIiwiZXhwIjoxNzY1NzMwMjA5LCJpYXQiOjE3MzQxOTQyMDksInVzZXJJZCI6IjZlYzg0ODlmLTI3ZGEtNGMzNi1iMjY0LTMxMDZjNmJhNjBjMyIsImp0aSI6ImFhNzJlNGJjLTEwZjItNDI0NC04MTY2LTZlYjhhN2EyZjVlNSJ9.p-E-bppHk_8-qwjY12272Hw4_tPWUWOus5ID_29X3idbT_OC8Mk3iQWO4BYnHP4-AjfziEyaBjfUvw2at3pLiw");

    // await prefs.clear();
    String? accessToken =  prefs.getString('TOKEN'); // Lấy token từ local storage
    String? refreshToken = prefs.getString('REFRESH_TOKEN');
    String? userID = prefs.getString('USER_ID');
    String? username = prefs.getString('USER_NAME');

    log("$accessToken\n$refreshToken\n$userID\n$username");
    return Token(accessToken, refreshToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Token>(
        future: _checkToken(), // Gọi hàm kiểm tra token
        builder: (BuildContext context, AsyncSnapshot<Token?> snapshot) {
          // Khi đang kiểm tra token, hiển thị loading animation
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Colors.blue,
                size: 50,
              ),
            );
          }

          // Nếu có token, chuyển tới HomepageMainview
          if (snapshot.hasData && snapshot.data!.accessToken != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomepageMainview(snapshot.data?.accessToken, snapshot.data?.refreshToken)),
                (route) => false, // Xóa toàn bộ lịch sử stack
              );
            });
          } 
          else {
            // Nếu không có token, chuyển tới WelcomePage
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (route) => false, // Xóa toàn bộ lịch sử stack
              );
            });
          }

          // Trường hợp lỗi hoặc không có dữ liệu
          return const SizedBox
              .shrink(); // Không hiển thị gì nếu không có dữ liệu
        },
      ),
    );
  }
}
