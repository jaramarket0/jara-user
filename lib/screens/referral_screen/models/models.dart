import 'dart:convert';

ReferalModel referalModelFromJson(String x)=> ReferalModel.fromJson(jsonDecode(x));

class ReferalModel {
  bool? status;
  String? message;
  List<Data>? data;

  ReferalModel({this.status, this.message, this.data});

  ReferalModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? firstname;
  String? lastname;
  String? email;
  String? phoneNumber;
  String? profilePicture;
  Country? country;
  String? referralCode;
  int? referralCount;
  String? createdAt;

  Data(
      {this.id,
      this.name,
      this.firstname,
      this.lastname,
      this.email,
      this.phoneNumber,
      this.profilePicture,
      this.country,
      this.referralCode,
      this.referralCount,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    profilePicture = json['profile_picture'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    referralCode = json['referral_code'];
    referralCount = json['referral_count'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['profile_picture'] = this.profilePicture;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    data['referral_code'] = this.referralCode;
    data['referral_count'] = this.referralCount;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Country {
  int? id;
  String? name;
  String? code;

  Country({this.id, this.name, this.code});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}
