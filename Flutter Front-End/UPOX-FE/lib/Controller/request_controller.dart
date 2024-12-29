import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:first_app/Components/api_internet_component/domain_name.dart';

import 'package:shared_preferences/shared_preferences.dart';

//PHONG THÊM VÀO
class RequestController<T> {
  String _refreshToken = "";
  String _accessToken = "";
  late Future<T> Function() callback;
  dynamic parameter;

  RequestController(this.parameter, this.callback);
  RequestController.withoutParameter(this.callback);
  RequestController.initialize();

  Future<T> request() async {
    try {
      return callback();
    } catch (e) {
      log(e.toString());
      if (e.toString().contains("401")) {
        await sendRequestRefreshToken();
      } else {
        throw Exception("Error");
      }
    }
    throw Exception("Error");
  }

  Future<T> sendRequestRefreshToken() async {
    String domain = DomainName.domainName;
    var url = "$domain/api/v1/auth/refresh-token";
    final Dio dio = new Dio();
    dynamic response;
    await getToken();
    try {
      response = await dio.post(url,
          data: jsonEncode(<String, dynamic>{
            "refreshToken": _refreshToken,
            "accessToken": _accessToken
          }));

      dynamic status = response.data["statusCode"];
      log(response.data["result"].runtimeType.toString());
      Map<String, dynamic> res =
          response.data["result"] as Map<String, dynamic>;

      if (status == 200) {
        log("TOKEN: ${res["token"]}");
        log("REFRESH_TOKEN: ${res["refreshToken"]}}");

        await saveToken(res["token"], res["refreshToken"]);
        return await callback(); //Gọi lại request
      }
    } catch (excute) {
      throw Exception("Error");
    }
    throw Exception("Error");
  }

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('TOKEN') ?? "";
    _refreshToken = prefs.getString('REFRESH_TOKEN') ?? "";
  }

  Future<void> saveToken(String token, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    log("TOKEN: $token");
    log("REFRESH_TOKEN: $refreshToken");

    prefs.setString('TOKEN', token);
    prefs.setString("REFRESH_TOKEN", refreshToken);
    _accessToken = token;
    _refreshToken = refreshToken;
  }

  void setCallBack(Future<T> Function() callback_) {
    this.callback = callback_;
  }
}
