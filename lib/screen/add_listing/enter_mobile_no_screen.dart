import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:food_serving_app/model/shared_preference_model.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/add_listing/enter_otp_screen.dart';
import 'package:food_serving_app/screen/landed_home/landed_home_screen.dart';
import 'package:food_serving_app/screen/search_city/search_city_screen.dart';
import 'package:food_serving_app/utils/app.dart';
import 'package:food_serving_app/utils/color_res.dart';
import 'package:food_serving_app/utils/common_widgets.dart';
import 'package:food_serving_app/utils/debug.dart';
import 'package:food_serving_app/utils/rest.dart';
import 'package:food_serving_app/utils/styles.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class EnterMobileNoScreen extends StatefulWidget {
  final String name;
  final String contactNo;
  final String address;
  final String city;
  final String type;
  final String food;

  const EnterMobileNoScreen(
      {this.name,
      this.contactNo,
      this.address,
      this.city,
      this.type,
      this.food});

  @override
  _EnterMobileNoScreenState createState() => _EnterMobileNoScreenState();
}

class _EnterMobileNoScreenState extends State<EnterMobileNoScreen> {
  String phoneCode = '91';
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    Debug. print("New Country selected: " + countryCode.toString());
    phoneCode = countryCode.toString().replaceAll("+", "");
    Debug.print(phoneCode);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobile Verification"),
        backgroundColor: ColorRes.blue.withOpacity(0.7),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 120, left: 20, right: 20),
        width: Get.width,
        height: Get.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                child: Text(
              AppRes.enterMoBelow,
              textAlign: TextAlign.left,
              style: AppTextStyle(
                  textColor: ColorRes.black, size: 18, weight: FontWeight.bold),
            )),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: CountryCodePicker(
                        onChanged: _onCountryChange,
                        initialSelection: 'IN',
                        favorite: ['+91', 'IN'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Flexible(
                        child: CommonTextField(
                          textInputType: TextInputType.number,
                          hintText: AppRes.phone,
                          prefix: Icon(
                            Icons.phone_android,
                            color: ColorRes.blue,
                            size: 15,
                          ),
                          controller: phoneController,
                          validator: validateEmail,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CommonBtn(
                        btnText: AppRes.sendotp,
                        isIconAvailable: true,
                        backgroundColor: ColorRes.blue.withOpacity(0.7),
                        textColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        borderRadius: 20.0,
                        fontSize: 16,
                        icon: Icons.keyboard_arrow_right,
                        iconColor: Colors.white,
                        onButtonPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            getOTP();
                          }
                        }),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  getOTP() async {
    Loader().showLoader(context);
    var id = await getDeviceId();
    var device = await getDevice();
    try {
      String url = RestRes.baseUrl + RestRes.sendOtp;
      print(url);
      http.Response response =
          await http.post(Uri.parse(url), body: <String, String>{
        "mobileno":'+91'+phoneController.text,
        "device_token": id,
        "device_type": isDeviceIOS == true ? "I" : "A"
      });
      Debug. print("Set");
      Debug.print(response.statusCode);
      Debug.print(response.body);
      var resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Loader().hideLoader(context);
        setAuthToken(resBody["data"]["auth_token"]);
        var token = getAuthToken();
        Debug.print(token);
        Get.to(() => EnterOtpScreen(
              userotp: resBody["data"]["user_otp"],
              auth_token: resBody["data"]["auth_token"],
              mobileNo: resBody["data"]["mobileno"],
              contactNo: widget.contactNo,
              name: widget.name,
              address: widget.address,
              city: widget.city,
              type: widget.type,
              food: widget.food,
            ));
        Get.snackbar("Success", "OTP Successfully Sent to your mobile number",
            backgroundColor: ColorRes.blue,colorText: ColorRes.white);
      } else {
        Loader().hideLoader(context);
        Get.snackbar("Error", "Something Want to Wrong Please Try Again Later",
            backgroundColor: ColorRes.blue,colorText: ColorRes.white);
        Get.to(() => SearchCityScreen());
      }
    } catch (e) {
      Loader().hideLoader(context);
      Get.snackbar("Error", "Something Want to Wrong Please Try Again Later",
          backgroundColor: ColorRes.blue,colorText: ColorRes.white);
      Get.to(() => SearchCityScreen());
      Exception(["$e"]);
    }
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return AppRes.errormobileNo;
    } else if (value.length > 10 || value.length < 10) {
      return AppRes.eneterDigitnum;
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
