import 'package:first_app/Components/homepage_component/category_display.dart';
import 'package:first_app/model/warning_categories.dart';
import 'package:flutter/material.dart';

class ContentHomePage extends StatelessWidget {
  List<WarningCategories>? warningCategories = [];

  ContentHomePage(this.warningCategories, {super.key});

  // Danh sách hình ảnh
  static const List<String> imagePaths = [
    "assets/robot_banner_1.png",
    "assets/robot_banner_3.png",
    "assets/robot_banner_4.png",
  ];

  Widget renderWarningCategories(int? numOfWarningCategories){
    if(numOfWarningCategories == 0){
      return Container();
    }
    return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                "Dùng mau mau, không kịp đâu!",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "intern",
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color.fromARGB(205, 54, 54, 54),
                ),
              ),
            );
  }

  @override
  Widget build(BuildContext context) {
    int? numOfWarningCategories = warningCategories?.length;

    final screenSize = MediaQuery.of(context).size;
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 10),
            // Text Warning Tag
            renderWarningCategories(numOfWarningCategories),
            const SizedBox(height: 10),
            //? Display Category
            CategoryDisplay(warningCategories),

            const SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                "Gợi ý tiêu dùng",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "intern",
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color.fromARGB(205, 54, 54, 54),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Slider
            Container(
              height: screenSize.height * 0.2,
              width: screenSize.width * 0.9,
              child: SizedBox(
                child: PageView.builder(
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(imagePaths[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Trash Text and Trash Ads =))
            // Trash Text ads
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                "Mỗi ngày 1 tip dùng",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "intern",
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color.fromARGB(205, 54, 54, 54),
                ),
              ),
            ),
            // Trash ads banner
            Container(
              height:
                  screenSize.height * 0.2, // Kích thước của banner quảng cáo
              width: screenSize.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage("assets/robot_banner_2.png"),
                  )),
            ),
            // Trash Text Banner
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                "Đồ cạn kiệt, sao làm việc!",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "intern",
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color.fromARGB(205, 54, 54, 54),
                ),
              ),
            ),
            // Trash small Text banner
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                "Uti thấy thịt đóng hộp của bạn hết hạn rồi,\nmau mau đi mua thôi",
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: "intern",
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color.fromARGB(205, 174, 171, 171),
                ),
              ),
            ),
            // Trash ads banner
            Container(
              height:
                  screenSize.height * 0.2, // Kích thước của banner quảng cáo
              width: screenSize.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage("assets/robot_banner_5.png"),
                  )),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
