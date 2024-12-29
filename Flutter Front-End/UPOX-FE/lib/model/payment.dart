class Payment {
  String? priceOfProduct;
  String? dateBought;

  Payment.initialize();
  Payment(this.priceOfProduct, this.dateBought);

  //GET
  String getPriceOfProduct(){
    return priceOfProduct.toString();
  }
  String getDateBought(){
    return dateBought.toString();
  }

  //SET
  void setPriceOfProduct(String priceOfProduct_){
    priceOfProduct = priceOfProduct_;
  }
  void setDateBought(String dateBought_){
    dateBought = dateBought_;
  }
}