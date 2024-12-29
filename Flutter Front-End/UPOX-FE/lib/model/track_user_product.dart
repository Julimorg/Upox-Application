import 'dart:developer';

class TrackedUserProduct {
  String? _productName;
  String? _dateBought;
  String? _expiryDate;
  int? _peopleUse;
  int? _volume;
  int? _cost;
  String? _frequency;
  String? _wayPreserve;
  bool _isOpened = false;
  String? _dateOpen;
  int? _numProductOpened;
  int? _quantity;
  String? _wayPayment;
  String? _imagePath;
  String? _volumeUnit;

  //Constructor
  TrackedUserProduct();

  Map<String,dynamic> toJson(){
    Map<String,dynamic> json = {};
    json["productName"] = _productName;
    json["quantity"] = _quantity;
    json["dateBought"] = _dateBought;
    json["expiryDate"] = _expiryDate;
    json["peopleUse"] = _peopleUse;
    json["volume"] = _volume;
    json["cost"] = _cost;
    json["frequency"] = _frequency;
    json["wayPreserve"] = _wayPreserve;
    json["opened"] = _isOpened;

    // log("opened: $_isOpened");
    return json;
  }

  //ProductName - productName
  String? getProductName() {
    return _productName;
  }

  void setProductName(var productName) {
    _productName = productName;
  }

  //DateBought - dateBought
  String? getDateBought() {
    return _dateBought;
  }

  void setDateBought(var dateBought) {
    _dateBought = dateBought;
  }

  //ExpiryDate - expiryDate
  String? getExpiryDate() {
    return _expiryDate;
  }

  void setExpiryDate(var expiryDate) {
    _expiryDate = expiryDate;
  }

  //PeopleUse - peopleUse
  int? getPeopleUse() {
    return _peopleUse;
  }

  void setPeopleUse(var peopleUse) {
    _peopleUse = peopleUse;
  }

  //Volume - volume
  int? getVolume() {
    return _volume;
  }

  void setVolume(var volume) {
    _volume = volume;
  }

  //Cost - cost
  int? getCost() {
    return _cost;
  }

  void setCost(var cost) {
    _cost = cost;
  }

  //Frequency - frequency
  String? getFrequency() {
    return _frequency;
  }

  void setFrequency(var frequency) {
    _frequency = frequency;
  }

  //WayPreserve - wayPreserve
  String? getWayPreserve() {
    return _wayPreserve;
  }

  void setWayPreserve(var wayPreserve) {
    _wayPreserve = wayPreserve;
  }

  //IsOpened - isOpened
  bool isOpened() {
    return _isOpened;
  }

  void setOpened(var isOpened) {
    _isOpened = isOpened;
  }

  //DateOpen - dateOpen
  String? getDateOpen() {
    return _dateOpen;
  }

  void setDateOpen(var dateOpen) {
    _dateOpen = dateOpen;
  }

  //NumProductOpened - numProductOpened
  int? getNumProductOpened() {
    return _numProductOpened;
  }

  void setNumProductOpened(var numProductOpened) {
    _numProductOpened = numProductOpened;
  }

  //Quantity - quantity
  int? getQuantity() {
    return _quantity;
  }

  void setQuantity(var quantity) {
    _quantity = quantity;
  }

  //WayPayment - wayPayment
  String? getWayPayment() {
    return _wayPayment;
  }

  void setWayPayment(var wayPayment) {
    _wayPayment = wayPayment;
  }

  //ImagePath - imagePath
  String? getImagePath() {
    return _imagePath;
  }

  void setImagePath(var imagePath) {
    _imagePath = imagePath;
  }

  //VolumeUnit - volumeUnit
  String? getVolumeUnit() {
    return _volumeUnit;
  }

  void setVolumeUnit(var volumeUnit) {
    _volumeUnit = volumeUnit;
  }
}
