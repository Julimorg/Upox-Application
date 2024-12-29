import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:first_app/Components/khoa_component/Comp_logic/domain_name.dart';
import 'package:first_app/Components/khoa_component/Comp_textfield/box_verify_number.dart';
import 'package:first_app/Components/khoa_component/title_.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class MyVerifyNumContainer extends StatefulWidget {
  final String textOfButton;
  final String title_;
  final String subTitle_;
  final bool isForgetPass_;
  //Test
  final Function callback;

  const MyVerifyNumContainer(
      {super.key,
      required this.textOfButton,
      required this.title_,
      required this.subTitle_,
      required this.isForgetPass_,
      required this.callback});

  @override
  State<MyVerifyNumContainer> createState() => _MyVerifyNumContainerState();
}

class _MyVerifyNumContainerState extends State<MyVerifyNumContainer> {
  Timer? _timer;
  int _remainingSeconds;
  bool _isSentBack = false;
  String? _correctCodeOTP = "";

  _MyVerifyNumContainerState({int startSeconds = 30})
      : _remainingSeconds = startSeconds;

  void _startCountdown() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_remainingSeconds <= 0) {
        setState(() {
          //Gọi xuống BE --> xử lý
          //Xóa mã cũ --> gửi lại mail
          _isSentBack = false;
          _remainingSeconds = 30;
          timer.cancel();
        });
      } else {
        setState(() {
          _isSentBack = true;
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget buttonOrWait() {
    if (!_isSentBack) {
      return TextButton(
          onPressed: _startCountdown,
          style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
              padding: WidgetStatePropertyAll(EdgeInsets.only(top: 0))),
          child: const Text("Gửi lại mã",
              style: TextStyle(
                  color: Color(0xFF363636),
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.normal)));
    } else if (_isSentBack) {
      return RichText(
          text: TextSpan(
              text: "Gửi mã lại sau ",
              style: const TextStyle(
                  color: Color(0xFF363636),
                  fontSize: 15,
                  fontStyle: FontStyle.italic),
              children: <TextSpan>[
            TextSpan(
                text: "(${_remainingSeconds}s)",
                style: const TextStyle(color: Color(0xFF18A0FB)))
          ]));
    }
    return Container();
  }

  //Thêm thời gian 5p
  Future<void> _getOTP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _correctCodeOTP = prefs.getString('OTP') ?? null;
    });
  }

//? Lấy userId từ local storage
  Future<String?> _getUserIdFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('USER_ID');

    // Kiểm tra xem userId có tồn tại không
    if (userId == null) {
      log("UserId is null!"); // Log nếu không có userId
    } else {
      log("UserId retrieved: $userId"); // Log nếu có userId
    }
    return userId;
  }

  //Không cần token
  //PHONG THÊM VÀO
  Future<void> onCheckOTP(String otpCode) async {
    log("Check OTP nè !!! $otpCode");
    await _getOTP();
    if (otpCode == _correctCodeOTP) {
      log("Trùng rồi !!!");
      // ? Lấy userID từ LocalStorage
      String? userId = await _getUserIdFromLocal();
      if (userId == null) {
        log("Error: User ID không tồn tại.");
        return;
      }

      if (!widget.isForgetPass_) {
        final String domainName = DomainName.domainName;
        // String test_id = "48cea211-9e08-47e5-a411-645095c6a1ce";
        var url = "$domainName/api/v1/auth/activate";
        dynamic response;
        final Dio dio = new Dio();
        try {
          response = await dio.post(url,
              data: jsonEncode(
                  <String, dynamic>{"userId": userId, "otpVerified": true}));
          dynamic status = response.data["statusCode"];
          dynamic data = response.data["result"];
          if (status == 200) {
            String token = data["token"];
            String refreshToken = data["refreshToken"];
            await _saveToken(token, refreshToken);
            // await printOutLocalStorage();
            await onVerifyPressTest();
          }
        } catch (excute) {
          log("Error in API call: $excute");
          throw Exception("API Error");
        }
      } else {
        //Gọi chuyển trang
        onForgetPassPressTest();
      }
    } else {
      //Báo Lỗi
      throw Exception("Error 404");
    }
  }

  Future<void> printOutLocalStorage() async {
    dynamic otp;
    dynamic expiredOtp;
    dynamic token;
    dynamic refreshToken;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      otp = prefs.getString('OTP') ?? null;
      expiredOtp = prefs.getString('EXPIRED_OTP') ?? null;
      token = prefs.getString('TOKEN') ?? null;
      refreshToken = prefs.getString('REFRESH_TOKEN') ?? null;
    });
    if (otp != null && expiredOtp != null && token != null) {
      log("OTP: $otp\nEXPIRED OTP: $expiredOtp\nTOKEN: $token\nREFRESH TOKEN: $token");
    } else {
      log("Có dữ liệu chưa được lưu");
    }
  }

  Future<void> onVerifyPressTest() async {
    log("Pressed !!!");
    //Đổi state
    this.widget.callback(2, true);
  }

  Future<void> onForgetPassPressTest() async {
    log("Pressed !!!");
    //Đổi state
    widget.callback(2, true);
  }

  //PHONG THÊM VÀO
  Future<void> _saveToken(String token, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('TOKEN', token);
      prefs.setString("REFRESH_TOKEN", refreshToken);
    });
  }

  final _myControlleSquares = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
      children: [
        // !_isSentBack?const SizedBox(height: 15): Container(margin: const EdgeInsets.only(top: 30),),
        // const SizedBox(height: 15),
        MyTitle(
            title: widget.title_,
            content: widget.subTitle_,
            screenWidth: screenWidth,
            screenHeight: screenHeight),
        const SizedBox(height: 31.5),
        MyBoxVerifyNumber(
          myControlleSquares: _myControlleSquares,
        ),
        const SizedBox(height: 31.5),
        Container(
            //Button
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: SizedBox(
                width: 235,
                child: FilledButton(
                    onPressed: () {
                      //onPress: Gọi hàm (API) check thông tin
                      // !widget.isForgetPass_? onCheckOTP("Bỏ OTP code vào đây") : onForgetPassPressTest();
                      onCheckOTP(_myControlleSquares.text);
                    },
                    autofocus: true,
                    style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 15, horizontal: 70)),
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xFF18A0FB))),
                    child: Text(
                      widget.textOfButton,
                      style: const TextStyle(color: Colors.white),
                    )))),
        !_isSentBack ? const SizedBox(height: 5) : const SizedBox(height: 20),
        buttonOrWait(),
        // widget.isForgetPass_?
        // SizedBox(height: screenHeight/5.95):
        // SizedBox(height: screenHeight/8.8)
      ],
    );
  }
}
