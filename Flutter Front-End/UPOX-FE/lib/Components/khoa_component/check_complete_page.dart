class CheckCompletePage {
  bool _isFirstPageSucceed = false;
  bool _isSecPageSucceed = false;
  bool _isThirdPageSucced = false;

  void completeFirstPage(bool status){
    _isFirstPageSucceed = status;
  }
  void completeSecPage(bool status){
    _isSecPageSucceed = status;
  }
  void completeThirdPage(bool status){
    _isThirdPageSucced = status;
  }

  bool getStatusFirstPage(){
    return _isFirstPageSucceed;
  }
  bool getStatusSecPage(){
    return _isSecPageSucceed;
  }
  bool getStatusThirdPage(){
    return _isThirdPageSucced;
  }
}