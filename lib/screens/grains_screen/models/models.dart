import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:jara_market/services/api_service.dart';

IngredientResorceModel ingredientResorceModelFromJson(String str) =>
    IngredientResorceModel.fromJson(jsonDecode(str));

String ingredientResorceModelToJson(IngredientResorceModel data) =>
    jsonEncode(data.toJson());

class IngredientResorceModel {
  String? message;
  List<Data>? data;

  IngredientResorceModel({this.message, this.data});

  IngredientResorceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    final outerData = json['data'];
    final list = (outerData is Map) ? outerData['data'] : outerData;
    if (list != null) {
      data = <Data>[];
      list.forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  String? description;
  double? price;
  double? basePrice;
  String? unit;
  String? stock;
  String? imageUrl;
  String? createdAt;
  RxInt? quantity = 1.obs;
  RxBool? isSelected = false.obs;
  TextEditingController controller = TextEditingController();

  Data({
    this.id,
    this.name,
    this.description,
    this.price,
    this.basePrice,
    this.unit,
    this.stock,
    this.imageUrl,
    this.createdAt,
    bool isSelected = false,
    int quantity = 1,
  })  : quantity = RxInt(quantity),
        isSelected = RxBool(isSelected);

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = double.tryParse(json['price']?.toString() ?? '0');
    basePrice = double.tryParse(json['price']?.toString() ?? '0');
    unit = json['unit'];
    stock = json['stock']?.toString(); // ← int → String
    imageUrl = getImageUrl(json['image_url']);
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['stock'] = this.stock;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    return data;
  }
}
