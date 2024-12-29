import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseController{
  Future<void> getPermissionPushNotification() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}');
  }


  Future<void> getFirebaseToken() async{
    String? token = await FirebaseMessaging.instance.getToken();
    log("Firebase token ${token.toString()}");
  }

  //Định kỳ 1 tháng chạy 1 lần 
  //Nếu token không hợp lệ cũng trả về đây
  Future<void> updateFirebaseToken() async{
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {  
      print("FCM Token đã được cập nhật: $newToken");  
      // Cập nhật token mới lên server  


    }); 
  }


  
}