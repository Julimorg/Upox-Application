import 'dart:developer';
import 'package:first_app/Components/Alert_Component/loading_component/loading.dart';
import 'package:first_app/Components/khoa_component/Comp_logic/domain_name.dart';
import 'package:first_app/Components/khoa_component/Comp_textfield/box_text_field.dart';
import 'package:first_app/Components/khoa_component/title_.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // required to encode/decode json data
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class MyVerifyContainer extends StatefulWidget {
  String googleEmail = "";
  final String textOfButton;
  final String title_;
  final String subTitle_;
  // final bool isSentEmail_;
  final bool isForgetPass_;
  //Test
  final Function callback;

  MyVerifyContainer(
      {super.key,
      required this.textOfButton,
      required this.title_,
      required this.subTitle_,
      // required this.isSentEmail_,
      required this.isForgetPass_,
      required this.callback});

  MyVerifyContainer.googleSignUp(
      this.googleEmail,
      {super.key,
      required this.textOfButton,
      required this.title_,
      required this.subTitle_,
      // required this.isSentEmail_,
      required this.isForgetPass_,
      required this.callback});


  @override
  State<MyVerifyContainer> createState() => _MyVerifyContainerState();
}

class _MyVerifyContainerState extends State<MyVerifyContainer> {
  final mailTextController = TextEditingController();
  String _emailErrorText = "";
  void _validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        _emailErrorText = '*Email không được bỏ trống!';
        mailTextController.text = "";
      });
    } else if (!isEmailValid(value)) {
      setState(() {
        _emailErrorText = '*Email không hợp lệ';
        mailTextController.text = "";
      });
    } else {
      setState(() {
        _emailErrorText = "";
      });
    }
  }

  bool isEmailValid(String email) {
    // Basic email validation using regex
    // You can implement more complex validation if needed
    return RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  Future<void> onVerifyPressTest() async {
    log("Pressed Verify !!!");
    //Đổi state
    widget.callback(1, true);
  }

  Future<void> onForgetPassPressTest() async {
    log("Pressed Forget !!!");
    //Đổi state
    widget.callback(1, true);
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

  bool isValid_ = true;
  void onInValid() {
    setState(() {
      isValid_ = false;
    });
  }

  //PHONG THÊM VÀO
  //Nếu mà nó forget, thì sẽ là get
  //Nếu mà nó activate, thì sẽ là put
  //Không cần token
  Future<void> onSentEmail() async {
    try {
      // Hiển thị Loading Screen
      showDialog(
        context: context,
        barrierDismissible: false, // Không cho phép đóng khi bấm ngoài dialog
        builder: (BuildContext context) {
          return const LoadingProgress();
        },
      );
      final String domainName = DomainName.domainName;
      String? userId = await _getUserIdFromLocal();

      if (userId == null) {
        throw Exception("Không tìm thấy userId. Hãy đăng ký lại!");
      }

      String userEmail = mailTextController.text;

      final Dio dio = Dio();
      late Response response;

      if (!widget.isForgetPass_ && widget.googleEmail.isEmpty) {
        // API xác minh tài khoản
        String verifyUrl = "$domainName/api/v1/auth/$userId";
        response = await dio.put(verifyUrl,
            data: jsonEncode(<String, String>{
              "email": userEmail,
            }));
      } 
      else {
        // API quên mật khẩu
        String forgetPassUrl = "$domainName/api/v1/auth/send-mail/$userEmail";
        response = await dio.get(forgetPassUrl);
      }

      if (response.statusCode == 200) {
        dynamic data = response.data["result"];
        String otpCode = data["otp"];
        String expiredOtp = data["expiredOtp"];
        await _saveOTPLocal(otpCode, expiredOtp);
        // Đóng Loading Screen
        Navigator.of(context).pop();
        // Hiển thị dialog thông báo
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Thành công"),
              content: const Text("Vui lòng kiểm tra email để nhận OTP!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                  child: const Text("Đóng"),
                ),
              ],
            );
          },
        );

        // Gọi callback chuyển trang sau khi gửi OTP thành công
        widget.callback(1, true);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error!"),
              content: const Text("Đã xảy ra lỗi vui lòng thử lại"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                  child: const Text("Đóng"),
                ),
              ],
            );
          },
        );
        throw Exception(response.data["message"] ?? "Đã xảy ra lỗi!");
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error!"),
            content: const Text("Đã xảy ra lỗi vui lòng thử lại"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
                },
                child: const Text("Đóng"),
              ),
            ],
          );
        },
      );
      log("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${e.toString()}")),
      );
    }
  }

  Future<void> _saveOTPLocal(String otpCode, String expiredOtp) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('OTP', otpCode);
      prefs.setString('EXPIRED_OTP', expiredOtp);
    });
  }

  @override
  void initState() {
    try{
      // TODO: implement initState
      if(widget.googleEmail.isNotEmpty){
        String email = widget.googleEmail;
        log(email);
        mailTextController.text = email;
        // await onSentEmail();
      }
      super.initState();
    }catch(e){
      log(e.toString());
    }
    
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
      children: [
        MyTitle(
            title: widget.title_,
            content: widget.subTitle_,
            screenWidth: screenWidth,
            screenHeight: screenHeight),
        const SizedBox(height: 20),
        MyBoxTextField(
            title: "Email",
            hiddenText: isValid_ ? "Vd: user12345@gmail.com" : _emailErrorText,
            isValid: isValid_,
            isPassWord: false,
            editTextController: mailTextController),
        const SizedBox(height: 20),
        Container(
            //Button
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: SizedBox(
                width: 235,
                child: FilledButton(
                    onPressed: () {
                      //Trigger
                      _validateEmail(mailTextController.text);
                      String? message = _emailErrorText;
                      if (message == "") {
                        // !widget.isForgetPass_? onVerifyPressTest() : onForgetPassPressTest();
                        onSentEmail();
                      } else {
                        onInValid();
                      }
                      // !widget.isForgetPass_? onVerifyPressTest() : onForgetPassPressTest();
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
      ],
    );
  }
}
