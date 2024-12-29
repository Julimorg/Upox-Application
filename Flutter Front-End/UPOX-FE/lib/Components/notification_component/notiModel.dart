import 'package:flutter/material.dart';

class NotificationModel with ChangeNotifier {
  List<Map<String, String>> _notifications = [];
  int _notificationCount = 0;

  List<Map<String, String>> get notifications => _notifications;
  int get notificationCount => _notificationCount;

  // Hàm cập nhật thông báo
  void fetchNotifications() async {
    // Giả lập việc gọi API
    await Future.delayed(const Duration(seconds: 1));

    _notifications = [
      {
        "logoPath": "assets/noti_banner_icon.png",
        "title": "New Update",
        "time": "10m ago",
        "header": "Version 2.0 Released!",
        "content": "Check out the new features in the latest version."
      },
      {
        "logoPath": "assets/noti_banner_icon.png",
        "title": "System Alert",
        "time": "2h ago",
        "header": "Scheduled Maintenance",
        "content": "Our system will undergo maintenance tonight at 12 AM."
      },
    ];
    _notificationCount = _notifications.length;

    notifyListeners(); // Để thông báo cho các widget lắng nghe thay đổi
  }
}
