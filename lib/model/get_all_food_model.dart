// To parse this JSON data, do
//
//     final getAllFoodModel = getAllFoodModelFromJson(jsonString);

import 'dart:convert';

GetAllFoodModel getAllFoodModelFromJson(String str) => GetAllFoodModel.fromJson(json.decode(str));

String getAllFoodModelToJson(GetAllFoodModel data) => json.encode(data.toJson());

class GetAllFoodModel {
  GetAllFoodModel({
    this.message,
    this.data,
  });

  String message;
  List<FoodData> data;

  factory GetAllFoodModel.fromJson(Map<String, dynamic> json) => GetAllFoodModel(
    message: json["message"],
    data: List<FoodData>.from(json["data"].map((x) => FoodData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class FoodData {
  FoodData({
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

  factory FoodData.fromJson(Map<String, dynamic> json) => FoodData(
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
