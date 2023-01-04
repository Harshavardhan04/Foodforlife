// To parse this JSON data, do
//
//     final getUserActiveFoodModel = getUserActiveFoodModelFromJson(jsonString);

import 'dart:convert';

GetUserActiveFoodModel getUserActiveFoodModelFromJson(String str) => GetUserActiveFoodModel.fromJson(json.decode(str));

String getUserActiveFoodModelToJson(GetUserActiveFoodModel data) => json.encode(data.toJson());

class GetUserActiveFoodModel {
  GetUserActiveFoodModel({
    this.message,
    this.data,
  });

  String message;
  Data data;

  factory GetUserActiveFoodModel.fromJson(Map<String, dynamic> json) => GetUserActiveFoodModel(
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
    "city": city,
    "user_mobileno": userMobileno,
  };
}
