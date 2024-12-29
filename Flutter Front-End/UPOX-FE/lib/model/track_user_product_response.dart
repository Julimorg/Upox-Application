import 'dart:convert';
import 'dart:developer';

import 'package:first_app/model/track_opened_product_response.dart';
import 'package:intl/intl.dart';

class TrackedUserProductResponse {
  String? transactionId;
  String? productId;
  String? productName;
  String? statusName;
  String? categoryName;
  DateTime? expiryDate;
  int? quantity;
  int? cost;
  int? volume;
  DateTime? dateBought;
  int? peopleUse;
  String? frequency;
  String? wayPreserve;
  bool? isOpened; 
  String? imagePath;
  String? categoryImagePath;
  String? volumeUnit;
  int? numberOfProductsHasFinished;
  TrackedOpenedProductResponse? openedProductResponse;

  TrackedUserProductResponse.initialize();

  String DEFAULT_DATE_FORMAT = "dd/MM/yyyy";
  String CONVERT_DATE_FORMAT = "yyyy-MM-ddTHH:mm:ss";

  DateTime covertToDateTime(String dateString){
    DateFormat dateFormat = DateFormat(CONVERT_DATE_FORMAT);
    return dateFormat.parse(dateString);
  }

  String getDateBoughtAsString(){
    return DateFormat("dd/MM/yyyy").format(dateBought!);
  }

  String getDateExpiredAsString(){
    return DateFormat("dd/MM/yyyy").format(expiryDate!);
  }


  String fixEncoding(String input) {  
    // Chuyển đổi chuỗi thành byte  
    List<int> bytes = latin1.encode(input);  // Mã hóa chuỗi như ISO-8859-1 (Latin1)  
    
    // Chuyển đổi byte thành chuỗi UTF-8  
    String fixedString = utf8.decode(bytes);  
    
    return fixedString;  
  }  

  TrackedUserProductResponse.fromJson(Map<String, dynamic> json) {
    log("Inventory pouring: ${json.toString()}");
    transactionId = json["transactionId"];
    productId = json["productId"];
    productName = fixEncoding(json["productName"]);
    statusName = json["statusName"];
    categoryName = fixEncoding(json["categoryName"]);
    // log("Debug ExpiredDate (1)");
    expiryDate = covertToDateTime(json["expiryDate"]);
    // log("Debug ExpiredDate (2)");
    quantity = json["quantity"];
    cost = json["cost"];
    volume = json["volume"];
    dateBought = covertToDateTime(json["dateBought"]);
    peopleUse = json["peopleUse"];
    frequency = json["frequency"];
    wayPreserve = fixEncoding(json["wayPreserve"]);
    isOpened = json["opened"];
    imagePath = json["imagePath"];
    categoryImagePath = json["categoryImagePath"];
    volumeUnit = json["volumeUnit"];
    numberOfProductsHasFinished = json["numberOfProductsHasFinished"];
    
    if(isOpened! == true && json["trackedUserProductOpened"] != null){
        openedProductResponse = TrackedOpenedProductResponse.json(json["trackedUserProductOpened"]);
    }
  }
}