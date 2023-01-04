import 'dart:convert';

import 'package:food_serving_app/model/get_active_user_food_model.dart';
import 'package:food_serving_app/model/get_all_city_model.dart';
import 'package:food_serving_app/model/get_all_food_model.dart';
import 'package:food_serving_app/model/get_food_detail.dart';
import 'package:food_serving_app/model/otp_verification_model.dart';
import 'package:food_serving_app/model/resend_otp_model.dart';
import 'package:food_serving_app/model/send_otp_model.dart';
import 'package:food_serving_app/model/shared_preference_model.dart';
import 'package:food_serving_app/screen/edit_or_delete_active_list/edt_or_dlt_otp_screen.dart';
import 'package:food_serving_app/screen/landed_home/landed_home_screen.dart';
import 'package:food_serving_app/screen/search_city/search_city_screen.dart';
import 'package:food_serving_app/utils/app.dart';
import 'package:food_serving_app/utils/debug.dart';
import 'package:food_serving_app/utils/rest.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class RestApi {
  Future<GetAllCityModel> getAllCity() async {
    bool isvalid = false;
    try {
      String url = RestRes.baseUrl + RestRes.city;
      Debug.print(url);
      Response response = await http.get(Uri.parse(url));
      Debug.print(response.statusCode);
      Debug.print(response.body);
      if (response.statusCode == 200) {
        return getAllCityModelFromJson(response.body);
      } else {
        isvalid = true;
        return null;
      }
    } catch (e) {
      throw Exception(["$e"]);
    }
  }

  Future<GetAllFoodModel> getAllFoodAPI(int start, String id) async {
    bool isError = false;
    try {
      String url = RestRes.baseUrl + RestRes.getallFood;
      Debug.print(url);
      Response response = await http.post(Uri.parse(url), body: {
        "start": start == null ? "0" : start.toString(),
        "limit": "10",
        "city_id": id == null ? "" : id.toString()
      });
      Debug.print(response.statusCode);
      Debug.print(response.body);
      var resBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (resBody["data"].isNotEmpty) {
          return getAllFoodModelFromJson(response.body);
        }


      } else if (resBody["data"] == []) {
      } else if (response.statusCode == 422) {
        isError = true;
      }

      isError = false;
    } catch (e) {
      throw Exception(["$e"]);
    }
  }

  static Future<SendOtpModel> sendOTPAPI(
    String mobNo,
  ) async {
    try {
      var id = await getDeviceId();
      var device = await getDevice();
      String url = RestRes.baseUrl + RestRes.sendOtp;
      Debug.print(url);
      Response response =
          await http.post(Uri.parse(url), body: <String, String>{
        "mobileno": mobNo,
        "device_token": id,
        "device_type": isDeviceIOS == true ? "I" : "A"
      });
      Debug.print(response.statusCode);
      Debug.print(response.body);
      if (response.statusCode == 200) {
        return sendOtpModelFromJson(response.body);
      }
    } catch (e) {
      throw Exception(["$e"]);
    }
  }

  static Future<ReSendOtpModel> reSendOTPAPI(String mobNO) async {
    try {
      String url = RestRes.baseUrl + RestRes.resendOTP;
      Debug.print(url);
      Response response = await http
          .post(Uri.parse(url), body: <String, String>{"mobileno": mobNO});
      Debug.print(response.statusCode);
      Debug.print(response.body);
      if (response.statusCode == 200) {
        return reSendOtpModelFromJson(response.body);
      }
    } catch (e) {
      throw Exception(["$e"]);
    }
  }

  static Future<OtpVerificationModel> OTPVerificatiob(
      String auth_token, String otp) async {
    try {
      String url = RestRes.baseUrl + RestRes.otpVerification;
      Debug.print(url);
      Response response = await http.post(Uri.parse(url),
          headers: <String, String>{"Authorization": auth_token},
          body: <String, String>{"otp": otp});
      Debug.print(response.statusCode);
      Debug.print(response.body);
      if (response.statusCode == 200) {
        return otpVerificationModelFromJson(response.body);
      }
    } catch (e) {
      throw Exception(["$e"]);
    }
  }

  Future<GetUserActiveFoodModel> getUserActiveFoodAPI() async {
    try {
      var auth_token = await getAuthToken();
      String url = RestRes.baseUrl + RestRes.getActiveUser;
      Response response = await http
          .post(Uri.parse(url), headers: {"Authorization": auth_token});
      Debug.print(response.statusCode);
      Debug.print(response.body);
      isValid = response.statusCode == 200 ? true : false;
      if (response.statusCode == 200) {
        //isValid=null;
        //Valid=true;
        return getUserActiveFoodModelFromJson(response.body);
      } else {
        //isValid=false;
      }
    } catch (e) {
      Exception(["$e"]);
      isValid = false;
    }
  }

  Future<Model> getFoodDetailApi() async {
    try {
      String url = RestRes.baseUrl + RestRes.getFoodDetail;
      Response response =
          await http.post(Uri.parse(url), body: {"id": id.toString()});
      Debug.print(response.statusCode);
      Debug.print(response.body);
      var resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (resBody["message"] == "Get food details Successfully") {
          return modelFromJson(response.body);
        }
        Debug.print("yes");
      }
    } catch (e) {
      Exception(["$e"]);
    }
  }
}
