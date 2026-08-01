import 'dart:convert';

AdvertisementModel advertisementModelFromJson(String x) =>
    AdvertisementModel.fromJson(jsonDecode(x));

class AdvertisementModel {
  final bool status;
  final String message;
  final List<Advertisement> data;

  AdvertisementModel({required this.status, required this.message, required this.data});

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Advertisement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Advertisement {
  final int id;
  final String type;
  final String? value;
  final String status;
  final String? image;
  final List<dynamic> ingredientIds;

  Advertisement({
    required this.id,
    required this.type,
    this.value,
    required this.status,
    this.image,
    this.ingredientIds = const [],
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'],
      type: json['type'] ?? 'info',
      value: json['value']?.toString(),
      status: json['status'] ?? 'active',
      image: json['image'],
      ingredientIds: json['ingredient_ids'] ?? [],
    );
  }
}
