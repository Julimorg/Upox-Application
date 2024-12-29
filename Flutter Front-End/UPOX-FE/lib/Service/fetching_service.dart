import 'dart:convert';
import 'dart:developer';

import 'package:first_app/Components/khoa_component/Comp_logic/domain_name.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Controller/token_controller.dart';
import 'package:first_app/model/expense.dart';
import 'package:first_app/model/history_product_response.dart';
import 'package:first_app/model/homepage_information.dart';
import 'package:first_app/model/inventory_response.dart';
import 'package:first_app/model/notification.dart';
import 'package:first_app/model/product_default_response.dart';
import 'package:first_app/model/track_calendar_product.dart';
import 'package:first_app/model/track_user_product.dart';
import 'package:first_app/model/track_user_product_response.dart';
import 'package:first_app/model/warning_categories.dart';
import 'package:http/http.dart' as http;

class FetchingService {
  final TokenController tokenController = TokenController();
  late RequestController requestController;
  final String domainName = DomainName.domainName;

  FetchingService({required this.requestController});
  FetchingService.initialize();

  //Homepage fetching
  Future<dynamic> fetchHomeScreenData() async{
    
    log("Fetching Homepage");
    final dynamic url = Uri.parse("$domainName/api/v1/product/homePage");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      }
    );
    
    if (response.statusCode == 200) {
      log("Fetching Homepage successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      log(result["warningCategories"].runtimeType.toString());
      log(result["notifications"].runtimeType.toString());

      try{
        List<dynamic> tempWarningCategories = result["warningCategories"];
        List<dynamic> tempNotifications = result["notifications"];

        List<WarningCategories> warningCategories = 
        tempWarningCategories.map((e) => e as WarningCategories).toList();

        List<NotificationResponse> notifications = 
        tempNotifications.map((e) => e as NotificationResponse).toList();

        return HomePageInformation(warningCategories, notifications);
      }catch(e){
        log(e.toString());
        return HomePageInformation(null,null);
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching Fail');
      return HomePageInformation(null,null);
    }
  }

  Future<dynamic> fetchHistoryProductList() async{
    log("Fetching History");
    final dynamic url = Uri.parse("$domainName/api/v1/product/myHistory");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      }
    );
    
    if (response.statusCode == 200) {
      log("Fetching History successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      log(result["trackedUserProductList"].runtimeType.toString());

      try{
        List<dynamic> tempNameOfProducts = result["trackedUserProductList"];

        List<String> nameOfProducts = tempNameOfProducts.map((e) => e as String).toList();

        return HistoryProductResponse(nameOfProducts);
      }catch(e){
        log(e.toString());
        return null;
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching History Fail');
      return HomePageInformation(null,null);
    }
  }

  Future<dynamic> checkProductExist(String productName) async{

    log("Check Product Exist");
    final dynamic url = Uri.parse("$domainName/api/v1/product/checkExist");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final msg = jsonEncode({"productName": productName,});


    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      },
      body: msg
    );
    
    if (response.statusCode == 200) {
      log("Check Product successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      try{
        ProductDefaultResponse productDefaultResponse = ProductDefaultResponse.fromJson(result);
        return productDefaultResponse;
      }catch(e){
        log(e.toString());
        return null;
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching History Fail');
      return HomePageInformation(null,null);
    }

  }

  Future<dynamic> addProduct(List<TrackedUserProduct> list) async{ //Navigate to Inventory Page

    List<Map<String, dynamic>> productRequestJson = [];
    list.forEach((element) {
      productRequestJson.add(element.toJson());
    },);
    var data = {'requestList': productRequestJson};  
    


    log("Add TrackedUserProduct");
    final dynamic url = Uri.parse("$domainName/api/v1/product/addProduct");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(data) //encode from map to json
    );
    
    if (response.statusCode == 200) {
      log("Check Product successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      try{
        dynamic tempTrackedUserProduct = result["responseList"];
        log(tempTrackedUserProduct.runtimeType.toString()); //Map<String, dynamic>

        List<dynamic> tempDynamic = 
        tempTrackedUserProduct.map((e) => TrackedUserProductResponse.fromJson(e)).toList();

        List<TrackedUserProductResponse> trackedUserProductResponses = tempDynamic
        .map((e) => e as TrackedUserProductResponse).toList();


        return trackedUserProductResponses;
      }catch(e){
        log(e.toString());
        return [];
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching History Fail');
      return null;
    }
  }

  Future<dynamic> checkProductBeenUsing(String productId) async {
    //Code here 
    log("Checking product being used");
     final dynamic url = Uri.parse("$domainName/api/v1/product/checkProductBeenUsing/$productId");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      }
    );
    
    if (response.statusCode == 200) {
      log("Checking product being used successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      log(result.runtimeType.toString());

      try{
        
        bool isProducBeingUsed = result;

        return isProducBeingUsed;
      }catch(e){
        log(e.toString());
        return null;
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching Fail');
      return null;
    }
  }
  
  Future<dynamic> updateProduct(String productId, String transactionId, TrackedUserProduct trackedUserProduct) async{ //==> Navigate to DetailProductPage
    //Code here 
    log("Updating Product");
    final dynamic url = Uri.parse("$domainName/api/v1/product/updateProduct/$productId/$transactionId");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    //Preparing body
    Map<String, dynamic> req = trackedUserProduct.toJson();
    log("req: ${req["isOpened"]}");

    String jsonString = json.encode(req);
    log(jsonString);


    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonString,
    );
    
    if (response.statusCode == 200) {
      log("Updating product successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      log(result.runtimeType.toString());

      try{
        TrackedUserProductResponse updatedProduct = TrackedUserProductResponse.fromJson(result);
        return updatedProduct;
      }catch(e){
        log(e.toString());
        return null;
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching Fail');
      return null;
    }


  }

  Future<dynamic> deleteProduct(String productId, String transactionId) async{
    //Code here
    log("Deleting product");
     final dynamic url = Uri.parse("$domainName/api/v1/product/deleteProduct/$productId/$transactionId");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      }
    );
    
    if (response.statusCode == 200) {
      log("Deleting product successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      log(result.runtimeType.toString());

      try{
        String message = result;
      
        return message;
      }catch(e){
        log(e.toString());
        return null;
      }
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching Fail');
      return null;
    } 
    
  }

  Future<dynamic> finishUsingProduct(String productId, String transactionId) async{
    //Code here 
    log("Finish Using Product");
    final dynamic url = Uri.parse("$domainName/api/v1/product/finishUsing/$productId/$transactionId");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      }
    );
    
    if (response.statusCode == 200) {
      log("Finish using product successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      log(result.runtimeType.toString());

      try{
        TrackedUserProductResponse updatedProduct = TrackedUserProductResponse.fromJson(result);
        return updatedProduct;
      }catch(e){
        log(e.toString());
        return null;
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching Fail');
      return null;
    }

  }
  
  Future<dynamic> fetchInventoryInitial() async{
    //Code here 
    log("Fetching Initial Inventory");
    
    final dynamic url = Uri.parse("$domainName/api/v1/product/getInventory");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      }
    );
    
    if (response.statusCode == 200) {
      log("Fetching Inventory successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      log(result["displayedProduct"]["responseList"].runtimeType.toString());

      try{
        dynamic tempTrackedUserProduct = result["displayedProduct"]["responseList"];
        log("Inventory result: ${tempTrackedUserProduct.runtimeType.toString()}"); 

        List<dynamic> tempDynamic = 
        tempTrackedUserProduct.map((e) => TrackedUserProductResponse.fromJson(e)).toList();

        log("Pouring Inventory successfully");   

        List<TrackedUserProductResponse> trackedUserProductResponses = tempDynamic
        .map((e) => e as TrackedUserProductResponse).toList();

        InventoryResponse inventoryInformation =  InventoryResponse.fromJson(result, trackedUserProductResponses);

        

        return inventoryInformation;
      }catch(e){
        log(e.toString());
        return null;
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching Fail');
      return null;
    }
  }

  Future<dynamic> fetchInventoryWithCondition(String searchValue, String categories, String status,
  String lateness, String sortBy, bool isAscending) async{
    //Code here 
    log("Fetching Conditional Inventory");

    searchValue = searchValue.isEmpty? "null" : searchValue;
    categories = categories.isEmpty? "null" : categories;
    status = status.isEmpty? "null" : status;
    lateness = lateness.isEmpty? "null" : lateness;
    sortBy = sortBy.isEmpty? "null" : sortBy;

    String parameters = "$searchValue/$categories/$status/$lateness/$sortBy/$isAscending";

    final dynamic url = Uri.parse("$domainName/api/v1/product/getInventory/$parameters");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      }
    );
    
    if (response.statusCode == 200) {
      log("Fetching Inventory successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      log(result["responseList"].runtimeType.toString());

      try{
        dynamic tempTrackedUserProduct = result["responseList"];
        log(tempTrackedUserProduct.runtimeType.toString()); //Map<String, dynamic>

        List<dynamic> tempDynamic = 
        tempTrackedUserProduct.map((e) => TrackedUserProductResponse.fromJson(e)).toList();

        List<TrackedUserProductResponse> trackedUserProductResponses = tempDynamic
        .map((e) => e as TrackedUserProductResponse).toList();

        return trackedUserProductResponses;
      }catch(e){
        log(e.toString());
        return [];
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching Fail');
      return null;
    }
  }

  Future<dynamic> fetchCalendar(String month, String year)async{
    //Code here 
    String monthYear = "$month-$year";

    log("Fetching Calendar");
    final dynamic url = Uri.parse("$domainName/api/v1/product/getCalendar/$monthYear");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      }
    );
    
    if (response.statusCode == 200) {
      log("Fetching Calendar successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      log(result["calendarProductList"].runtimeType.toString());

      try{
        List<dynamic> tempCalendarProducts = result["calendarProductList"];

        log("Fetching Calendar Dynamic with: ${tempCalendarProducts.length}");

        List<dynamic> tempDynamic = 
        tempCalendarProducts.map((e) => TrackedCalendarProduct.fromJson(e)).toList();

        List<TrackedCalendarProduct> calendarProducts = 
        tempDynamic.map((e) => e as TrackedCalendarProduct).toList();

        log("Fetching Calendar with: ${calendarProducts.length}");

        return calendarProducts;
      }catch(e){
        log(e.toString());
        return [];
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching Fail');
      return null;
    }
  }

  Future<dynamic> fetchExpense(String month, String year)async{
    //Code here 
    String monthYear = "$month-$year";

    log("Fetching Expense");
    final dynamic url = Uri.parse("$domainName/api/v1/product/getExpense/$monthYear");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      }
    );
    
    if (response.statusCode == 200) {
      log("Fetching Expense successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      log(result.runtimeType.toString());

      try{
        Expense currentExpense = Expense.fromJson(result);
        log("Limit: ${currentExpense.limit}");
        log("Total spend: ${currentExpense.totSpent}");
        log("Detailed spending: ${currentExpense.categories.toString()}");

        return currentExpense;
      }catch(e){
        log(e.toString());
        return null;
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching Fail');
      return null;
    }

  }
  
  Future<dynamic> fetchNotification()async{ 
    //Code here 
    log("Fetching Notifications");
    final dynamic url = Uri.parse("$domainName/api/v1/product/getNotification");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      }
    );
    
    if (response.statusCode == 200) {
      log("Fetching Notifications successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      log(result["notificationResponses"].runtimeType.toString());

      try{
        List<dynamic> tempNotifications = result["notificationResponses"];


        List<NotificationResponse> notifications = 
        tempNotifications.map((e) => e as NotificationResponse).toList();

        return notifications;
      }catch(e){
        log(e.toString());
        return [];
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching Fail');
      return null;
    }
  }

  Future<dynamic> getAllProductSameName(String productName)async{
    //Code here 
    log("Fetching Initial Inventory");
    
    final dynamic url = Uri.parse("$domainName/api/v1/product/getAllProductSameName/$productName");
    await tokenController.findToken();
    String accessToken = tokenController.getAccessToken().toString();
    log("Fetching with header $accessToken");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      }
    );
    
    if (response.statusCode == 200) {
      log("Fetching Inventory successfully");
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data["result"];

      log(result["responseList"].runtimeType.toString());

      try{
        dynamic tempTrackedUserProduct = result["responseList"];

        List<dynamic> tempDynamic = 
        tempTrackedUserProduct.map((e) => TrackedUserProductResponse.fromJson(e)).toList();


        List<TrackedUserProductResponse> trackedUserProductResponses = tempDynamic
        .map((e) => e as TrackedUserProductResponse).toList();
        

        return trackedUserProductResponses;
      }catch(e){
        log(e.toString());
        return null;
      }
      
    } 
    else if(response.statusCode == 401){
      log('Unauthorized 401');
      return requestController.sendRequestRefreshToken();
    }

    else {
      log('Fetching Fail');
      return null;
    }
  }
}