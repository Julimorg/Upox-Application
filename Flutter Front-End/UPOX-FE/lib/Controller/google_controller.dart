import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:first_app/Components/khoa_component/Comp_logic/domain_name.dart';
import 'package:first_app/Components/khoa_component/Comp_logic/google_request.dart';
import 'package:first_app/Controller/token_controller.dart';

import 'package:first_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // required to encode/decode json data
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleController {
  late String userId;
  late String gmail;

  //PHONG THÊM VÀO
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "529038122203-v4cp5kkvhu9tjh5pgmdugvq68vq3c52j.apps.googleusercontent.com",
    scopes: ['email', 'profile', 'openid'],
  );
  TokenController tokenController = TokenController();

//529038122203-v4cp5kkvhu9tjh5pgmdugvq68vq3c52j.apps.googleusercontent.com

//PHONG THÊM VÀO
  Future<void> onGoogleLogin(bool isFirstTime) async {
    try {
      if (kIsWeb || Platform.isAndroid) {
        googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile', 'openid'],
        );
      }

      final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuthentication =
          await googleAccount!.authentication;
      log(googleAccount.email);
      log(googleAccount.displayName.toString());
      // log(googleAccount.id);
      // log(googleAccount.toString());

      log(googleAuthentication.accessToken.toString());
      // log(googleAuthentication.idToken.toString());
      // log(googleAuthentication.toString());

      log("Sign in successful");

      GoogleRequest request = new GoogleRequest();

      await verifyAccessToken(
          googleAuthentication.accessToken.toString(), request);
      await getUserInfo(googleAuthentication.accessToken.toString(), request);

      gmail = googleAccount.email;
      isFirstTime? await createGoogleUser(request) : await loginGoogleUser(request);
      //Save token
      //Gửi token
    } catch (error) {
      log("Sign in failed: $error");
    }
  }

//PHONG THÊM VÀO
  Future<void> verifyAccessToken(
      String accessToken, GoogleRequest request) async {
    final response = await http.get(
      Uri.parse(
          'https://oauth2.googleapis.com/tokeninfo?access_token=$accessToken'),
    );

    if (response.statusCode == 200) {
      final tokenInfo = json.decode(response.body) as Map<String, dynamic>;

      request.setgoogleToken(accessToken);
      request.setemail(tokenInfo["email"]);
      request.setverified(tokenInfo["email_verified"]);

      log('Token info: $tokenInfo');
    } else {
      log('Failed to verify access token');
    }
  }

//PHONG THÊM VÀO
  Future<void> getUserInfo(String accessToken, GoogleRequest request) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/oauth2/v3/userinfo?access_token=$accessToken'),
    );

    if (response.statusCode == 200) {
      final userInfo = json.decode(response.body) as Map<String, dynamic>;
      request.setusername(userInfo["name"]);
      request.setgivenName(userInfo["given_name"]);
      request.setfamilyName(userInfo["family_name"]);
      request.setpicture(userInfo["picture"]);
      request.setlocale(userInfo["locale"]);

      print('User Info: $userInfo');
    } else {
      print('Failed to retrieve user info');
    }
  }

//PHONG THÊM VÀO
  Future<void> createGoogleUser(GoogleRequest request) async {
    final String domainName = DomainName.domainName;
    final dynamic url = Uri.parse("$domainName/api/v1/auth/google-signUp");

    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": request.username,
          "email": request.email,
          "familyName": request.familyName,
          "givenName": request.givenName,
          "picture": request.picture,
          "locale": request.locale,
          "verified": request.verified,
          "googleToken": request.googleToken,
        }));
    if (response.statusCode == 200) {
      //Chuyển hướng sang trang đăng nhập
      var result = jsonDecode(response.body) as Map<String, dynamic>;
      var data = result["result"];

      log(data.toString());
      String userId = data["userResponse"]["id"];
      String userName = data["userResponse"]["username"];
      String token = data["authenticateResponse"]["token"];
      String refreshToken = data["authenticateResponse"]["refreshToken"];

      //Save info
      await tokenController.saveToken(token, refreshToken);
      
      await _saveUserId(userId, userName);
    } else {
      log("Đăng nhập hệ thống thất bại");
      throw Exception("Error 404");
      //Báo lỗi throw error
    }
  }

//PHONG THÊM VÀO
  Future<void> loginGoogleUser(GoogleRequest request) async{
    final String domainName = DomainName.domainName;
    final dynamic url = Uri.parse("$domainName/api/v1/auth/google-login");
    userId = await _getUserId();

    log("UserId:" + userId);

    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "googleToken": request.googleToken
        }));
    if (response.statusCode == 200) {
      //Chuyển hướng sang trang đăng nhập
      var result = jsonDecode(response.body) as Map<String, dynamic>;
      var data = result["result"];
      String token = data["token"];
      String refreshToken = data["refreshToken"];
      await tokenController.saveToken(token, refreshToken);
    }
  }



//PHONG THÊM VÀO
  Future<void> _saveUserId(String userId, String userName) async {
    log("Saving Id...");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('USER_ID', userId);
    prefs.setString('USER_NAME', userName);
  }

  Future<String> _getUserId() async {
    log("Saving Id...");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('USER_ID').toString();
  }
  String getGmail(){
    return this.gmail;
  }

}


