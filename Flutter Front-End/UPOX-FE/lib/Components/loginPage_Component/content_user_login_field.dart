import 'dart:convert'; // Dùng để encode/decode JSON
import 'dart:developer';
import 'package:first_app/Components/Alert_Component/warning_alert/position_error_alert.dart';
import 'package:first_app/Components/khoa_component/Comp_logic/domain_name.dart';
import 'package:first_app/Components/khoa_component/Comp_textfield/box_text_field.dart';
import 'package:first_app/Controller/token_controller.dart';
import 'package:first_app/View_Page/forget_pass_screen.dart';
import 'package:first_app/View_Page/homepage_comboPage/homepage_mainview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import thư viện http
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFieldEvent extends StatefulWidget {
  const LoginFieldEvent({
    super.key,
  });

  @override
  State<LoginFieldEvent> createState() => _LoginFieldEventState();
}

class _LoginFieldEventState extends State<LoginFieldEvent> {
  //? Default Attributes
  // String? _userId = "";
  final userTextController = TextEditingController();
  final passTextController = TextEditingController();
  String _userInvalidText = "";
  String _passInvalidText = "";
  bool isPassValid = true;
  bool isUserValid = true;
  bool isValid_ = true;
  bool _isLoading = false;
  TokenController tokenController = TokenController();

  //? Hàm xác thực các trường đầu vào
  void _validateFields() {
    setState(() {
      if (userTextController.text.isEmpty) {
        _userInvalidText = "*Tên đăng nhập không được bỏ trống!";
        isUserValid = false;
      } else {
        _userInvalidText = "";
        isUserValid = true;
      }

      if (passTextController.text.isEmpty) {
        _passInvalidText = "*Mật khẩu không được bỏ trống!";
        isPassValid = false;
      } 
      // else if (passTextController.text.length < 8) {
      //   _passInvalidText = "*Mật khẩu phải từ 8 - 15 ký tự";
      //   isPassValid = false;
      // } 
      else {
        _passInvalidText = "";
        isPassValid = true;
      }
    });
  }

  // Future<void> _getUserId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _userId = prefs.getString('USER_ID') ?? null;
  //   });
  // }

  void onInValid() {
    setState(() {
      isValid_ = false;
    });
  }

  //? Hàm đăng nhập và gửi yêu cầu đến API
  Future<void> _login() async {
    final username = userTextController.text;
    final password = passTextController.text;
    // Xác thực dữ liệu đầu vào
    _validateFields();
    if (!isUserValid || !isPassValid) {
      setState(() {
        _isLoading = false; // Ẩn loading nếu không hợp lệ
      });
      return;
    }
    setState(() {
      _isLoading = true; // Hiển thị loading khi bắt đầu request
    });
    try {
      // URL của
      String domain = DomainName.domainName;
      // http:192.168.1.3:8080 $domain
      var url = Uri.parse("$domain/api/v1/auth/log-in");

      // Gửi yêu cầu đăng nhập với username và password
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
        final res = data['result'];


        if(res == null){
          final mes = data["message"];
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
        }

        String accessToken = res['token'];
        String refreshToken = res['refreshToken'];

        // Lưu token và username vào SharedPreferences
        await tokenController.saveToken(accessToken, refreshToken);
        // await _saveUsername(username);

        setState(() {
          _isLoading = false;
        });

        // Chuyển hướng sang HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomepageMainview(tokenController.getAccessToken(), tokenController.getRefreshToken())),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        // ShowDialog khi đăng nhập sai
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleAlertDialog(
              title: "Lỗi đăng nhập",
              content:
                  "Bạn hãy kiểm tra lại tên đăng nhập và mật khẩu mà bạn đã nhập !.",
              buttonText: "Đóng",
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            );
          },
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // SHow dialog khi xu ly tac vu khong duoc
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleAlertDialog(
            title: "Lỗi tác vụ",
            content:
                "Ôi không! Có lỗi đã xảy ra trong quá trình xử lý tác vụ.\nBạn hãy thử đăng nhập lại!",
            buttonText: "Đóng",
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
          );
        },
      );
    }
  }

  // //? Hàm lưu token vào SharedPreferences
  // Future<void> _saveToken(String token) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('auth_token', token); // Lưu token vào local storage
  //   print('Token đã được lưu: $token');
  // }
  // //? Hàm lưu username vào SharedPreferences
  // Future<void> _saveUsername(String username) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('username', username);
  //   print('Username đã được lưu: $username');
  // }

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
            if (_isLoading)
              Container(
                height: screenHeight * 0.25,
                child: Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
              )
            else ...[
              //** Tên đăng nhập
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
              const SizedBox(height: 20),
              //** Mật khẩu
              MyBoxTextField(
                title: "Mật khẩu",
                hiddenText: isPassValid ? "Nhập mật khẩu" : _userInvalidText,
                isValid: isPassValid,
                isPassWord: true, // -->  Icon Eye
                editTextController: passTextController,
                width: screenWidth * 1,
                height: screenHeight * 0.07,
                titleMargin: const EdgeInsets.only(left: 0),
                margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
              ),
            ],
            //**  Quên mật khẩu
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const MyForgetPassScreen(),
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 600)));
                  },
                  child: const Text(
                    "Quên mật khẩu?",
                    style: TextStyle(
                      color: Color(0xff828282),
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            // Nút đăng nhập
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () async {
                  await _login();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(266, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  "Đăng nhập",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
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
          ],
        ),
      ),
    );
  }
}
