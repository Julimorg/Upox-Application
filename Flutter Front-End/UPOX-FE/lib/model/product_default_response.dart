class ProductDefaultResponse {
  String? productName;
  String? defCost;
  String? defVolume;
  String? defExpiryDate;
  String? defPreserveWay;
  String? imagePath;

  ProductDefaultResponse({this.productName, this.defCost, this.defVolume, this.defExpiryDate
  , this.defPreserveWay, this.imagePath});

  ProductDefaultResponse.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    defCost = json['defCost'];
    defVolume = json['defVolume'];
    defExpiryDate = json['defExpiryDate'];
    defPreserveWay = json['defPreserveWay']; 
    imagePath = json['imagePath'];
  }
}