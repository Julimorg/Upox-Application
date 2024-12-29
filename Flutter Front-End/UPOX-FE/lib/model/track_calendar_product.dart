import 'dart:developer';

import 'package:first_app/model/track_user_product_response.dart';
import 'package:intl/intl.dart';

class TrackedCalendarProduct {
  late TrackedUserProductResponse trackedUserProductResponse;
  late DateTime dateDisplay;
  late String statusDisplay;

  String DEFAULT_DATE_FORMAT = "dd/MM/yyyy";
  String CONVERT_DATE_FORMAT = "yyyy-MM-dd";

  DateTime covertToDateTime(String dateString){
    log("Date String $dateString");
    DateFormat dateFormat = DateFormat(CONVERT_DATE_FORMAT);
    return dateFormat.parse(dateString);
  }

  String getDateDisplayedAsString(){
    return DateFormat("dd/MM/yyyy").format(dateDisplay);
  }

  TrackedCalendarProduct.initialize();
  TrackedCalendarProduct.fromJson(Map<String,dynamic> json){
    trackedUserProductResponse = TrackedUserProductResponse.fromJson(json["trackedUserProduct"]);
    dateDisplay = covertToDateTime(json["dateDisplay"]);
    statusDisplay = json["statusDisplay"];
  }


}