import 'package:first_app/Components/notification_component/component/noti_component.dart';
import 'package:first_app/model/notification.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationContent extends StatefulWidget {
  List<NotificationResponse> notifications = [];
  
  NotificationContent(this.notifications, {super.key});
  //NotificationContent(this.notifications, {super.key});

  @override
  State<NotificationContent> createState() => _NotificationContent();
}

class _NotificationContent extends State<NotificationContent> {
  String originalLogoPath = "assets/noti_banner_icon.png";

  
  List<Map<String, String>> notifications = []; // Danh sách thông báo
  int notificationCount = 0; // Số lượng thông báo
  @override
  void initState() {
    super.initState();
   // fetchNotifications(); 
    // Gọi API khi khởi tạo
  }

  //Bỏ hàm

  // Future<void> fetchNotifications() async {
  //   // Mô phỏng việc gọi API
  //   await Future.delayed(Duration(seconds: 1)); // Giả lập độ trễ
  //   setState(() {
  //     notifications = [
  //       {
  //         "logoPath": "assets/noti_banner_icon.png",
  //         "title": "New Update", //heading
  //         "time": "10m ago", //dateSend
  //         "header": "Version 2.0 Released!",
  //         "content": "Check out the new features in the latest version." //noti_content
  //       },
  //       {
  //         "logoPath": "assets/noti_banner_icon.png",
  //         "title": "System Alert",
  //         "time": "2h ago",
  //         "header": "Scheduled Maintenance",
  //         "content": "Our system will undergo maintenance tonight at 12 AM."
  //       },
  //       {
  //         "logoPath": "assets/noti_banner_icon.png",
  //         "title": "New Update",
  //         "time": "10m ago",
  //         "header": "Version 2.0 Released!",
  //         "content": "Check out the new features in the latest version."
  //       },
  //       {
  //         "logoPath": "assets/noti_banner_icon.png",
  //         "title": "New Update",
  //         "time": "10m ago",
  //         "header": "Version 2.0 Released!",
  //         "content": "Check out the new features in the latest version."
  //       },
  //       {
  //         "logoPath": "assets/noti_banner_icon.png",
  //         "title": "New Update",
  //         "time": "10m ago",
  //         "header": "Version 2.0 Released!",
  //         "content": "Check out the new features in the latest version."
  //       },
  //       {
  //         "logoPath": "assets/noti_banner_icon.png",
  //         "title": "New Update",
  //         "time": "10m ago",
  //         "header": "Version 2.0 Released!",
  //         "content": "Check out the new features in the latest version."
  //       },
  //       {
  //         "logoPath": "assets/noti_banner_icon.png",
  //         "title": "New Update",
  //         "time": "10m ago",
  //         "header": "Version 2.0 Released!",
  //         "content": "Check out the new features in the latest version."
  //       },
  //     ];
  //     notificationCount = notifications.length; // Cập nhật số lượng thông báo
  //   });
  // }
  
  String convertToDateToString(DateTime dateTime){
    String dateFormatString  = "dd/MM/yyyy";
    return DateFormat(dateFormatString).format(dateTime);
  }

  String calculateDisplayedTimeSent(DateTime dateSend){
    DateTime currentDate = DateTime.now();
    int differenceHours = currentDate.difference(dateSend).inHours;
    int differenceMinutes =  currentDate.difference(dateSend).inMinutes;

    switch(differenceHours){
      case (< 1):
        return differenceMinutes.toString();
      case (>= 1 && < 24):
        return differenceHours.toString();
      case (>= 24 && < 48):
        return "1 ngày trước";
      case (>= 48 && < 72):
        return "2 ngày trước";
      case (>= 72 && < 96):
        return "3 ngày trước"; 
      case (> 96):
        return convertToDateToString(dateSend);
      default:
        return "";
    }
    
    //differenceMinute phút trước (< 1)
    //n giờ trước (>= 1 && < 24)
    //1 ngày trước (>= 24 && < 48)
    //2 ngày trước (>= 48 && < 72)
    //3 ngày trước  (>= 72 && < 96)
    //dd/MM/yyyy (> 96)
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Container(
      // color: Colors.green,
      height: height * 0.75,
      child: Expanded(
        child: ListView.builder(
          itemCount: widget.notifications.length,//notifications.length, //
          itemBuilder: (context, index) {
            final noti = widget.notifications[index];//notifications[index]; //
            return NotificationCard(
              logoPath: originalLogoPath,
              title: "",
              time: calculateDisplayedTimeSent(noti.dateSend!),
              header: noti.heading!,
              content: noti.notiContent!,
              onPressed: () {},
            );
          },
        ),
      ),
    );
  }
}
