// import 'package:first_app/Components/edit_page_component/EditScroll_Model/edit_page_scroll_date_event.dart';
// import 'package:first_app/Components/edit_page_component/EditScroll_Model/edit_page_scroll_selectIntensity.dart';
// import 'package:first_app/Components/edit_page_component/EditScroll_Model/edit_page_scroll_userNum.dart';
// import 'package:first_app/Components/edit_page_component/SelectOptionCustom/edit_select_option_bar.dart';
// import 'package:first_app/Components/edit_page_component/edit_price.dart';
// import 'package:first_app/Components/edit_page_component/edit_volume_page_fieldtext.dart';
// import 'package:first_app/View_Page/edit_page_comboView/edit_price_items.dart';
// import 'package:first_app/View_Page/edit_page_comboView/edit_volume_items.dart';
// import 'package:first_app/View_Page/product_list_page.dart';
// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';

// import 'EditScroll_Model/edit_page_scroll_quantity.dart';

// class EditPageSelectoption extends StatefulWidget {
//   const EditPageSelectoption({super.key});

//   @override
//   State<EditPageSelectoption> createState() => _EditPageSelectoption();
// }

// class _EditPageSelectoption extends State<EditPageSelectoption> {
//   // default attributes
//   String _selectedVolume = "0"; // Giá trị mặc định
//   String hsdDate = "1/1/2023";
//   int quantity = 0;
//   int usernum = 0;
//   int intensity = 0;
//   String unit = 'Ngày';
//   int _currentPrice = 0;
//   // Danh sách sản phẩm

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.sizeOf(context).width;
//     double height = MediaQuery.sizeOf(context).height;
//     return Center(
//       child: Container(
//         // margin: EdgeInsets.only(right: 20),
//         // color: Colors.amber,
//         height: height * 0.65,
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Container Select History Input
//               Container(
//                 child: Column(children: [
//                   //? Option1 : Khối lượng
//                   EditSelectOptionBar(
//                     labelText: "Khối lượng tịnh",
//                     weightText: "$_selectedVolume g",
//                     gradientStartColor: const Color(0xffB0E0E6),
//                     gradientEndColor: Colors.white,
//                     onPressed: () async {
//                       // Mở EditVolumePageFieldtext và nhận giá trị trả về
//                       final result = await Navigator.push(
//                         context,
//                         PageTransition(
//                           child: const EditVolumeItemsPage(),
//                           type: PageTransitionType.rightToLeft,
//                           duration: const Duration(milliseconds: 600),
//                         ),
//                       );

//                       if (result != null) {
//                         setState(() {
//                           _selectedVolume = result; // Cập nhật giá trị
//                         });
//                       }
//                     },
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                   ),

//                   const SizedBox(height: 10),
//                   //? Option2 : Số lượng
//                   EditSelectOptionBar(
//                     labelText: "Số lượng",
//                     weightText: "$quantity sản phẩm",
//                     gradientStartColor: const Color(0xffB0E0E6),
//                     gradientEndColor: Colors.white,
//                     onPressed: () {
//                       showEditQuantityDialog(context, (selectedQuantity) {
//                         setState(() {
//                           quantity = selectedQuantity;
//                         });
//                       });
//                     },
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                   ),

