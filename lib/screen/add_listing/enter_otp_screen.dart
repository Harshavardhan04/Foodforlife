import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_serving_app/model/shared_preference_model.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/add_listing/add_listing.dart';
import 'package:food_serving_app/screen/edit_or_delete_active_list/edit_or_delete_active_list_screen.dart';
import 'package:food_serving_app/screen/edit_or_delete_active_list/edt_or_dlt_otp_screen.dart';
import 'package:food_serving_app/screen/search_city/search_city_screen.dart';
import 'package:food_serving_app/utils/app.dart';
import 'package:food_serving_app/utils/color_res.dart';
import 'package:food_serving_app/utils/common_widgets.dart';
import 'package:food_serving_app/utils/debug.dart';
import 'package:food_serving_app/utils/rest.dart';
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pin_put/pin_put_state.dart';

class EnterOtpScreen extends StatefulWidget {
  String userotp;
  final String auth_token;
  final String mobileNo;
  final String name;
  final String contactNo;
  final String address;
  final String city;
  final String type;
  final String food;

  EnterOtpScreen(
      {this.userotp,
      this.auth_token,
      this.mobileNo,
      this.name,
      this.contactNo,
      this.address,
      this.city,
      this.type,
      this.food});

  @override
  EnterOtpScreenState createState() => EnterOtpScreenState();
}

