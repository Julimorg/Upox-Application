import 'dart:developer';

import 'package:first_app/Components/khoa_component/check_complete_page.dart';
import 'package:first_app/Components/khoa_component/container_forget_pass.dart';
import 'package:first_app/Components/khoa_component/container_verify.dart';
import 'package:first_app/Components/khoa_component/container_verify_num.dart';
import 'package:first_app/Components/khoa_component/logo_.dart';
import 'package:first_app/View_Page/loginPage.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class MyForgetPassScreen extends StatefulWidget {
  const MyForgetPassScreen({super.key});

  @override
  State<MyForgetPassScreen> createState() => _MyForgetPassState();
}

class _MyForgetPassState extends State<MyForgetPassScreen> {
  late List<Widget> _pages = [];
  int _activePage = 0; //First slide
  CheckCompletePage completePage = CheckCompletePage();
  final PageController _pageController = PageController(initialPage: 0);

  //Sẽ gọi khi nhận được cờ "Gửi Mã" && "Xác thực" && "Cập nhật"
  void moveNextPage() {
    if (completePage.getStatusFirstPage()) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    if (completePage.getStatusSecPage()) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    if (completePage.getStatusThirdPage()) {
      Navigator.push(
          context,
          PageTransition(
              child: const LoginPage(), //MainPage
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 600)));
    }
  }

  void callBackFromFirst_Sec_ThirdPage(int page, bool status) {
    setState(() {
      switch (page) {
        case 1:
          completePage.completeFirstPage(status);
          printTestSetState();
          moveNextPage();
          break;
        case 2:
          completePage.completeFirstPage(false);
          completePage.completeSecPage(status);
          moveNextPage();
          break;
        case 3:
          completePage.completeSecPage(false);
          completePage.completeThirdPage(status);
          moveNextPage();
          break;
        default:
          break;
      }
    });
  }

  void printTestSetState() {
    log("Call Print");
    if (completePage.getStatusFirstPage()) {
      log("State changes !!!");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dynamic slide_1 = SizedBox(
        height: 400,
        width: 342,
        child: MyVerifyContainer(
          textOfButton: "Gửi mã",
          title_: "Quên mật khẩu ư?",
          subTitle_:
              "UPOX tới cứu nguy đây! Hãy nhập email mà bạn đã liên kết với tài khoản nhé.",
          isForgetPass_: true,
          callback: callBackFromFirst_Sec_ThirdPage,
        ));
    dynamic slide_2 = SizedBox(
        height: 400,
        width: 342,
        child: MyVerifyNumContainer(
          textOfButton: "Xác thực",
          title_: "Cho UPOX biết đó là bạn!",
          subTitle_:
              "Suỵt...! UPOX đã gửi mã xác thực qua email của bạn. Đừng cho ai biết nha!",
          isForgetPass_: true,
          callback: callBackFromFirst_Sec_ThirdPage,
        ));
    dynamic slide_3 = SizedBox(
        height: 400,
        width: 342,
        child: MyForgetPassContainer(
            textOfButton: "Cập nhật",
            title_: "Tạo mật khẩu mới",
            subTitle_:
                "Hãy tạo cho bản thân một mật khẩu an toàn và dễ nhớ nhé!",
            callback: callBackFromFirst_Sec_ThirdPage));

    _pages.add(slide_1);
    _pages.add(slide_2);
    _pages.add(slide_3);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    // printTestSetState();
    // moveNextPage();

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: screenHeight,
      width: screenWidth,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/forget_pass_backgr.png"),
              fit: BoxFit.fill)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            // color: Color(0xFF000000),
            child: MyLogo(),
          ),
          const SizedBox(
            height: 40,
            width: 10,
            child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFF))),
          ),
          Stack(children: [
            SizedBox(
                width: double.infinity,
                height: 410,
                child: Container(
                  padding: const EdgeInsets.only(top: 25),
                  decoration: const BoxDecoration(color: Color(0xFF)),
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (value) {
                      //value ở đây là index của page
                      setState(() {
                        _activePage = value;
                      });
                    },
                    itemCount: 3, //Length size
                    itemBuilder: (context, index) {
                      return _pages[index];
                    },
                  ),
                )),
            Positioned(
              child: Container(
                color: Colors.transparent,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      3, //Length size
                      (index) {
                        // index = 1;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              child: SizedBox(
                                  width: 25,
                                  height: 8,
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: _activePage == index
                                              ? const Color(0xFF18A0FB)
                                              : const Color(0xFFE0E0E0))))),
                        );
                      },
                    )),
              ),
            )
          ]),
        ],
      ),
    )));
  }
}
