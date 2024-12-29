class WarningCategories {
  String? statusname;
  String? imagePath;
  String? categoryName;

  WarningCategories({this.statusname, this.imagePath, this.categoryName});

  WarningCategories.fromJson(Map<String, dynamic> json) {
    statusname = json['statusName'];
    imagePath = json['imagePath'];
    categoryName = json['categoryName'];
  }
}
