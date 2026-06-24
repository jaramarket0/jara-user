import 'dart:convert';

List<Favourite> favouriteFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Favourite>.from(jsonData["data"].map((x) => Favourite.fromJson(x)));
}

String favouriteToJson(List<Favourite> data) =>
    json.encode(data.map((x) => x.toJson()).toList());

class Favourite {
  final int id;
  final String productId;
  final String product;
  final String createdAt;

  Favourite({
    required this.id,
    required this.productId,
    required this.product,
    required this.createdAt,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) => Favourite(
        id: json["id"],
        productId: json["product_id"],
        product: json["product"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "product": product,
        "created_at": createdAt,
      };
}
