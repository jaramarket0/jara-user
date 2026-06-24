import 'dart:convert';

SingleTransactionModel singleTransactionModelFromJson(String str) =>
    SingleTransactionModel.fromJson(json.decode(str));

String singleTransactionModelToJson(SingleTransactionModel data) =>
    json.encode(data.toJson());

class SingleTransactionModel {
  bool? status;
  String? message;
  SingleTransactionData? data;

  SingleTransactionModel({this.status, this.message, this.data});

  factory SingleTransactionModel.fromJson(Map<String, dynamic> json) {
    return SingleTransactionModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? SingleTransactionData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class SingleTransactionData {
  int? id;
  String? txnRef;
  String? amount;
  String? userName;
  String? transactionMode;
  String? gatewayResponse;
  String? provider;
  String? status;
  String? createdAt;

  SingleTransactionData({
    this.id,
    this.txnRef,
    this.amount,
    this.userName,
    this.transactionMode,
    this.gatewayResponse,
    this.provider,
    this.status,
    this.createdAt,
  });

  factory SingleTransactionData.fromJson(Map<String, dynamic> json) {
    return SingleTransactionData(
      id: json['id'],
      txnRef: json['txn_ref'],
      amount: json['amount'],
      userName: json['user_name'],
      transactionMode: json['transaction_mode'],
      gatewayResponse: json['gateway_response'],
      provider: json['provider'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'txn_ref': txnRef,
        'amount': amount,
        'user_name': userName,
        'transaction_mode': transactionMode,
        'gateway_response': gatewayResponse,
        'provider': provider,
        'status': status,
        'created_at': createdAt,
      };
}
