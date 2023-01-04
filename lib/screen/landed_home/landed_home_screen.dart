import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_serving_app/model/shared_preference_model.dart';
import 'package:food_serving_app/screen/about_us/about_us.dart';
import 'package:food_serving_app/screen/add_listing/add_listing.dart';
import 'package:food_serving_app/screen/add_listing/enter_mobile_no_screen.dart';
import 'package:food_serving_app/screen/edit_or_delete_active_list/edit_or_delete_active_list_screen.dart';
import 'package:food_serving_app/screen/edit_or_delete_active_list/edt_or_delete_enter_mobile_no.dart';
import 'package:food_serving_app/screen/search_city/search_city_screen.dart';
import 'package:food_serving_app/utils/app.dart';
import 'package:food_serving_app/utils/color_res.dart';
import 'package:food_serving_app/utils/common_widgets.dart';
import 'package:food_serving_app/utils/debug.dart';
import 'package:food_serving_app/utils/styles.dart';
import 'package:get/get.dart';
bool isDeviceIOS=false;
class LandedHomeScreen extends StatefulWidget {
  const LandedHomeScreen({Key key}) : super(key: key);

  @override
  _LandedHomeScreenState createState() => _LandedHomeScreenState();
}

class _LandedHomeScreenState extends State<LandedHomeScreen> {
  String device;
  @override
  void initState() {
    getDeviceDetails();
    super.initState();
  }
  @override
  static Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        isDeviceIOS=false;
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId;
        setDeviceId(identifier);
        setDevice("A");
        Debug.print(deviceName);//UUID for Android
      } else if (Platform.isIOS) {
        isDeviceIOS=true;
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;
        setDeviceId(identifier);
        Debug.print(deviceName);//UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: ColorRes.blue.withOpacity(0.70),
        title:Text(AppRes.appName),),
      body: WillPopScope(
        onWillPop: (){
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  AppRes.quitapp,
                  style: AppTextStyle(
                      textColor: ColorRes.black,
                      size: 19,
                      weight: FontWeight.w600,

                  ),
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  AppRes.quitappdialog,
                  style: TextStyle(),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      AppRes.yes,
                      style: AppTextStyle(
                          textColor: ColorRes.blue,
                          size: 20,
                          weight: FontWeight.w500),
                    ),
                    onPressed: () async{

                      SystemNavigator.pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      AppRes.cancel,
                      style: AppTextStyle(
                          textColor: ColorRes.blue,
                          size: 19,
                          weight: FontWeight.w500),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        },
        child:Container(
          alignment: Alignment.center,
         // padding: EdgeInsets.only(top: 180,left: 10,right: 10),
          width:Get.width,
        height: Get.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Get.to(()=>SearchCityScreen());
                  },
                  child: CommonButton(AppRes.search,Get.width,TextAlign.left),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    Get.to(()=>AddListingScreen());
                  },
                  child: CommonButton(AppRes.addListing,Get.width,TextAlign.left),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    Get.to(()=>EnterMobileNoOTPScreen());
                  },
                  child: CommonButton(AppRes.editORdelete,Get.width,TextAlign.left),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    Get.to(()=>AboutUsScreen());
                  },
                  child: CommonButton(AppRes.aboutUs,Get.width,TextAlign.left),
                ),



              ],
            ),
          ),
        ) ,
      ),
    );
  }
}
