import 'dart:convert';

import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:food_serving_app/model/send_otp_model.dart';
import 'package:food_serving_app/model/shared_preference_model.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/edit_or_delete_active_list/edt_or_dlt_otp_screen.dart';
import 'package:food_serving_app/screen/edit_or_delete_active_list/otp_view_model.dart';
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

class EnterMobileNoOTPScreen extends StatefulWidget {
  const EnterMobileNoOTPScreen({Key key}) : super(key: key);

  @override
  EnterMobileNoScreenState createState() => EnterMobileNoScreenState();
}

class EnterMobileNoScreenState extends State<EnterMobileNoOTPScreen> {
  String phoneCode = '91';
  OTPViewModel otpViewModel;
  SendOtpModel sendOtpModel;
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RestApi restApi = RestApi();

  @override
  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    print("New Country selected: " + countryCode.toString());
    phoneCode = countryCode.toString().replaceAll("+", "");
    print(phoneCode);
  }

  @override
  void initState() {
    restApi.getUserActiveFoodAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mobile Number Verification",
          textAlign: TextAlign.center,
        ),
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
                            print("isval$isValid");
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
      Debug.print(url);
      http.Response response =
          await http.post(Uri.parse(url), body: <String, String>{
        "mobileno": '+91'+phoneController.text,
        "device_token": id,
        "device_type": isDeviceIOS == true ? "I" : "A"
      });
      Debug.print("Set");
      Debug.print(response.statusCode);
      Debug.print(response.body);
      var resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Loader().hideLoader(context);
        setAuthToken(resBody["data"]["auth_token"]);
        var token = getAuthToken();
        Debug.print(token);
        Get.to(() => EnterOTPSCreen(
              resBody["data"]["user_otp"],
              resBody["data"]["auth_token"],
              resBody["data"]["mobileno"],
            ));
        Get.snackbar("Success", "OTP Successfully Sent to Your Mobile Number",
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
    } else if (value.length < 10 || value.length > 10) {
      return AppRes.eneterDigitnum;
    }
  }
}
