import 'dart:convert';


OrderSuccessModel orderSuccessModelFromJson(String str) =>
    OrderSuccessModel.fromJson(jsonDecode(str));

String orderSuccessModelToJson(OrderSuccessModel data) =>
    jsonEncode(data.toJson());


class OrderSuccessModel {
  bool? status;
  String? message;
  OrderData? data;

  OrderSuccessModel({this.status, this.message, this.data});

  OrderSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new OrderData.fromJson(json['data']) : null;
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

class OrderData {
  int? id;
  String? orderDate;
  String? deliveryType;
  String? shippingFee;
  int? serviceCharge;
  int? vat;
  int? total;
  String? status;
  Address? address;
  List<Products>? products;
  List<Ingredients>? ingredients;
  String? createdAt;

  OrderData(
      {this.id,
      this.orderDate,
      this.deliveryType,
      this.shippingFee,
      this.serviceCharge,
      this.vat,
      this.total,
      this.status,
      this.address,
      this.products,
      this.ingredients,
      this.createdAt});

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderDate = json['order_date'];
    deliveryType = json['delivery_type'];
    shippingFee = json['shipping_fee'];
    serviceCharge = json['service_charge'];
    vat = json['vat'];
    total = json['total'];
    status = json['status'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    if (json['ingredients'] != null) {
      ingredients = <Ingredients>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(new Ingredients.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_date'] = this.orderDate;
    data['delivery_type'] = this.deliveryType;
    data['shipping_fee'] = this.shippingFee;
    data['service_charge'] = this.serviceCharge;
    data['vat'] = this.vat;
    data['total'] = this.total;
    data['status'] = this.status;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.ingredients != null) {
      data['ingredients'] = this.ingredients!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Address {
  int? id;
  String? country;
  String? state;
  String? lga;
  String? contactAddress;
  String? phoneNumber;
  String? isDefault;
  String? createdAt;

  Address(
      {this.id,
      this.country,
      this.state,
      this.lga,
      this.contactAddress,
      this.phoneNumber,
      this.isDefault,
      this.createdAt});

  Address.fromJson(Map<String, dynamic> json) {
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

class Products {
  int? id;
  String? name;
  String? price;
  String? imageUrl;
  String? status;

  Products({this.id, this.name, this.price, this.imageUrl, this.status});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    imageUrl = json['image_url'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['image_url'] = this.imageUrl;
    data['status'] = this.status;
    return data;
  }
}

class Ingredients {
  int? id;
  String? name;
  String? price;
  String? unit;
  String? imageUrl;
  String? status;

  Ingredients(
      {this.id, this.name, this.price, this.unit, this.imageUrl, this.status});

  Ingredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    unit = json['unit'];
    imageUrl = json['image_url'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['image_url'] = this.imageUrl;
    data['status'] = this.status;
    return data;
  }
}
