import 'dart:convert';
import 'dart:developer';

import 'package:first_app/Components/wallet_component/wallet_model/wallet_itemsData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

//** NOTE
//* Đã FIX UI cho ProgressItemData
//* Đã Thêm định mức tiền tệ cho Text
//* Đã thêm các attribute mới để đổ dữ liệu:
// * --> progressNum: "100%",
// *  --> percent: 0.7,
// * ---> statusColor: statusColor,

class WalletItemsProgressdata extends StatefulWidget {

  final List<Color> segmentColors;
  int totSpent = 0;
  Map<String, dynamic> categories = {};
  String displayedMonth = "";
  String displayedYear = "";


  //List<Expense>
  WalletItemsProgressdata(this.categories, this.totSpent, this.displayedMonth, this.displayedYear,
  {super.key, required this.segmentColors});

  @override
  State<WalletItemsProgressdata> createState() =>
      _WalletItemsProgressdataState();
}

class _WalletItemsProgressdataState extends State<WalletItemsProgressdata> {
  // Danh sách chứa các item
  List<WalletItemsdata> items = [];
  //Sử dụng biến này thay thế
  List<WalletItemsdata> displayedCategories = [];
  bool isLoading = false;
  int page = 1; // Giả sử bạn muốn tải dữ liệu theo từng trang

  @override
  void initState() {
    super.initState();
    // Tải dữ liệu lần đầu
    _buildDisplayedCategories();
  }

  String fixEncoding(String input) {  
    // Chuyển đổi chuỗi thành byte  
    List<int> bytes = latin1.encode(input);  // Mã hóa chuỗi như ISO-8859-1 (Latin1)  
    
    // Chuyển đổi byte thành chuỗi UTF-8  
    String fixedString = utf8.decode(bytes);  
    
    return fixedString;  
  }  

  List<Color> defaultColors = [
    const Color(0xff92F9CE),
    const Color(0xff4AA8FF),
    const Color(0xff73D3FC),
    const Color(0xffFFABF7),
    const Color(0xffFF3850),
    const Color(0xffFFCD4C),
    const Color(0xffFF9D88),
  ];


  //Sử dụng hàm này thay thế, vì giai đoạn này khá ít cate
  
  void _buildDisplayedCategories(){
    int size = widget.categories.length;
    int index = 0;
    widget.categories.forEach((key, value) {
      log("$key: ${value/widget.totSpent*100}"); //percentage

      String cateName = fixEncoding(key.split("-")[0]);
      String imagePath = key.split("-")[1];

      //Tính %
      double percentage = value/widget.totSpent;

      //Format tiền
      String formattedPrice = NumberFormat.currency(
        locale: 'vi_VN',
        symbol: '₫',
        decimalDigits: 0, //--> Số thập phân bằng 0
      ).format(value);

      //? Lấy màu từ WalletProgressData
      Color statusColor = widget.segmentColors.isNotEmpty
          ? widget.segmentColors[index]
          : Colors.grey;

      //Add vào mảng
      displayedCategories.add(
        WalletItemsdata(
          itemName: cateName,
          itemPrice: formattedPrice,
          progressNum: "${(percentage * 100).ceil()}%", //Tự tính % đổ lên 
          itemImage: "assets/category$imagePath.png",
          percent: percentage, //Tự tính % đổ lên 
          statusColor: defaultColors[index],
          onPressed: () {},
        )
      );
      index++;
    },);
  }


  // Hàm tải thêm dữ liệu (giả lập API)
  Future<void> loadMoreItems() async {
    if (isLoading) return; // Tránh tải lại khi đang tải
    setState(() {
      isLoading = true;
    });

    // Giả lập tải thêm dữ liệu từ API (delay 1 giây)
    await Future.delayed(const Duration(seconds: 1));
    
    //? Tạo ra dữ liệu mới cho mỗi trang
    //Tao bỏ 
    List<WalletItemsdata> newItems = List.generate(7, (index) {
      int price = (page * 10 + index) * 10000;
      String formattedPrice = NumberFormat.currency(
        locale: 'vi_VN',
        symbol: '₫',
        decimalDigits: 0, //--> Số thập phân bằng 0
      ).format(price);
      //? Lấy màu từ WalletProgressData
      Color statusColor = widget.segmentColors.isNotEmpty
          ? widget.segmentColors[index % widget.segmentColors.length]
          : Colors.grey;
          
      return WalletItemsdata(
        itemName: "Đồ đống họp ${page * 10 + index}",
        itemPrice: formattedPrice,
        progressNum: "100%", //Tự tính % đổ lên 
        itemImage: "assets/category/cate_donghop.png",
        percent: 0.7, //Tự tính % đổ lên 
        statusColor: statusColor,
        onPressed: () {},
      );
    });

    setState(() {
      page++;
      isLoading = false;
      items.addAll(newItems); // Thêm các item mới vào danh sách hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        builder: (BuildContext context, ScrollController scrollController) {
          // Lắng nghe sự kiện cuộn để kiểm tra khi nào người dùng đã đến cuối danh sách
          scrollController.addListener(() {
            if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent) {
              // Nếu cuộn đến cuối thì tải thêm dữ liệu
              // loadMoreItems();
              // Giai đoạn hiện tại màn hình đã đủ thể hiện
            }
          });

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Thanh kéo
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Tiêu dùng ${widget.displayedMonth}/${widget.displayedYear}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: displayedCategories.length +
                        (isLoading
                            ? 1
                            : 0), // Thêm 1 mục cho spinner khi đang tải
                    itemBuilder: (context, index) {
                      // if (index == items.length) {
                      //   // Nếu là mục cuối cùng thì hiển thị spinner
                      //   return Center(
                      //     child: LoadingAnimationWidget.discreteCircle(
                      //       color: Colors.blue,
                      //       size: 30,
                      //     ),
                      //   );
                      // }
                      return displayedCategories[index];
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
