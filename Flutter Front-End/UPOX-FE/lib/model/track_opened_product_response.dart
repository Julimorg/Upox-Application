import 'package:intl/intl.dart';

class TrackedOpenedProductResponse {
  DateTime? dateOpen;
  int? volumeLeft; 
  String? statusName; //take from statusId
  DateTime? openExpiryDate;
  DateTime? openStatusChangedDate;

  String DEFAULT_DATE_FORMAT = "dd/MM/yyyy";
  String CONVERT_DATE_FORMAT = "yyyy-MM-ddTHH:mm:ss";

  DateTime covertToDateTime(String dateString){
    DateFormat dateFormat = DateFormat(CONVERT_DATE_FORMAT);
    return dateFormat.parse(dateString);
  }

  TrackedOpenedProductResponse();

  TrackedOpenedProductResponse.json(Map<String, dynamic> json){
    dateOpen = covertToDateTime(json["dateOpen"]);
    volumeLeft = json["volumeLeft"];
    statusName = json["statusName"];
    openExpiryDate = covertToDateTime(json["openExpiryDate"]);
    openStatusChangedDate = covertToDateTime(json["openStatusChangedDate"]);
  }
}