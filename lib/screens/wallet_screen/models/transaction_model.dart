// class TransactionModel {
//   List<Data>? data;
//   Links? links;
//   Meta? meta;
//   bool? status;
//   String? message;

//   TransactionModel(
//       {this.data, this.links, this.meta, this.status, this.message});

//   TransactionModel.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//     links = json['links'] != null ? new Links.fromJson(json['links']) : null;
//     meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
//     status = json['status'];
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     if (this.links != null) {
//       data['links'] = this.links!.toJson();
//     }
//     if (this.meta != null) {
//       data['meta'] = this.meta!.toJson();
//     }
//     data['status'] = this.status;
//     data['message'] = this.message;
//     return data;
//   }
// }

// class Data {
//   int? id;
//   String? txnRef;
//   String? amount;
//   String? userName;
//   String? transactionMode;
//   String? gatewayResponse;
//   String? provider;
//   String? status;
//   String? createdAt;

//   Data(
//       {this.id,
//       this.txnRef,
//       this.amount,
//       this.userName,
//       this.transactionMode,
//       this.gatewayResponse,
//       this.provider,
//       this.status,
//       this.createdAt});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     txnRef = json['txn_ref'];
//     amount = json['amount'];
//     userName = json['user_name'];
//     transactionMode = json['transaction_mode'];
//     gatewayResponse = json['gateway_response'];
//     provider = json['provider'];
//     status = json['status'];
//     createdAt = json['created_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['txn_ref'] = this.txnRef;
//     data['amount'] = this.amount;
//     data['user_name'] = this.userName;
//     data['transaction_mode'] = this.transactionMode;
//     data['gateway_response'] = this.gatewayResponse;
//     data['provider'] = this.provider;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     return data;
//   }
// }

// class Links {
//   String? first;
//   String? last;
//   Null? prev;
//   Null? next;

//   Links({this.first, this.last, this.prev, this.next});

//   Links.fromJson(Map<String, dynamic> json) {
//     first = json['first'];
//     last = json['last'];
//     prev = json['prev'];
//     next = json['next'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['first'] = this.first;
//     data['last'] = this.last;
//     data['prev'] = this.prev;
//     data['next'] = this.next;
//     return data;
//   }
// }

// class Meta {
//   int? currentPage;
//   int? from;
//   int? lastPage;
//   List<Links>? links;
//   String? path;
//   int? perPage;
//   int? to;
//   int? total;

//   Meta(
//       {this.currentPage,
//       this.from,
//       this.lastPage,
//       this.links,
//       this.path,
//       this.perPage,
//       this.to,
//       this.total});

//   Meta.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     from = json['from'];
//     lastPage = json['last_page'];
//     if (json['links'] != null) {
//       links = <Links>[];
//       json['links'].forEach((v) {
//         links!.add(new Links.fromJson(v));
//       });
//     }
//     path = json['path'];
//     perPage = json['per_page'];
//     to = json['to'];
//     total = json['total'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['current_page'] = this.currentPage;
//     data['from'] = this.from;
//     data['last_page'] = this.lastPage;
//     if (this.links != null) {
//       data['links'] = this.links!.map((v) => v.toJson()).toList();
//     }
//     data['path'] = this.path;
//     data['per_page'] = this.perPage;
//     data['to'] = this.to;
//     data['total'] = this.total;
//     return data;
//   }
// }

// class Links {
//   String? url;
//   String? label;
//   bool? active;

//   Links({this.url, this.label, this.active});

//   Links.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     label = json['label'];
//     active = json['active'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['url'] = this.url;
//     data['label'] = this.label;
//     data['active'] = this.active;
//     return data;
//   }
// }

import 'dart:convert';


TransactionModel transactionModelFromJson(String x) =>
    TransactionModel.fromJson(json.decode(x));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());


class TransactionModel {
  final List<TransactionData> data;
  final PaginationLinks? links;
  final PaginationMeta? meta;
  final bool? status;
  final String? message;

  TransactionModel({
    required this.data,
    this.links,
    this.meta,
    this.status,
    this.message,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => TransactionData.fromJson(e))
          .toList(),
      links: json['links'] != null ? PaginationLinks.fromJson(json['links']) : null,
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      if (links != null) 'links': links!.toJson(),
      if (meta != null) 'meta': meta!.toJson(),
      'status': status,
      'message': message,
    };
  }
}

class TransactionData {
  final int id;
  final String txnRef;
  final String amount;
  final String userName;
  final String transactionMode;
  final String gatewayResponse;
  final String provider;
  final String status;
  final String createdAt;

  TransactionData({
    required this.id,
    required this.txnRef,
    required this.amount,
    required this.userName,
    required this.transactionMode,
    required this.gatewayResponse,
    required this.provider,
    required this.status,
    required this.createdAt,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
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

  Map<String, dynamic> toJson() {
    return {
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
}

class PaginationLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  PaginationLinks({this.first, this.last, this.prev, this.next});

  factory PaginationLinks.fromJson(Map<String, dynamic> json) {
    return PaginationLinks(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'last': last,
      'prev': prev,
      'next': next,
    };
  }
}

class PaginationMeta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<MetaLink>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  PaginationMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => MetaLink.fromJson(e))
          .toList(),
      path: json['path'],
      perPage: json['per_page'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'from': from,
      'last_page': lastPage,
      if (links != null) 'links': links!.map((e) => e.toJson()).toList(),
      'path': path,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }
}

class MetaLink {
  final String? url;
  final String? label;
  final bool? active;

  MetaLink({this.url, this.label, this.active});

  factory MetaLink.fromJson(Map<String, dynamic> json) {
    return MetaLink(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
