import 'dart:convert';

// Function to parse JSON string into WalletModel
WalletModel walletModelFromJson(String str) =>
    WalletModel.fromJson(json.decode(str));

// Function to convert WalletModel back to JSON string
String walletModelToJson(WalletModel data) =>
    json.encode(data.toJson());

class WalletModel {
  bool? status;
  String? message;
  Data? data;

  WalletModel({this.status, this.message, this.data});

  WalletModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? balance;

  Data({this.id, this.balance});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['balance'] = this.balance;
    return data;
  }
}
