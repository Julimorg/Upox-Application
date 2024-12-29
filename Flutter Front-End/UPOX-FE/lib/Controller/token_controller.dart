import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

//PHONG THÊM VÀO
class TokenController {
  String? _accessToken;
  String? _refreshToken;

  Future<void> findToken() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('TOKEN');
    _refreshToken = prefs.getString('REFRESH_TOKEN');
    log(_accessToken.toString());
  }

  Future<void> saveToken(String token, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('TOKEN', token);
    prefs.setString("REFRESH_TOKEN", refreshToken);
    _accessToken = token;
    _refreshToken = refreshToken;
  }

  String? getAccessToken() {
    return _accessToken;
  }

  String? getRefreshToken() {
    return _refreshToken;
  }

  Map<String, String> requestHeader(String accessToken){
    final Map<String, String> header = {  
      'Content-Type': 'application/json',  
      'Accept': 'application/json',  
      'Authorization': "Bearer $accessToken.toString()",  
    };  
    return header;
  }
}
