// To parse this JSON data, do
//
//     final food = foodFromJson(jsonString);

import 'dart:convert';

List<Food> foodFromJson(String str) => List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));

String foodToJson(List<Food> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Food {
    final int? id;
    final String? name;
    final String? description;
    final String? price;
    final dynamic discountPrice;
    final String? stock;
    final dynamic rating;
    final String? preparationSteps;
    final dynamic imageUrl;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final List<Ingredient>? ingredients;

    Food({
        this.id,
        this.name,
        this.description,
        this.price,
        this.discountPrice,
        this.stock,
        this.rating,
        this.preparationSteps,
        this.imageUrl,
        this.createdAt,
        this.updatedAt,
        this.ingredients,
    });

    factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        discountPrice: json["discount_price"],
        stock: json["stock"],
        rating: json["rating"],
        preparationSteps: json["preparation_steps"],
        imageUrl: json["image_url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        ingredients: json["ingredients"] == null ? [] : List<Ingredient>.from(json["ingredients"]!.map((x) => Ingredient.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "discount_price": discountPrice,
        "stock": stock,
        "rating": rating,
        "preparation_steps": preparationSteps,
        "image_url": imageUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "ingredients": ingredients == null ? [] : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
    };
}

class Ingredient {
    final int? id;
    final String? name;
    final String? description;
    final String? price;
    final String? discountedPrice;
    final String? unit;
    final String? stock;
    final String? imageUrl;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Pivot? pivot;

    Ingredient({
        this.id,
        this.name,
        this.description,
        this.price,
        this.discountedPrice,
        this.unit,
        this.stock,
        this.imageUrl,
        this.createdAt,
        this.updatedAt,
        this.pivot,
    });

    factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        discountedPrice: json["discounted_price"],
        unit: json["unit"],
        stock: json["stock"],
        imageUrl: json["image_url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "discounted_price": discountedPrice,
        "unit": unit,
        "stock": stock,
        "image_url": imageUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
    };
}

class Pivot {
    final String? productId;
    final String? ingredientId;
    final String? quantity;
    final String? unit;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Pivot({
        this.productId,
        this.ingredientId,
        this.quantity,
        this.unit,
        this.createdAt,
        this.updatedAt,
    });

    factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        productId: json["product_id"],
        ingredientId: json["ingredient_id"],
        quantity: json["quantity"],
        unit: json["unit"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "ingredient_id": ingredientId,
        "quantity": quantity,
        "unit": unit,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
