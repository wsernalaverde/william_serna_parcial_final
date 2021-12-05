// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

import 'package:william_serna_parcial_final/models/user.dart';

class Token {
  String token = '';
  String expiration = '';
  User user = User(
      firstName: '',
      lastName: '',
      document: '',
      address: '',
      imageId: '',
      imageFullPath: '',
      userType: 0,
      loginType: 0,
      fullName: '',
      id: '',
      userName: '',
      email: '',
      countryCode: '57',
      phoneNumber: '');

  Token({required this.token, required this.expiration, required this.user});

  Token.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expiration'] = this.expiration;
    data['user'] = this.user.toJson();
    return data;
  }
}
