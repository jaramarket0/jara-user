import 'dart:convert';

StateModel stateModelFromJson(String str) => StateModel.fromJson(json.decode(str));
String stateModelToJson(StateModel data) => json.encode(data.toJson());

class StateModel {
  bool? status;
  String? message;
  List<StateData>? data;

  StateModel({this.status, this.message, this.data});

  StateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StateData>[];
      json['data'].forEach((v) {
        data!.add(new StateData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StateData {
  int? id;
  String? name;
  List<Lgas>? lgas;

  StateData({this.id, this.name, this.lgas});

  StateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['lgas'] != null) {
      lgas = <Lgas>[];
      json['lgas'].forEach((v) {
        lgas!.add(new Lgas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.lgas != null) {
      data['lgas'] = this.lgas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lgas {
  int? id;
  String? name;

  Lgas({this.id, this.name});

  Lgas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
