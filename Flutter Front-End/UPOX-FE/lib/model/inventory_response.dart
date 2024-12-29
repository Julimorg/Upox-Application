import 'package:first_app/model/track_user_product_response.dart';

class InventoryResponse {
  late List<TrackedUserProductResponse> trackedUserProductResponse;
  late Map<String, dynamic> suggestionCategories;

  InventoryResponse.initialize();
  InventoryResponse.fromJson(Map<String,dynamic> json, List<TrackedUserProductResponse> displayedProduct){
    trackedUserProductResponse = displayedProduct;
    suggestionCategories = json["suggestionCategories"];
  }
}