//                   const SizedBox(height: 10),
//                   //? Option3 : HSD
//                   EditSelectOptionBar(
//                     labelText: "HSD",
//                     weightText: "$hsdDate",
//                     gradientStartColor: Color(0xffB0E0E6),
//                     gradientEndColor: Colors.white,
//                     onPressed: () {
//                       // Gọi dialog để chọn ngày
//                       showEditDateDialog(
//                         context,
//                         DateTime
//                             .now(), // Hoặc giá trị ngày giờ hiện tại hoặc giá trị ngày bạn muốn
//                         (selectedDate) {
//                           setState(() {
//                             hsdDate = selectedDate; // Cập nhật ngày đã chọn
//                           });
//                         },
//                       );
//                     },
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                   ),
//                   const SizedBox(height: 10),
//                   //? Option4 : Người dùng
//                   EditSelectOptionBar(
//                     labelText: "Người dùng",
//                     weightText: "$usernum người",
//                     gradientStartColor: Color(0xffB0E0E6),
//                     gradientEndColor: Colors.white,
//                     onPressed: () {
//                       ShowUserNum(context, (onUserNumSelected) {
//                         setState(() {
//                           usernum = onUserNumSelected;
//                         });
//                       });
//                     },
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                   ),
//                   const SizedBox(height: 10),
//                   //? Option5 : Cường độ
//                   EditSelectOptionBar(
//                     labelText: "Cường độ",
//                     weightText: "$intensity lần/$unit",
//                     gradientStartColor: Color(0xffB0E0E6),
//                     gradientEndColor: Colors.white,
//                     onPressed: () {
//                       ShowIntensitySelected(context,
//                           (onIntensitySelected, selectedUnit) {
//                         setState(() {
//                           intensity = onIntensitySelected;
//                           unit = selectedUnit;
//                         });
//                       });
//                     },
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                   ),
//                   const SizedBox(height: 10),
//                   EditSelectOptionBar(
//                     labelText: "Cách bảo quản",
//                     weightText: "nhiệt độ phòng",
//                     gradientStartColor: Color(0xffB0E0E6),
//                     gradientEndColor: Colors.white,
//                     onPressed: () {},
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                   ),
//                   const SizedBox(height: 10),
//                   // Option7 : Giá
//                   EditSelectOptionBar(
//                     labelText: "Giá",
//                     weightText: "$_currentPrice đ", // Cập nhật hiển thị giá
//                     gradientStartColor: Color(0xffB0E0E6),
//                     gradientEndColor: Colors.white,
//                     onPressed: () async {
//                       // Sử dụng await để lấy giá trị từ EditPrice
//                       final selectedPrice = await Navigator.push(
//                         context,
//                         PageTransition(
//                           child: const EditPriceItemsPage(),
//                           type: PageTransitionType.rightToLeft,
//                           duration: const Duration(milliseconds: 600),
//                         ),
//                       );

//                       // Kiểm tra nếu selectedPrice không null và là kiểu String
//                       if (selectedPrice != null && selectedPrice is String) {
//                         setState(() {
//                           // Cập nhật giá trị cho _currentPrice
//                           _currentPrice =
//                               (double.tryParse(selectedPrice) ?? 0.0)
//                                   .toInt(); // Chuyển đổi từ String sang int
//                         });
//                       }
//                     },
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                   ),

//                   const SizedBox(height: 10),
//                 ]),
//               ),
//               const SizedBox(height: 20),
//               // Trash banner
//               Container(
//                 child: Column(
//                   children: [
//                     Container(
//                       child: const Text(
//                         "Bạn có muốn sử dụng ngay 1 tuýp kem đánh răng\n không?",
//                         style: TextStyle(
//                           fontFamily: "inter",
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400,
//                           color: Color(0xff363636),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       child: const Text(
//                         "*Hệ thống sẽ hiểu bạn đang sử dụng 1 sản phẩm ",
//                         style: TextStyle(
//                             fontFamily: "inter",
//                             color: Color(0xff18A0FB),
//                             fontSize: 10,
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.italic),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               // Container confirm button
//               Container(
//                 child: Center(
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         PageTransition(
//                           child: ProductListPage.initialize(),
//                           type: PageTransitionType.rightToLeft,
//                           duration: const Duration(milliseconds: 300),
//                         ),
//                       );
//                     },
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       minimumSize: const Size(266, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                     ),
//                     child: const Text("Xác nhận!",
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                           letterSpacing: 0.5,
//                         )),
//                   ),
//                 ),
//               )
//             ]),
//       ),
//     );
//   }
// }
