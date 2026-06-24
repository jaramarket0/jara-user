// // To parse this JSON data, do
// //
// //     final categories = categoriesFromJson(jsonString);

import 'dart:convert';
import 'package:jara_market/services/api_service.dart';

 Categories categoriesFromJson(String str) => Categories.fromJson(json.decode(str));

 String categoriesToJson(Categories data) => json.encode(data.toJson());

// class Categories {
//     final int? id;
//     final String? name;
//     final String? description;
//     final DateTime? createdAt;
//     final DateTime? updatedAt;
//     final List<Product>? products;

//     Categories({
//         this.id,
//         this.name,
//         this.description,
//         this.createdAt,
//         this.updatedAt,
//         this.products,
//     });

//     factory Categories.fromJson(Map<String, dynamic> json) => Categories(
//         id: json["id"],
//         name: json["name"],
//         description: json["description"],
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//         products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "description": description,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
//     };
// }

// class Product {
//     final int? id;
//     final String? name;
//     final String? description;
//     final String? price;
//     final dynamic discountPrice;
//     final String? stock;
//     final dynamic rating;
//     final String? preparationSteps;
//     final dynamic imageUrl;
//     final DateTime? createdAt;
//     final DateTime? updatedAt;
//     final Pivot? pivot;

//     Product({
//         this.id,
//         this.name,
//         this.description,
//         this.price,
//         this.discountPrice,
//         this.stock,
//         this.rating,
//         this.preparationSteps,
//         this.imageUrl,
//         this.createdAt,
//         this.updatedAt,
//         this.pivot,
//     });

//     factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json["id"],
//         name: json["name"],
//         description: json["description"],
//         price: json["price"],
//         discountPrice: json["discount_price"],
//         stock: json["stock"],
//         rating: json["rating"],
//         preparationSteps: json["preparation_steps"],
//         imageUrl: json["image_url"],
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//         pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "description": description,
//         "price": price,
//         "discount_price": discountPrice,
//         "stock": stock,
//         "rating": rating,
//         "preparation_steps": preparationSteps,
//         "image_url": imageUrl,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "pivot": pivot?.toJson(),
//     };
// }

// class Pivot {
//     final String? categoryId;
//     final String? productId;

//     Pivot({
//         this.categoryId,
//         this.productId,
//     });

//     factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
//         categoryId: json["category_id"],
//         productId: json["product_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "category_id": categoryId,
//         "product_id": productId,
//     };
// }


class Categories {
  String? message;
  List<Category>? data;

  Categories({this.message, this.data});

  Categories.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Category>[];
      json['data'].forEach((v) {
        data!.add(new Category.fromJson(v));
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

class Category {
  int? id;
  String? name;
  String? description;
  List<Products>? products;
  String? createdAt;

  Category({this.id, this.name, this.description, this.products, this.createdAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Products {
  int? id;
  String? name;
  String? description;
  String? price;
  String? discountPrice;
  bool? isStatePrice;
  int? stock;
  List<String>? preparationSteps;
  String? rating;
  String? imageUrl;
  List<Ingredients>? ingredients;
  String? createdAt;

  Products(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.discountPrice,
      this.isStatePrice,
      this.stock,
      this.preparationSteps,
      this.rating,
      this.imageUrl,
      this.ingredients,
      this.createdAt});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    discountPrice = json['discount_price'];
    isStatePrice = json['is_state_price'];
    stock = json['stock'];
    final rawSteps = json['preparation_steps'];
    preparationSteps = rawSteps is List ? List<String>.from(rawSteps) : null;
    rating = json['rating']?.toString();
    imageUrl = getImageUrl(json['image_url']);
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
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['discount_price'] = this.discountPrice;
    data['is_state_price'] = this.isStatePrice;
    data['stock'] = this.stock;
    data['preparation_steps'] = this.preparationSteps;
    data['rating'] = this.rating;
    data['image_url'] = this.imageUrl;
    if (this.ingredients != null) {
      data['ingredients'] = this.ingredients!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Ingredients {
  int? id;
  String? name;
  String? description;
  String? price;
  String? discountedPrice;
  bool? isStatePrice;
  String? unit;
  int? stock;
  String? imageUrl;
  String? createdAt;

  Ingredients(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.discountedPrice,
      this.isStatePrice,
      this.unit,
      this.stock,
      this.imageUrl,
      this.createdAt});

  Ingredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    discountedPrice = json['discounted_price'];
    isStatePrice = json['is_state_price'];
    unit = json['unit'];
    stock = json['stock'];
    imageUrl = getImageUrl(json['image_url']);
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['discounted_price'] = this.discountedPrice;
    data['is_state_price'] = this.isStatePrice;
    data['unit'] = this.unit;
    data['stock'] = this.stock;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    return data;
  }
}


