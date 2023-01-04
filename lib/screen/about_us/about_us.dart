import 'package:flutter/material.dart';
import 'package:food_serving_app/utils/app.dart';
import 'package:food_serving_app/utils/color_res.dart';
import 'package:food_serving_app/utils/styles.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String url = "assets/images/logo.png";
    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(
        title: Text(
          "About Food For Life",
          style: AppTextStyle(
              textColor: ColorRes.white, weight: FontWeight.bold, size: 18),
        ),
        backgroundColor: ColorRes.blue.withOpacity(0.7),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                width: Get.width,
                height: Get.height * 0.22,
                decoration: BoxDecoration(
                    color: ColorRes.black,
                    borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text:
                          'Food For Life was developed to solve one of India’s biggest problems: hunger. There exists a paradox in India: 67 million tons of food are wasted every year yet 190 million people go to bed with an empty stomach each night.',
                      style: AppTextStyle(
                          textColor: Color(0xFF2A2A2A),
                          size: 14,
                          weight: FontWeight.w500)),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text:
                          'I, Harshavardhan Mishra, saw the scope to help these figures converge: most people in India have access to smartphones now and our Indian community is one of the most generous in the world.',
                      style:
                          AppTextStyle(textColor: Color(0xFF2A2A2A), size: 14,weight: FontWeight.w500)),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text:
                          'How can you be a part of this journey to zero hunger? If you have excess food leftover, add a listing by filling in the required details. Those who need the food will call you and you can then coordinate with them to handover your excess food in your own personalised way.',
                      style:
                          AppTextStyle(textColor: Color(0xFF2A2A2A), size: 14,weight: FontWeight.w500)),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text:
                          'Everyone can help out: restaurants, NGOs and individuals. Just add a listing! You can also edit or delete the listing if your available type of food changes or if you run out of food.',
                      style:
                          AppTextStyle(textColor: Color(0xFF2A2A2A), size: 14,weight: FontWeight.w500)),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: 'In case of any queries, you can email me at ',
                          style: AppTextStyle(
                              textColor: Color(0xFF2A2A2A), size: 14,weight: FontWeight.w500)),
                    ]),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => sendEmail(),
                    child: Text(
                      'foodforlifeapp@gmail.com',
                      style: AppTextStyle(textColor: ColorRes.blue, size: 14,weight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Harshavardhan Mishra',
                    style: AppTextStyle(textColor: Color(0xFF2A2A2A), size: 14,weight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Founder - Food For Life ',
                    style: AppTextStyle(textColor: Color(0xFF2A2A2A), size: 14,weight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  sendEmail() async {
    final MailOptions mailOptions = MailOptions(
        body: 'Ro',
        subject: 'the Email subject',
        recipients: ['foodforlifeapp@gmail.com'],
        isHTML: true,
        attachments: []);
    await FlutterMailer.send(mailOptions);
    String plaplatformResponset;
    try {
      await FlutterMailer.send(mailOptions);
      plaplatformResponset = 'success';
    } catch (error) {
      plaplatformResponset = error.toString();
    }
    if (!mounted) return;
    _scafoldKey.currentState
        .showSnackBar(SnackBar(content: Text(plaplatformResponset)));

    /*  const url = 'malito:sagarrana05509@gmail.com?subject=Greetings&body=Hello';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar("Error", "Something Went Wrong Please Try again later",
          backgroundColor: ColorRes.blue);
      throw 'Could not launch $url';
      Get.back();
    }*/
  }
}
