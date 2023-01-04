import 'package:flutter/material.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/add_listing/add_listing.dart';
import 'package:food_serving_app/screen/edit_or_delete_active_list/edit_or_delete_active_list_screen.dart';
import 'package:food_serving_app/screen/search_city/search_city_screen.dart';
import 'package:food_serving_app/utils/app.dart';
import 'package:food_serving_app/utils/color_res.dart';
import 'package:food_serving_app/utils/common_widgets.dart';
import 'package:food_serving_app/utils/debug.dart';
import 'package:food_serving_app/utils/rest.dart';
import 'package:food_serving_app/utils/styles.dart';
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

bool isTimer = false;
bool isValid;

class EnterOTPSCreen extends StatefulWidget {
  String otp;
  final String auth_token;
  final String MobileNo;

  EnterOTPSCreen(this.otp, this.auth_token, this.MobileNo);

  @override
  _EnterOTPSCreenState createState() => _EnterOTPSCreenState();
}

class _EnterOTPSCreenState extends State<EnterOTPSCreen>
    with TickerProviderStateMixin {
  int levelClock = 60;
  bool timeUp = false;
  String btnText = AppRes.otpsubmit;
  TextEditingController otpController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  AnimationController animationController;
  String userOtp;

  RestApi restApi = RestApi();

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
        title: Text(
          "Mobile number Verification",
          textAlign: TextAlign.center,
        ),
        backgroundColor: ColorRes.blue.withOpacity(0.7),
      ),
      body: Stack(
        alignment: AlignmentDirectional(-0.85, -0.85),
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Countdown(
                            animation: StepTween(begin: levelClock, end: 0)
                                .animate(animationController),
                          ),
                          Text(
                            " " + AppRes.seconds,
                            style: TextStyle(
                                color: timeUp == true
                                    ? Colors.white
                                    : Colors.black,
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
                        color:
                            timeUp == true ? Colors.transparent : Colors.grey,
                        size: 32,
                      ),
                    ],
                  ),
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
                    fieldsCount: widget.otp == null ? 6 : widget.otp.length,
                    controller: otpController,
                    focusNode: _focusNode,
                    autofocus: true,
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
                      if (btnText == AppRes.otpsubmit) {
                        if (otpController.text.isNotEmpty) {
                          if (otpController.text == widget.otp) {
                            OTPVerification();
                          } else {
                            Get.snackbar("Error", "Please Enter Valid OTP",
                                backgroundColor: ColorRes.blue);
                          }
                          //Get.to(()=>EditOrDeleteActvieListScreen());
                        } else if (otpController.text.isEmpty) {
                          return Get.snackbar("Error", "Please enter OTP",
                              backgroundColor: ColorRes.blue);
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  timeUp == false
                      ? Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                //  color: ColorRes.blue
                              ),
                              child: Center(
                                child: Text(
                                  "",
                                  style:
                                      AppTextStyle(textColor: ColorRes.black),
                                ),
                              ),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  // color: ColorRes.blue
                                ),
                                child: Center(
                                    child: timeUp == false
                                        ? Text(
                                          "",
                                            style: AppTextStyle(
                                                textColor: ColorRes.black),
                                          )
                                        : Text(""))),
                          ],
                        )
                      : Container(),
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
          body: <String, String>{"mobileno": widget.MobileNo});
      Debug.print(response.statusCode);
      Debug.print(response.body);
      var resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Loader().hideLoader(context);
        clockReset();
        widget.otp = resBody["data"]["user_otp"];
        Get.snackbar("Success", "OTP Successfully Sent to Your Mobile Number",
            backgroundColor: ColorRes.blue,colorText: ColorRes.white);
      } else if (response.statusCode == 422) {
        Loader().hideLoader(context);
        Get.snackbar("Error", resBody["message"],
            backgroundColor: ColorRes.blue,colorText: ColorRes.white);
        Get.to(() => SearchCityScreen());
      } else {
        Loader().hideLoader(context);
        Get.snackbar("Error", "Something Went to Wrong Please try again later",
            backgroundColor: ColorRes.blue,colorText: ColorRes.white);
        Get.to(() => SearchCityScreen());
      }
    } catch (e) {
      Loader().hideLoader(context);
      Get.snackbar("Error", "Something Went to Wrong Please try again later",
          backgroundColor: ColorRes.blue,colorText: ColorRes.white);
      Get.to(() => SearchCityScreen());
      Exception(["$e"]);
    }
  }

  OTPVerification() async {
    Loader().showLoader(context);
    try {
      String url = RestRes.baseUrl + RestRes.otpVerification;
      http.Response response = await http.post(Uri.parse(url),
          headers: {"Authorization": widget.auth_token},
          body: {"otp": widget.otp});
      Debug.print(response.statusCode);
      Debug.print(response.body);
      var resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Loader().hideLoader(context);
        Get.snackbar("Success", "OTP Verification Successful",
            backgroundColor: ColorRes.blue,colorText: ColorRes.white);
        Future.delayed(Duration(milliseconds: 10), () {
          getactiveList();
        });
      } else if (response.statusCode == 422) {
        Loader().hideLoader(context);
        Get.snackbar("Error", "OTP Verification failed Please try again later",backgroundColor: ColorRes.blue,colorText: ColorRes.white);
          Get.to(() => SearchCityScreen());
      } else {
        Loader().hideLoader(context);
        Get.snackbar("Error", "Something went to wrong please try again later",backgroundColor: ColorRes.blue,colorText: ColorRes.white);
           Get.to(() => SearchCityScreen());
      }
    } catch (e) {
      Exception(["$e"]);
      Get.snackbar("Error", "Something Went to Wrong Please Try Again Later",backgroundColor: ColorRes.blue,colorText: ColorRes.white);
      Get.to(() => SearchCityScreen());
    }
  }

  getactiveList() async {
    try {
      String url = RestRes.baseUrl + RestRes.getActiveUser;
      http.Response response = await http
          .post(Uri.parse(url), headers: {"Authorization": widget.auth_token});
      Debug.print(response.statusCode);
      Debug.print(response.body);
      var resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (resBody["data"].isNotEmpty) {
          Get.to(() => EditOrDeleteActvieListScreen());
        } else if (resBody["data"].isEmpty) {
          Get.snackbar(
              "Error", "You Don't have an active listing Please add one",
              backgroundColor: ColorRes.blue,colorText: ColorRes.white);
          Future.delayed(Duration(seconds: 3), () {
            Get.to(() => AddListingScreen());
          });
        }
      } else if (response.statusCode != 200) {
        Get.snackbar("Error", "Something Went to Wrong Please try again Later",backgroundColor: ColorRes.blue,colorText: ColorRes.white);
        Get.to(() => SearchCityScreen(),);
      } else {
        Get.snackbar("Error", "Something Went to Wrong Please try again Later",backgroundColor: ColorRes.blue,colorText: ColorRes.white);
        Get.to(() => SearchCityScreen());
      }
    } catch (e) {
      Exception(["$e"]);
      Get.snackbar("Error", "Something Went to Wrong Please try again Later",backgroundColor: ColorRes.blue,colorText: ColorRes.white);
      Get.to(() => SearchCityScreen());
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

  void changeBtnText() async {
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

    Debug. print(isTimer);

    return Text(
      "$timerText",
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    );
  }
}
