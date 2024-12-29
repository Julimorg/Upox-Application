// import 'package:first_app/Components/CommonComponent/guide_button.dart';
// import 'package:first_app/Components/CommonComponent/title_text.dart';
// import 'package:first_app/View_Page/calendar_comboPage/EventDetailsPage.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';

// class CalendarMainPage extends StatefulWidget {
//   @override
//   _CalendarMainPage createState() => _CalendarMainPage();
// }

// class _CalendarMainPage extends State<CalendarMainPage> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;

//   // Quản lý các sự kiện theo ngày
//   Map<DateTime, List<String>> _events = {
//     DateTime(2023, 11, 15): ['Meeting with client'],
//     DateTime(2023, 11, 20): ['Doctor appointment'],
//     DateTime(2023, 12, 25): ['Christmas Celebration'],
//     DateTime(2024, 1, 1): ['New Year\'s Day'],
//   };

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.sizeOf(context).width;
//     double height = MediaQuery.sizeOf(context).height;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               width: width * 0.95,
//               height: height * 0.06,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.date_range),
//                     onPressed: () async {
//                       _showDatePicker(context);
//                     },
//                   ),
//                   const TitleText(
//                     titleName: "Lịch của tôi",
//                     fontFam: "Roboto",
//                     fontWeight: FontWeight.w700,
//                     fontSize: 25,
//                     textColor: const Color(0xff363636),
//                   ),
//                   GuideButton(onPressed: () {}),
//                 ],
//               ),
//             ),
//             TableCalendar(
//               firstDay: DateTime.utc(2023, 1, 1),
//               lastDay: DateTime.utc(2024, 12, 31),
//               focusedDay: _focusedDay,
//               calendarFormat: _calendarFormat,
//               selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });

//                 // Điều hướng đến trang chi tiết sự kiện
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         EventDetailsPage(selectedDay: selectedDay),
//                   ),
//                 );
//               },
//               eventLoader: (day) => _getEventsForDay(day),
//               headerStyle: const HeaderStyle(
//                 formatButtonVisible: false, // Ẩn nút chuyển đổi định dạng lịch
//                 titleCentered: true, // Canh giữa tiêu đề
//                 leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
//                 rightChevronIcon:
//                     Icon(Icons.chevron_right, color: Colors.black),
//               ),
//               calendarBuilders: CalendarBuilders(
//                 markerBuilder: (context, date, events) {
//                   if (events.isNotEmpty) {
//                     String imageName = 'assets/status/calendar_status1.png';
//                     return Center(
//                       child: Image.asset(
//                         imageName,
//                         width: 20,
//                         height: 20,
//                       ),
//                     );
//                   }
//                   return null; // Nếu không có sự kiện, không hiển thị gì
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Hàm hiển thị DatePicker
//   Future<void> _showDatePicker(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _focusedDay,
//       firstDate: DateTime(2023, 1, 1),
//       lastDate: DateTime(2024, 12, 31),
//     );

//     if (picked != null && picked != _focusedDay) {
//       setState(() {
//         _focusedDay = picked;
//       });
//     }
//   }

//   // Cập nhật sự kiện thực tế hoặc trả về danh sách rỗng
//   List<String> _getEventsForDay(DateTime day) {
//     return _events[day] ?? []; // Nếu không có sự kiện, trả về danh sách rỗng
//   }
// }


//  // Đổ sự kiện lên ngày
//               // calendarBuilders: CalendarBuilders(
//               //   markerBuilder: (context, date, events) {
//               //     if (events.isNotEmpty) {
//               //       String imageName = 'assets/status/calendar_status1.png';
//               //       return Center(
//               //         child: Image.asset(
//               //           imageName,
//               //           width: 20,
//               //           height: 20,
//               //         ),
//               //       );
//               //     }
//               //     return null; // Nếu không có sự kiện, không hiển thị gì
//               //   },
//               // ),