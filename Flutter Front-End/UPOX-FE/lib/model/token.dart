class Token {
  String? accessToken;
  String? refreshToken;

  Token(this.accessToken, this.refreshToken);

  void setAccessToken(String accessToken_){
    this.accessToken = accessToken_;
  }

  void setRefreshToken(String refreshToken_){
    this.refreshToken = refreshToken_;
  }

  String? getAccessToken(){
    return this.accessToken;
  }

  String? getRefreshToken(){
    return this.refreshToken;
  }
}