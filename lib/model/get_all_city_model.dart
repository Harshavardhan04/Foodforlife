// To parse this JSON data, do
//
//     final getAllCityModel = getAllCityModelFromJson(jsonString);

import 'dart:convert';

GetAllCityModel getAllCityModelFromJson(String str) => GetAllCityModel.fromJson(json.decode(str));

String getAllCityModelToJson(GetAllCityModel data) => json.encode(data.toJson());

class GetAllCityModel {
  GetAllCityModel({
    this.message,
    this.data,
  });

  String message;
  List<Datum> data;

  factory GetAllCityModel.fromJson(Map<String, dynamic> json) => GetAllCityModel(
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
