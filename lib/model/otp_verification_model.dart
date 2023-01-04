// To parse this JSON data, do
//
//     final otpVerificationModel = otpVerificationModelFromJson(jsonString);

import 'dart:convert';

OtpVerificationModel otpVerificationModelFromJson(String str) => OtpVerificationModel.fromJson(json.decode(str));

String otpVerificationModelToJson(OtpVerificationModel data) => json.encode(data.toJson());

class OtpVerificationModel {
  OtpVerificationModel({
    this.message,
    this.data,
  });

  String message;
  List<dynamic> data;

  factory OtpVerificationModel.fromJson(Map<String, dynamic> json) => OtpVerificationModel(
    message: json["message"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
