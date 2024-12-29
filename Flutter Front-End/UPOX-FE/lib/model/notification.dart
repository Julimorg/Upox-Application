import 'dart:convert';

import 'package:intl/intl.dart';

class NotificationResponse {
  DateTime? dateSend;
  String? notiContent;
  String? heading;
  String? type; //-> unread và read 

  NotificationResponse({this.dateSend, this.notiContent, this.heading, this.type});

  String DEFAULT_DATE_FORMAT = "dd/MM/yyyy";
  String CONVERT_DATE_FORMAT = "yyyy-MM-ddTHH:mm:ss";

  DateTime covertToDateTime(String dateString){
    DateFormat dateFormat = DateFormat(CONVERT_DATE_FORMAT);
    return dateFormat.parse(dateString);
  }

    String fixEncoding(String input) {  
    // Chuyển đổi chuỗi thành byte  
    List<int> bytes = latin1.encode(input);  // Mã hóa chuỗi như ISO-8859-1 (Latin1)  
    
    // Chuyển đổi byte thành chuỗi UTF-8  
    String fixedString = utf8.decode(bytes);  
    
    return fixedString;  
  }


  NotificationResponse.fromJson(Map<String, dynamic> json) {
    dateSend = covertToDateTime(json['dateSend']);
    notiContent = fixEncoding(json['noti_content']);
    heading = fixEncoding(json['heading']);
    type = json['type'];
  }
}
