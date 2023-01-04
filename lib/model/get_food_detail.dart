// To parse this JSON data, do
//
//     final model = modelFromJson(jsonString);

import 'dart:convert';

Model modelFromJson(String str) => Model.fromJson(json.decode(str));

String modelToJson(Model data) => json.encode(data.toJson());

class Model {
  Model({
    this.message,
    this.data,
  });

  String message;
  Data data;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.userId,
    this.cityId,
    this.name,
    this.mobileno,
    this.address,
    this.type,
    this.typeFoodAvailable,
    this.clickOpen,
    this.city,
    this.userMobileno,
  });

  String id;
  String userId;
  String cityId;
  String name;
  String mobileno;
  String address;
  String type;
  String typeFoodAvailable;
  int clickOpen;
  String city;
  String userMobileno;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    cityId: json["city_id"],
    name: json["name"],
    mobileno: json["mobileno"],
    address: json["address"],
    type: json["type"],
    typeFoodAvailable: json["type_food_available"],
    clickOpen: json["click_open"],
    city: json["city"],
    userMobileno: json["user_mobileno"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "city_id": cityId,
    "name": name,
    "mobileno": mobileno,
    "address": address,
    "type": type,
    "type_food_available": typeFoodAvailable,
    "click_open": clickOpen,
    "city": city,
    "user_mobileno": userMobileno,
  };
}
