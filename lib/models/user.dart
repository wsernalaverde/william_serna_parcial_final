// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class User {
  String firstName = '';
  String lastName = '';
  String document = '';
  String address = '';
  String imageId = '';
  String imageFullPath = '';
  int userType = 1;
  int loginType = 0;
  String fullName = '';
  String id = '';
  String userName = '';
  String email = '';
  String countryCode = '';
  String phoneNumber = '';

  User({
    required this.firstName,
    required this.lastName,
    required this.document,
    required this.address,
    required this.imageId,
    required this.imageFullPath,
    required this.userType,
    required this.loginType,
    required this.fullName,
    required this.id,
    required this.userName,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
  });

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    document = json['document'];
    address = json['address'];
    imageId = json['imageId'];
    imageFullPath = json['imageFullPath'];
    userType = json['userType'];
    loginType = json['loginType'];
    fullName = json['fullName'];
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['document'] = this.document;
    data['address'] = this.address;
    data['imageId'] = this.imageId;
    data['imageFullPath'] = this.imageFullPath;
    data['userType'] = this.userType;
    data['loginType'] = this.loginType;
    data['fullName'] = this.fullName;
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['countryCode'] = this.countryCode;
    return data;
  }
}
