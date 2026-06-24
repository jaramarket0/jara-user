import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) =>
    json.encode(data.toJson());





class LoginModel {
 final bool status;
 final String message;
 final LoginData data;

  LoginModel({required this.status,required this.message,required this.data});

  LoginModel.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        data = json['data'] != null ? LoginData.fromJson(json['data']) : LoginData();

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (data != null) 'data': data.toJson(),
    };
  }
}

class LoginData {
  int? id;
  String? name;
  String? firstname;
  String? lastname;
  String? email;
  String? phoneNumber;
  bool? emailVerified;
  String? role;
  String? referralCode;
  dynamic referrerId;        // Changed from Null? to dynamic
  dynamic referralCount;     // Changed from Null? to dynamic
  bool? hasPin;
  dynamic isActive;          // Changed from Null? to dynamic
  String? createdAt;
  String? lastLogin;
  Wallet? wallet;
 // List<dynamic>? favorites;  // Changed from List<Null> to List<dynamic>
  String? token; // Added token field
  String? token_type; // Added token_type field
  int? expires_in; // Added expires_in field

  LoginData({
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
   // this.favorites,
    this.token,
    this.token_type,
    this.expires_in,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
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
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
   // favorites = json['favorites'];
    token = json['token'];
    token_type = json['token_type'];
    expires_in = json['expires_in'];
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
      'token': token,
      'token_type': token_type,
      'expires_in': expires_in,
      if (wallet != null) 'wallet': wallet!.toJson(),
    //  if (favorites != null) 'favorites': favorites,
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