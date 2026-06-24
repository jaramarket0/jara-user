import 'dart:convert';
import 'package:jara_market/services/api_service.dart';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) =>
    json.encode(data.toJson());





class ProfileModel {
 final bool status;
 final String message;
 final ProfileData data;

  ProfileModel({required this.status,required this.message,required this.data});

  ProfileModel.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        data = json['data'] != null ? ProfileData.fromJson(json['data']) : ProfileData();

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (data != null) 'data': data.toJson(),
    };
  }
}

class ProfileData {
  int? id;
  String? name;
  String? firstname;
  String? lastname;
  String? email;
  String? phoneNumber;
  bool? emailVerified;
  String? role;
  String? referralCode;
  String? profilePicture;
  dynamic referrerId;        // Changed from Null? to dynamic
  dynamic referralCount;     // Changed from Null? to dynamic
  bool? hasPin;
  dynamic isActive;          // Changed from Null? to dynamic
  String? createdAt;
  String? lastLogin;
  Wallet? wallet;
  List<dynamic>? favorites;  // Changed from List<Null> to List<dynamic>
  List<ContactAddress>? contactAddress;
  

  ProfileData({
    this.id,
    this.name,
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.emailVerified,
    this.role,
    this.referralCode,
    this.referrerId,
    this.referralCount,
    this.hasPin,
    this.isActive,
    this.createdAt,
    this.lastLogin,
    this.wallet,
    this.favorites,
    this.contactAddress,
    this.profilePicture,
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    emailVerified = json['email_verified'];
    role = json['role'];
    referralCode = json['referral_code'];
    referrerId = json['referrer_id'];
    referralCount = json['referral_count'];
    hasPin = json['has_pin'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    lastLogin = json['last_login'];
    profilePicture = getImageUrl(json['profile_picture']);
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    final rawFavorites = json['favorites'];
    favorites = rawFavorites is List ? List<dynamic>.from(rawFavorites) : null;
    contactAddress = json['contact_address'] != null
        ? (json['contact_address'] as List)
            .map((i) => ContactAddress.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone_number': phoneNumber,
      'email_verified': emailVerified,
      'role': role,
      'referral_code': referralCode,
      'referrer_id': referrerId,
      'referral_count': referralCount,
      'has_pin': hasPin,
      'is_active': isActive,
      'created_at': createdAt,
      'last_login': lastLogin,
      'profile_picture': profilePicture,
      if (wallet != null) 'wallet': wallet!.toJson(),
      if (favorites != null) 'favorites': favorites,
    };
  }
}

class Wallet {
  int? id;
  String? balance;

  Wallet({this.id, this.balance});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
    };
  }
}

class ContactAddress {
  int? id;
  String? country;
  String? state;
  String? lga;
  String? contactAddress;
  String? phoneNumber;
  bool? isDefault;
  String? createdAt;
  

  ContactAddress(
      {this.id,
      this.country,
      this.state,
      this.lga,
      this.contactAddress,
      this.phoneNumber,
      this.isDefault,
      this.createdAt});

  ContactAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    state = json['state'];
    lga = json['lga'];
    contactAddress = json['contact_address'];
    phoneNumber = json['phone_number'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country'] = this.country;
    data['state'] = this.state;
    data['lga'] = this.lga;
    data['contact_address'] = this.contactAddress;
    data['phone_number'] = this.phoneNumber;
    data['is_default'] = this.isDefault;
    data['created_at'] = this.createdAt;
    return data;
  }
}


/// my data for ekweredaniel8@gmail.com
//{
//     "status": true,
//     "message": "An OTP has been sent to your email address. It expires after 15 minutes.",
//     "data": {
//         "id": 2,
//         "name": "Daniel Ekwere",
//         "firstname": "Daniel",
//         "lastname": "Ekwere",
//         "email": "ekweredaniel8@gmail.com",
//         "phone_number": "07043194111",
//         "email_verified": false,
//         "role": "customer",
//         "referral_code": "pOXWRjrOoj",
//         "referrer_id": null,
//         "referral_count": null,
//         "has_pin": false,
//         "is_active": null,
//         "created_at": "2025-05-28 09:12:59",
//         "last_login": "2025-05-28 09:12:59",
//         "wallet": {
//             "id": 2,
//             "balance": "0.00"
//         },
//         "favorites": []
//     }
// }