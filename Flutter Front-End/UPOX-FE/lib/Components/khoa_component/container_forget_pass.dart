import 'dart:developer';
import 'package:first_app/Components/khoa_component/Comp_logic/domain_name.dart';
import 'package:first_app/Components/khoa_component/Comp_textfield/box_text_field.dart';
import 'package:first_app/Components/khoa_component/title_.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // required to encode/decode json data
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyForgetPassContainer extends StatefulWidget {
  final String textOfButton;
  final String title_;
  final String subTitle_;
  //Test
  final Function callback;

  const MyForgetPassContainer(
      {super.key,
      required this.textOfButton,
      required this.title_,
      required this.subTitle_,
      required this.callback});

  @override
  State<MyForgetPassContainer> createState() => _MyForgetPassContainerState();
}

class _MyForgetPassContainerState extends State<MyForgetPassContainer> {
  String? _userId = "";
  final passTextController = TextEditingController();
  final rePassTextController = TextEditingController();
  String _passInvalidText = "";
  String _rePassInvalidText = "";

  void _validatePassword(String password, String rePassword) {
    //   r'^
    // (?=.*[A-Z])       // should contain at least one upper case
    // (?=.*[a-z])       // should contain at least one lower case
    // (?=.*?[0-9])      // should contain at least one digit
    // (?=.*?[!@#\$&*~]) // should contain at least one Special character
    // .{8,15}             // Must be at least 8 characters in length
    //    $

    //Nếu muốn yêu cầu pass phức tạp hơn: [!@#\$&*~`)\%\-(_+=;:,.<>/?"'[{\]}\|^]

    RegExp regex = RegExp(r'^(?=.*?[a-z]).{8,15}$');
    if (password.isEmpty) {
      log("pass empty");
      _passInvalidText = '*Thông tin không được bỏ trống!';
      isPassValid = false;
      passTextController.text = "";
    } else {
      if (password.length < 8) {
        _passInvalidText = '*Mật khẩu phải từ 8 - 15 ký tự';
        isPassValid = false;
        passTextController.text = "";
      } else if (!password.contains(RegExp(r'[A-Z]'))) {
        _passInvalidText = '*Mật khẩu phải chứa ký tự in hoa';
        isPassValid = false;
        passTextController.text = "";
      }
      // if (!regex.hasMatch(password)) {
      //   _passInvalidText = '*Mật khẩu không đạt';
      //   isPassValid = false;
      //   passTextController.text = "";
      // }
    }
    if (rePassword.isEmpty) {
      log("repass empty");
      _rePassInvalidText = '*Thông tin không được bỏ trống!';
      isPassValid = false;
      rePassTextController.text = "";
    } else {
      if (rePassword != password) {
        _rePassInvalidText = '*Mật khẩu nhập lại chưa trùng khớp';
        isRePassValid = false;
        rePassTextController.text = "";
      }
    }
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

  //PHONG THÊM VÀO
  Future<void> onUpdated() async {
    //Bắt event button "cập nhật"
    await _getUserId();
    final String domainName = DomainName.domainName;
    // ? Lấy userID từ LocalStorage
    String? userId = await _getUserIdFromLocal();
    // String test_id = "48cea211-9e08-47e5-a411-645095c6a1ce"; //_userId
    final dynamic url = Uri.parse("$domainName/users/forget-password/$userId");
    final response = await http.put(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "password": passTextController.text,
        }));
    if (response.statusCode == 200) {
      //Chuyển hướng sang trang đăng nhập
      onForgetPassPressTest();
    } else {
      throw Exception("Error 404");
      //Báo lỗi throw error
    }
  }

  void onForgetPassPressTest() {
    log("Pressed Forget Pass!!!");
    //Đổi state
    widget.callback(3, true);
  }

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('USER_ID') ?? null;
    });
  }

  bool isPassValid = true;
  bool isRePassValid = true;
  bool isValid_ = true;
  void onInValid() {
    setState(() {
      isValid_ = false;
    });
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
          title: "Mật khẩu mới",
          hiddenText: isValid_ ? "Nhập mật khẩu mới" : _passInvalidText,
          isValid: isValid_,
          isPassWord: true,
          editTextController: passTextController,
        ),
        const SizedBox(height: 20),
        MyBoxTextField(
          title: "Xác nhận mật khẩu",
          hiddenText: isValid_ ? "Nhập lại mật khẩu" : _rePassInvalidText,
          isValid: isValid_,
          isPassWord: true,
          editTextController: rePassTextController,
        ),
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
                      _validatePassword(
                          passTextController.text, rePassTextController.text);
                      if (isPassValid == false || isRePassValid == false) {
                        onInValid();
                      } else {
                        onUpdated();
                      }
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
        // SizedBox(height: screenHeight/12)
      ],
    );
  }
}
