import 'package:first_app/model/notification.dart';
import 'package:first_app/model/warning_categories.dart';

class HomePageInformation {
  // List warning category
  List<WarningCategories>? warningCategories = [];

  // list notification
  List<NotificationResponse>? notifications = [];

  HomePageInformation.initialize();

  HomePageInformation(this.warningCategories, this.notifications);
}