class EnterOtpScreenState extends State<EnterOtpScreen>
    with TickerProviderStateMixin {
  int levelClock = 60;
  bool timeUp = false;
  bool isResend = false;
  String Otp;
  String resendOtp;
  String btnText = AppRes.otpsubmit;
  TextEditingController otpController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: Duration(seconds: levelClock));
    animationController.forward();
    changeBtnText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobile number Verification"),
        backgroundColor: ColorRes.blue.withOpacity(0.7),
      ),
      body: Stack(
        alignment: AlignmentDirectional(-0.85, -0.85),
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 120, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  timeUp == false
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Countdown(
                                  animation:
                                      StepTween(begin: levelClock, end: 0)
                                          .animate(animationController),
                                ),
                                Text(
                                  " " + AppRes.seconds,
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.watch_later_outlined,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppRes.otpsubmit,
                    style: TextStyle(fontSize: 23, color: Colors.black),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    AppRes.verifycode,
                    style: TextStyle(color: Colors.grey, fontSize: 15.5),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  PinPut(
                    autofocus: true,
                    fieldsCount:
                        widget.userotp == null ? 6 : widget.userotp.length,
                    controller: otpController,
                    focusNode: _focusNode,
                    onSubmit: (String pin) {},
                    mainAxisSize: MainAxisSize.max,
                    eachFieldPadding: EdgeInsets.only(
                        top: 18, bottom: 18, left: 20, right: 20),
                    textStyle: TextStyle(color: Colors.blue, fontSize: 16),
                    submittedFieldDecoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    selectedFieldDecoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    followingFieldDecoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  timeUp == true
                      ? CommonBtn(
                          btnText: "Resend OTP",
                          isIconAvailable: false,
                          backgroundColor: Colors.blue[300],
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 38, vertical: 13),
                          borderRadius: 30.0,
                          fontSize: 15,
                          iconColor: Colors.white,
                          onButtonPressed: () async {
                            resendOTP();
                          },
                        )
                      : CommonBtn(
                          btnText: "Resend OTP",
                          isIconAvailable: false,
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          padding: EdgeInsets.symmetric(
                              horizontal: 38, vertical: 13),
                          borderRadius: 30.0,
                          fontSize: 15,
                          iconColor: Colors.white,
                          onButtonPressed: () {},
                          textColor: Colors.white,
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  CommonBtn(
                    btnText: btnText,
                    isIconAvailable: false,
                    backgroundColor: Colors.blue[300],
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 38, vertical: 13),
                    borderRadius: 30.0,
                    fontSize: 15,
                    iconColor: Colors.white,
                    onButtonPressed: () async {
                      _focusNode.unfocus();
                      //  Otp=isResend==true?resendOtp:Otp;
                      if (otpController.text.isNotEmpty) {
                        Debug.print("controller");
                        Debug.print(otpController.text);
                        Debug.print(Otp);

                        if (otpController.text == widget.userotp) {
                          OTPVerification();
                        } else {
                          Get.snackbar("Error", "Please Enter Valid OTP",
                              backgroundColor: ColorRes.blue,colorText: ColorRes.white);
                        }
                        //Get.to(()=>EditOrDeleteActvieListScreen());
                      } else if (otpController.text.isEmpty) {
                        return Get.snackbar("Error", "Please enter OTP",
                            backgroundColor: ColorRes.blue,colorText: ColorRes.white);
                      }


                    },
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  resendOTP() async {
    Loader().showLoader(context);
    otpController.clear();

    try {
      String url = RestRes.baseUrl + RestRes.resendOTP;
      Debug.print(url);
      http.Response response = await http.post(Uri.parse(url),
          body: <String, String>{"mobileno": widget.mobileNo});
      Debug.print(response.statusCode);
      Debug.print(response.body);
      var resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Loader().hideLoader(context);
        clockReset();
        widget.userotp = resBody["data"]["user_otp"];
        Get.snackbar("Success", "OTP Successfully Sent to your mobile number",
            backgroundColor: ColorRes.blue,colorText: ColorRes.white);
      } else if (response.statusCode != 200) {
        Get.snackbar("Error", resBody["message"],
            backgroundColor: ColorRes.blue,colorText: ColorRes.white);
        Get.to(() => SearchCityScreen());
      } else {
        Get.snackbar("Error", "Something went to wrong please try again later",
            backgroundColor: ColorRes.blue,colorText: ColorRes.white);
        Get.to(() => SearchCityScreen());
      }
    } catch (e) {
      Get.snackbar("Error", "Something went to wrong please try again later",
          backgroundColor: ColorRes.blue,colorText: ColorRes.white);
      Get.to(() => SearchCityScreen());
      Exception(["$e"]);
    }


  }

  OTPVerification() async {
    String url = RestRes.baseUrl + RestRes.otpVerification;
    http.Response response = await http.post(Uri.parse(url),
        headers: {"Authorization": widget.auth_token},
        body: {"otp": widget.userotp});
    Debug.print(response.statusCode);
    Debug.print(response.body);
    var resBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Get.snackbar("Success", "OTP Verification successful",
          backgroundColor: ColorRes.blue);

      Future.delayed(Duration(seconds: 0), () {
        addListing();
      });

      // Get.to(() => SearchCityScreen());
    } else if (response.statusCode == 422) {
      Get.snackbar("Error", "OTP Verification failed Please try again later",
          backgroundColor: ColorRes.blue);
      Get.to(() => SearchCityScreen());
    } else {
      Get.snackbar("Error", "Something went to wrong please try again later",
          backgroundColor: ColorRes.blue);
      Get.to(() => SearchCityScreen());
    }
  }

  addListing() async {
    Debug. print(widget.name);
    Debug.print(widget.auth_token);
    Debug.print(widget.auth_token);
    Debug.print(widget.mobileNo);
    Debug. print(widget.address);
    Debug.print(widget.city);
    Debug. print(widget.type);
    Debug.print(widget.food);
    Loader().showLoader(context);
    String url = RestRes.baseUrl + RestRes.addUpdateFood;
    http.Response response = await http.post(Uri.parse(url), headers: {
      "Authorization": widget.auth_token
    }, body: {
      "name": widget.name,
      "mobileno": widget.mobileNo,
      "address": widget.address,
      "city_id": widget.city,
      "type": widget.type,
      "type_food_available": widget.food
    });
    Debug. print(response.statusCode);
    Debug. print(response.body);
    var resBody = jsonDecode(response.body);
    Debug.print(resBody);
    if (response.statusCode == 200) {
      Loader().hideLoader(context);
      Future.delayed(Duration(seconds: 1), () {
        Get.snackbar("Success", "Listing successfully added",
            backgroundColor: ColorRes.blue);
        Future.delayed(Duration(seconds: 1), () {
          Get.to(() => SearchCityScreen());
        });
      });
    } else if (response.statusCode == 422) {
      Loader().hideLoader(context);
      Get.snackbar(
          "Error", "Your List is Already active you can't add multiple lists",
          backgroundColor: ColorRes.blue);
      //Loader().showLoader(context);
      Future.delayed(Duration(seconds: 2), () {
        // Loader().hideLoader(context);
        Get.to(() => SearchCityScreen());
      });
    } else {
      Loader().hideLoader(context);
      Get.snackbar("Error", "Something Went to wrong please try again later",
          backgroundColor: ColorRes.blue);
      Future.delayed(Duration(seconds: 3), () {
        Get.to(() => SearchCityScreen());
      });
    }
  }

  void clockReset() async {
    if (timeUp) {
      animationController = AnimationController(
          vsync: this, duration: Duration(seconds: levelClock));
      animationController.forward();
      changeBtnText();
      Future.delayed(Duration(seconds: levelClock), () {
        timeUp = true;
      });
      Loader().showLoader(context);
      setState(() {});
      timeUp = false;
      btnText = AppRes.otpsubmit;
      Loader().hideLoader(context);
    }
  }

  void changeBtnText() {
    Future.delayed(Duration(seconds: levelClock), () {
      timeUp = true;
      setState(() {

      });
    });
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);
    String timerText =
        '${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}' ==
                "00"
            ? ""
            : '${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Text(
      "$timerText",
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    );
  }
}
