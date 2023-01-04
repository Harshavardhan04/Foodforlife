import 'package:flutter/material.dart';
import 'package:food_serving_app/screen/landed_home/landed_home_screen.dart';
import 'package:food_serving_app/utils/app.dart';
import 'package:food_serving_app/utils/color_res.dart';
import 'package:food_serving_app/utils/styles.dart';
import 'package:get/get.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 4), (){
      Get.to(()=>LandedHomeScreen());
    } );

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE6CC),
      body: Container(

        child: Center(child: Image.asset("assets/images/logo.png",)),
      ),

    );
  }
}
