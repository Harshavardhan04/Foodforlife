// To parse this JSON data, do
//
//     final sendOtpModel = sendOtpModelFromJson(jsonString);

import 'dart:convert';

SendOtpModel sendOtpModelFromJson(String str) => SendOtpModel.fromJson(json.decode(str));

String sendOtpModelToJson(SendOtpModel data) => json.encode(data.toJson());

class SendOtpModel {
  SendOtpModel({
    this.message,
    this.data,
  });

  String message;
  Data data;

  factory SendOtpModel.fromJson(Map<String, dynamic> json) => SendOtpModel(
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
    this.authToken,
  });

  String id;
  String mobileno;
  String userOtp;
  String authToken;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    mobileno: json["mobileno"],
    userOtp: json["user_otp"],
    authToken: json["auth_token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobileno": mobileno,
    "user_otp": userOtp,
    "auth_token": authToken,
  };
}
