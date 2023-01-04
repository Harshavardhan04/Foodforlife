// To parse this JSON data, do
//
//     final reSendOtpModel = reSendOtpModelFromJson(jsonString);

import 'dart:convert';

ReSendOtpModel reSendOtpModelFromJson(String str) => ReSendOtpModel.fromJson(json.decode(str));

String reSendOtpModelToJson(ReSendOtpModel data) => json.encode(data.toJson());

class ReSendOtpModel {
  ReSendOtpModel({
    this.message,
    this.data,
  });

  String message;
  Data data;

  factory ReSendOtpModel.fromJson(Map<String, dynamic> json) => ReSendOtpModel(
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
    this.mobileno,
    this.userOtp,
  });

  String id;
  String mobileno;
  String userOtp;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    mobileno: json["mobileno"],
    userOtp: json["user_otp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobileno": mobileno,
    "user_otp": userOtp,
  };
}
