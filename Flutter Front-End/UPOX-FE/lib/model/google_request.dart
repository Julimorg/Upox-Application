class GoogleRequest {
  String? _username;
  String? _email;
  String? _familyName;
  String? _givenName;
  String? _picture;
  String? _locale;
  bool? _verified;
  String? _googleToken;

  String? get username => _username;
  void setusername(String? value) {
    _username = value;
  }

  String? get email => _email;
  void setemail(String? value) {
    _email = value;
  }

  String? get familyName => _familyName;
  void setfamilyName(String? value) {
    _familyName = value;
  }

  String? get givenName => _givenName;
  void setgivenName(String? value) {
    _givenName = value;
  }

  String? get picture => _picture;
  void setpicture(String? value) {
    _picture = value;
  }

  String? get locale => _locale;
  void setlocale(String? value) {
    _locale = value;
  }

  String? get googleToken => _googleToken;
  void setgoogleToken(String? value) {
    _googleToken = value;
  }

  bool? get verified => _verified;
  void setverified(String? value) {
    _verified = value == "true" ? true : false;
  }
}
