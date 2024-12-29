import 'package:first_app/Components/homepage_component/component/footer_button.dart';
import 'package:first_app/View_Page/calendar_comboPage/calendar_main_page.dart';
import 'package:first_app/View_Page/dialogue_comboPage/dialogue_main_page.dart';
import 'package:first_app/View_Page/homepage_comboPage/homepage_content.dart';
import 'package:first_app/View_Page/homepage_comboPage/inventory_main_page.dart';
import 'package:first_app/View_Page/homepage_comboPage/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class HomepageMainview extends StatefulWidget {

  final String? accessToken;
  final String? refreshToken;

  const HomepageMainview(this.accessToken, this.refreshToken, {super.key});

  @override
  State<HomepageMainview> createState() => _HomepageMainview();
} 

class _HomepageMainview extends State<HomepageMainview> {
  int _selectedIndex = 0;

  // Define GlobalKey for each Navigator
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // List of pages to show
  static final List<Widget> _pages = <Widget>[
    const HomepageContent(),
    CalendarMainPage(),
    InventoryMainPage(),
    WalletMainPage(),
  ];

  // Function to handle navigation on bottom bar
  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // If tapping the current tab, pop to the first page in the stack if possible
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Function to build each tab with Offstage and Navigator
  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => _pages[index], 
            //HomepageContent(), CalendarMainPage(), InventoryMainPage(), WalletMainPage(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return
        //! VẪN CHƯA GIẢI QUYẾT ĐƯỢC CALL BACK RA CÁC PAGE TRƯỚC ĐÓ
        //   PopScope(
        // canPop: true, // Define if the page can be popped
        // onPopInvokedWithResult: (didPop, result) async {
        //   if (didPop) {
        //     // If the page has already been popped, don't do anything

        //     return;
        //   }
        //   // Logic để xử lý pop với điều kiện
        //   final navigator = Navigator.of(context);x
        //   // Kiểm tra xem nếu có thể pop (nghĩa là có route trước đó)
        //   final isFirstRouteInCurrentTab =
        //       !await _navigatorKeys[_selectedIndex].currentState!.maybePop();

        //   if (isFirstRouteInCurrentTab) {
        //     navigator.pop(result);
        //   } else {
        //     // If the current page is not the first route, pop the page
        //     _navigatorKeys[_selectedIndex].currentState?.pop();
        //   }
        // },
        //? PHƯƠNG PHÁP CŨ HOẠT ĐỘNG ĐƯỢC NHƯNG BỊ DOWN RỒI NÊN KHÔNG NÊN SỬ DỤNG
      WillPopScope(
        onWillPop: () async {
          //Xét xem có phải là trang home không
          final isFirstRouteInCurrentTab =
              !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
          //_navigatorKeys[_selectedIndex]: lấy ra 1 trong 4 trang chính
          //currentState: tình trạng trang
          //maybePop(): out ra khỏi app

          if (isFirstRouteInCurrentTab) { //TRANG HOME
            //Fetch dữ liệu
            return true;
          } else {
            return false;
          }
        },
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
          ],
        ),
        bottomNavigationBar: Container(
          height: screenSize.height * 0.08,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home Button
              FooterSelectButton(
                onPressed: () => _onItemTapped(0),
                imagePath: 'assets/home_white_icon.png',
                backgroundColor:
                    _selectedIndex == 0 ? Colors.blue : Colors.white,
                imageColor: _selectedIndex == 0 ? Colors.white : Colors.black,
                imageSize: 25.0,
              ),
              // Calendar Button
              FooterSelectButton(
                onPressed: () => _onItemTapped(1),
                imagePath: 'assets/calendar_icon.png',
                backgroundColor:
                    _selectedIndex == 1 ? Colors.blue : Colors.white,
                imageColor: _selectedIndex == 1 ? Colors.white : Colors.black,
                imageSize: 25.0,
              ),
              // Add Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const DialoguePage(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  elevation: 0,
                  side: const BorderSide(width: 0, color: Colors.blue),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.blue,
                ),
                child: Image.asset(
                  'assets/plus_icon.png',
                  width: 35,
                  height: 35,
                ),
              ),
              // Box Button
              FooterSelectButton(
                onPressed: () => _onItemTapped(2),
                imagePath: 'assets/box_icon.png',
                backgroundColor:
                    _selectedIndex == 2 ? Colors.blue : Colors.white,
                imageColor: _selectedIndex == 2 ? Colors.white : Colors.black,
                imageSize: 25.0,
              ),
              // Wallet Button
              FooterSelectButton(
                onPressed: () => _onItemTapped(3),
                imagePath: 'assets/wallet_icon.png',
                backgroundColor:
                    _selectedIndex == 3 ? Colors.blue : Colors.white,
                imageColor: _selectedIndex == 3 ? Colors.white : Colors.black,
                imageSize: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
