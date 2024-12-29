import 'dart:developer';

import 'package:first_app/Components/khoa_component/check_complete_page.dart';
import 'package:first_app/Components/khoa_component/container_verify.dart';
import 'package:first_app/Components/khoa_component/container_verify_num.dart';
import 'package:first_app/Components/khoa_component/logo_.dart';
import 'package:first_app/Controller/token_controller.dart';
import 'package:first_app/View_Page/homepage_comboPage/homepage_mainview.dart';
import 'package:first_app/View_Page/loginPage.dart';
import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:carousel_slider/carousel_controller.dart';
import 'package:page_transition/page_transition.dart';

class MyVerifyScreen extends StatefulWidget {
  bool isGoogleSignUp;
  String gmail = "";

  MyVerifyScreen(this.isGoogleSignUp, {super.key});
  MyVerifyScreen.googleSignUp(this.isGoogleSignUp, this.gmail ,{super.key});


  @override
  State<MyVerifyScreen> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerifyScreen> {
  late List<Widget> _pages = [];
  int _activePage = 0; //First slide
  CheckCompletePage completePage = CheckCompletePage();

  // bool _isFirstPageSucceed = false;
  // bool _isSecPageSucceed = false;
  final PageController _pageController = PageController(initialPage: 0);
  TokenController tokenController = TokenController();

  // int _counter = 0; //--Màn hình hiển thị ban đầu bằng 0

  // void _incrementCounter() { //hàm private --> hàm gọi nhau
  //   setState(() { //cập nhật UI --> gọi lại setState
  //     _counter++; //Cộng dần khi được gọi action
  //   });
  // }

  //Sẽ gọi khi nhận được cờ "Gửi Mã" && "Xác thực"
  void moveNextPage() {
    if (completePage.getStatusFirstPage()) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    if (completePage.getStatusSecPage()) {
      Navigator.push(
          context,
          PageTransition(
              child: HomepageMainview(tokenController.getAccessToken(), tokenController.getRefreshToken()), //MainPage
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 600)));
    }
  }

  bool isNotAbleToSwipe = true;
  void callBackFromFirst_SecPage(int page, bool status) {
    setState(() {
      switch (page) {
        case 1:
          completePage.completeFirstPage(status);
          printTestSetState();
          moveNextPage();
          break;
        case 2:
          completePage.completeSecPage(status);
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
    dynamic slide_2 = SizedBox(
        height: 400,
        width: 342,
        child: MyVerifyNumContainer(
          textOfButton: "Xác thực",
          title_: "Cho UPOX biết đó là bạn!",
          subTitle_:
              "Suỵt...! UPOX đã gửi mã xác thực qua email của bạn. Đừng cho ai biết nha!",
          isForgetPass_: false,
          callback: callBackFromFirst_SecPage,
        ));

    dynamic slide_1 = SizedBox(
      height: 400,
      width: 342,
      child: widget.isGoogleSignUp?

      MyVerifyContainer.googleSignUp(
        widget.gmail,
        textOfButton: "Gửi mã",
        title_: "Kích hoạt tài khoản",
        subTitle_:
            "Cho UPOX biết email mà bạn mong muốn liên kết với tài khoản nha.",
        isForgetPass_: false,
        callback: callBackFromFirst_SecPage,
      )

      : MyVerifyContainer(
        textOfButton: "Gửi mã",
        title_: "Kích hoạt tài khoản",
        subTitle_:
            "Cho UPOX biết email mà bạn mong muốn liên kết với tài khoản nha.",
        isForgetPass_: false,
        callback: callBackFromFirst_SecPage,
      ),
    );

    _pages.add(slide_1);
    _pages.add(slide_2);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: screenHeight,
      width: screenWidth,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/verify_page_backgr.png"),
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
            child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.transparent)),
          ),

          Stack(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 410,
                  child: Container(
                    padding: const EdgeInsets.only(top: 25),
                    decoration: const BoxDecoration(color: Color(0xFF)),
                    child: PageView.builder(
                      controller: _pageController,
                      physics: isNotAbleToSwipe
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      onPageChanged: (value) {
                        //value ở đây là index của page
                        setState(() {
                          _activePage = value;
                          if (value == 1) {
                            //Có thể swipeback ngược lại để chỉnh email khác
                            isNotAbleToSwipe = false;
                            completePage.completeFirstPage(false);
                          } else if (value == 0) {
                            //Chặn lại việc swipe của người dùng
                            isNotAbleToSwipe = true;
                          }
                        });
                      },
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        // index = 1;
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
                        2,
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
            ],
          )

          // const SizedBox(
          //   height: 400,
          //   width: 342,
          //   child: MyVerifyNumContainer(textOfButton: "Xác thực",
          //     title_: "Cho UPOX biết đó là bạn!",
          //     subTitle_: "Suỵt...! UPOX đã gửi mã xác thực qua email của bạn. Đừng cho ai biết nha!",
          //     isForgetPass_: false)
          // ),

          // const SizedBox(
          //   height: 400,
          //   width: 342,
          //   child: MyVerifyContainer(textOfButton: "Gửi mã",
          //     title_: "Kích hoạt tài khoản",
          //     subTitle_: "Cho UPOX biết email mà bạn mong muốn liên kết với tài khoản nha.",
          //     isForgetPass_: false,),
          // )

          //Bỏ
          // MyVerifyContainer(textOfButton: "Gửi mã",
          // title_: "Kích hoạt tài khoản",
          // subTitle_: "Cho UPOX biết email mà bạn mong muốn liên kết với tài khoản nha.",
          // isSentEmail_: false,
          // isForgetPass_: false,),

          // MyVerifyNumContainer(textOfButton: "Xác thực",
          // title_: "Cho UPOX biết đó là bạn!",
          // subTitle_: "Suỵt...! UPOX đã gửi mã xác thực qua email của bạn. Đừng cho ai biết nha!",
          // isForgetPass_: false)
          // SizedBox(height: screenHeight/8),
        ],
      ),
    )));
  }
}

//    Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
//           backgroundColor: const Color(0xff1963AE),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               const Text(
//               'You have pushed the button this many times:',
//               ),
//               Text(
//               '$_counter',
//               ),
//             ]
//           ),
//         ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),)
//     );
