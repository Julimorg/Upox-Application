import 'dart:developer';

import 'package:first_app/Components/Alert_Component/warning_alert/position_error_alert.dart';
import 'package:first_app/Components/khoa_component/Comp_logic/domain_name.dart';

import 'package:first_app/Components/khoa_component/Comp_textfield/box_text_field.dart';

import 'package:first_app/View_Page/homepage_comboPage/homepage_mainview.dart';
import 'package:first_app/View_Page/verify_screen.dart';
import 'package:first_app/View_Page/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpFieldEvent extends StatefulWidget {
  const SignUpFieldEvent({super.key});

  @override
  State<SignUpFieldEvent> createState() => _SignUpFieldEvent();
}

class _SignUpFieldEvent extends State<SignUpFieldEvent> {
  //? Default Attributes
  String? _userId = "";
  final userTextController = TextEditingController();
  final passTextController = TextEditingController();
  final confirmPassTextController = TextEditingController();

  String _userInvalidText = "";
  String _passInvalidText = "";
  String _confirmpassInvalidText = "";

  bool isPassValid = true;
  bool isUserValid = true;
  bool isConfirmValid = true;
  bool isValid_ = true;
  // String? _loginError;

  //? Hàm xác thực các trường đầu vào
  void _validateFields() {
    setState(() {
      // Checking user
      if (userTextController.text.isEmpty) {
        _userInvalidText = "*Tên đăng nhập không được bỏ trống!";
        isUserValid = false;
      } else {
        _userInvalidText = "";
        isUserValid = true;
      }
      // Checking Pass
      if (passTextController.text.isEmpty) {
        _passInvalidText = "*Mật khẩu không được bỏ trống!";
        isPassValid = false;
      } else if (passTextController.text.length < 8) {
        _passInvalidText = "*Mật khẩu phải từ 8 - 15 ký tự";
        isPassValid = false;
      } else {
        _passInvalidText = "";
        isPassValid = true;
      }
      //Checking Confirm Pass
      if (confirmPassTextController.text.isEmpty) {
        _confirmpassInvalidText = "*Mật khẩu không được bỏ trống!";
        isConfirmValid = false;
      } else if (confirmPassTextController.text.length < 8) {
        _confirmpassInvalidText = "*Mật khẩu phải từ 8 - 15 ký tự";
        isConfirmValid = false;
      } else {
        _confirmpassInvalidText = "";
        isConfirmValid = true;
      }
    });
  }

  void onInValid() {
    setState(() {
      isValid_ = false;
    });
  }

// ** ==> Function request API to Spring Boot
// Hàm gửi yêu cầu đăng ký
  Future<void> _register() async {
    final username = userTextController.text;
    final password = passTextController.text;
    final confirmpassword = confirmPassTextController.text;

    if (username.isEmpty || password.isEmpty || confirmpassword.isEmpty) {
      _validateFields(); // Kiểm tra nếu trường nào bỏ trống
      return;
    }

    // Kiểm tra nếu mật khẩu và xác nhận mật khẩu không trùng nhau
    if (password != confirmpassword) {
      setState(() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleAlertDialog(
              title: "Lỗi Đăng kí",
              content:
                  "Bạn hãy vui lòng kiểm tra lại quá trình đăng ký như sau!\n 1) Tên đăng nhập không được bỏ trống \n 2) Mật Khẩu và xác nhận mật khẩu phải giống nhau \n 3) Mật khẩu phải từ 8 - 15 ký tự",
              buttonText: "Đóng",
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      });
      return;
    }
    try {
      // URL của API đăng ký
      String domain = DomainName.domainName;
// http://192.168.1.14:8080
      final url = Uri.parse("$domain/users");
// $domain/api/v1/auth/log-in
// $domain/users"
      // Tạo request với username và password
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      // Kiểm tra phản hồi từ server
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Kiểm tra nếu có userID
        final userId = data['result']['id'] as String;
        final username = data['result']['username'] as String;
        print("userId nhận được từ API: $username");
        await _saveUserID(userId,username);
        setState(() {});

        // Điều hướng đến màn hình chính hoặc thông báo đăng ký thành công
        // Chuyển hướng đến HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyVerifyScreen(false)),
        );
      } else {
        // Đăng ký thất bại, xử lý lỗi
        setState(() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleAlertDialog(
                title: "Lỗi Đăng kí",
                content:
                    "Bạn hãy vui lòng kiểm tra lại quá trình đăng ký như sau!\n 1) Tên đăng nhập không được bỏ trống \n 2) Mật Khẩu và xác nhận mật khẩu phải giống nhau \n 3) Mật khẩu phải từ 8 - 15 ký tự",
                buttonText: "Đóng",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        });
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      print("Có lỗi xảy ra: $error");
      setState(() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleAlertDialog(
              title: "Lỗi tác vụ",
              content: "Lỗi tác vụ. Bạn vui lòng đăng kí lại!",
              buttonText: "Đóng",
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      });
    }
  }

  Future<void> _saveUserID(String userId, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('USER_ID', userId); // Lưu userId vào local storage
     await prefs.setString('USER_NAME', username); // Lưu userId vào local storage
    String? savedUserId = prefs.getString('USER_ID');
    if (savedUserId == null) {
      log("User ID chưa được lưu.");
    } else {
      log('User ID đã được lưu: $savedUserId');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: 342,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên đăng nhập
            Container(
              child: MyBoxTextField(
                title: "Tên đăng nhập",
                hiddenText: isUserValid ? "vd: user12345" : _userInvalidText,
                isValid: isUserValid,
                isPassWord: false,
                editTextController: userTextController,
                width: screenWidth * 1,
                height: screenHeight * 0.07,
                titleMargin: const EdgeInsets.only(left: 0),
                margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
              ),
            ),
            const SizedBox(height: 5),
            // User Password input
            Container(
              child: MyBoxTextField(
                title: " Nhập Mật Khẩu",
                hiddenText: isPassValid ? "Nhập Mật Khẩu" : _passInvalidText,
                isValid: isPassValid,
                isPassWord: true,
                editTextController: passTextController,
                width: screenWidth * 1,
                height: screenHeight * 0.07,
                titleMargin: const EdgeInsets.only(left: 0),
                margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
              ),
            ),
            const SizedBox(height: 10),
            // Verify Password input
            Container(
              child: MyBoxTextField(
                title: "Nhập lại Mật Khẩu",
                hiddenText: isConfirmValid
                    ? "Nhập lại Mật Khẩu"
                    : _confirmpassInvalidText,
                isValid: isConfirmValid,
                isPassWord: true,
                editTextController: confirmPassTextController,
                width: screenWidth * 1,
                height: screenHeight * 0.07,
                titleMargin: const EdgeInsets.only(left: 0),
                margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
              ),
            ),

            const SizedBox(height: 20),
            // Đăng Ký button
            Center(
              child: TextButton(
                  onPressed: _register, // Gọi hàm validate khi bấm
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(266, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text("Đăng Ký!",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ))),
            ),
            const SizedBox(height: 20),
            // Span Footer
            Center(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Container(
                    width: 140,
                    height: 2,
                    color: const Color(0xffE3E3E3),
                  ),
                  const SizedBox(width: 10),
                  const Text("Hoặc",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "inter",
                          letterSpacing: 0.5,
                          color: Color(0xffE3E3E3))),
                  const SizedBox(width: 10),
                  Container(
                    width: 140,
                    height: 2,
                    color: const Color(0xffE3E3E3),
                  ),
                ])),
            // Handle Error Event
          ],
        ),
      ),
    );
  }
}
