import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:food_serving_app/model/get_all_city_model.dart';
import 'package:food_serving_app/screen/add_listing/add_listing_view_model.dart';
import 'package:food_serving_app/screen/add_listing/enter_mobile_no_screen.dart';
import 'package:food_serving_app/screen/search_city/get_all_food_view_model.dart';
import 'package:food_serving_app/screen/search_city/search_city_screen.dart';
import 'package:food_serving_app/screen/search_city/search_city_view_model.dart';
import 'package:food_serving_app/utils/app.dart';
import 'package:food_serving_app/utils/color_res.dart';
import 'package:food_serving_app/utils/common_widgets.dart';
import 'package:food_serving_app/utils/debug.dart';
import 'package:food_serving_app/utils/rest.dart';
import 'package:food_serving_app/utils/styles.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({Key key}) : super(key: key);

  @override
  AddListingScreenState createState() => AddListingScreenState();
}

class AddListingScreenState extends State<AddListingScreen> {
  bool isInternet = true;
  final _formKey = GlobalKey<FormState>();
  String selectedval;
  TextEditingController NameController = TextEditingController();
  TextEditingController ContactnoController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  TextEditingController CityController = TextEditingController();
  TextEditingController TypeofFoodController = TextEditingController();
  Datum selectedCity;
  String selectedId;
  String city;
  List<dynamic> countries = new List();
  Map<String, int> cities = {};
  AddListingViewModel model;
  GetAllFoodViewModel allFoodViewModel;
  final List<String> _dropdownValues = [
    "Individual",
    "Restaurant",
    "NGO",
    "Other",
  ];
  bool nameError = false;
  String contactError='';

  getcities() async {
    String url = RestRes.baseUrl + RestRes.city;
    Debug.print(url);
    http.Response response = await http.get(Uri.parse(url));
    Debug.print(response.statusCode);
    Debug.print(response.body);
    var responseBody = json.decode(response.body);
    for (int i = 0; i < responseBody["data"].length; i++) {
      countries.add(responseBody["data"][i]["name"]);
      cities.addAll({
        responseBody["data"][i]["name"]:
            int.parse(responseBody["data"][i]["id"])
      });
    }
    Debug.print("countries");
    Debug.print(countries);
    Debug.print(city);
  }

  @override
  void initState() {
    getcities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    model ?? (model = AddListingViewModel(this));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorRes.blue.withOpacity(0.7),
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(AppRes.yourList),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Get.to(() => SearchCityScreen());
        },
        child: model.cities == null
            ? Center(
                child: isInternet == false
                    ? AlertDialog(
                        title: Text("Netwoek Unavailable",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        content: Text(
                          "Please Check internet Connection",
                          style: TextStyle(fontSize: 15),
                        ),
                        actions: [
                            TextButton(
                                onPressed: () {
                                  Loader().showLoader(context);
                                  model.getCity();
                                  Loader().hideLoader(context);
                                  setState(() {});
                                },
                                child: Text("OK"))
                          ])
                    : CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: model.cities == null
                    ? Center(
                        child: isInternet == false
                            ? AlertDialog(
                                title: Text("Netwoek Unavailable",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                content: Text(
                                  "Please Check internet Connection",
                                  style: TextStyle(fontSize: 15),
                                ),
                                actions: [
                                    TextButton(
                                        onPressed: () {
                                          Loader().showLoader(context);
                                          model.getCity();
                                          Loader().hideLoader(context);
                                          setState(() {});
                                        },
                                        child: Text("OK"))
                                  ])
                            : Container(),
                      )
                    : Container(
                        padding: EdgeInsets.only(top: 30),
                        width: Get.width,
                        height: Get.height,
                        child: Column(
                          children: [
                            Form(
                                key: _formKey,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: NameController,
                                        validator: validateName,
                                        decoration: InputDecoration(
                                            hintText: AppRes.entername),
                                      ),

                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty)
                                            return AppRes.enterContactNo;
                                          else if (value.length != 10)
                                            return AppRes.enterproperno;
                                          else
                                            return null;
                                        },
                                        controller: ContactnoController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            // border: InputBorder.none,
                                            hintText: AppRes.enterContactNo),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        validator: validateAddress,
                                        controller: AddressController,
                                        decoration: InputDecoration(
                                            // border: InputBorder.none,
                                            hintText: AppRes.enterAddress),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      //citydropDown(),
                                      popmenu(),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 5,
                                            top: 5,
                                            bottom: 5),
                                        //padding: EdgeInsets.only(top: 0,left: 10,bottom: 0),
                                        decoration: BoxDecoration(
                                          color: ColorRes.blue.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          //border: Border.all(color: ColorRes.grey),
                                        ),
                                        width: Get.width,
                                        height: Get.height * 0.1,
                                        child: Center(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: DropdownButtonFormField(
                                              value: selectedval,
                                              hint: Text(AppRes.selectType),
                                              validator: (value) =>
                                                  value == null
                                                      ? "Please select type"
                                                      : null,
                                              decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  border: InputBorder.none),
                                              items: _dropdownValues
                                                  .map((value) =>
                                                      DropdownMenuItem(
                                                          child: Text(value),
                                                          value: value))
                                                  .toList(),
                                              onChanged: (String value) {
                                                selectedval = value;
                                                setState(() {});
                                                print(selectedval);
                                              },
                                              isExpanded: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 23,
                                      ),
                                      TextFormField(
                                        validator: validateTyeofFood,
                                        controller: TypeofFoodController,
                                        decoration: InputDecoration(
                                            // border: InputBorder.none,
                                            hintText: AppRes.enterTypeofFod),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            print("selected ID${selectedId}");
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                              Get.to(() => EnterMobileNoScreen(
                                                    name: NameController.text,
                                                    contactNo:
                                                        ContactnoController
                                                            .text,
                                                    address:
                                                        AddressController.text,
                                                    city: selectedId,
                                                    type: selectedval,
                                                    food: TypeofFoodController
                                                        .text,
                                                  ));
                                            } else {
                                              Get.snackbar("Error",
                                                  "Please fill in all the below fields",
                                                  backgroundColor:
                                                      ColorRes.blue,colorText: ColorRes.white);
                                            }
                                            if(NameController.text == ""){
                                              nameError = true;
                                              setState(() {});
                                            }else{
                                              nameError = false;
                                            }
                                          },
                                          child: CommonButton(AppRes.submit,
                                              Get.width, TextAlign.center))
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
              ),
      ),
    );
  }

  popmenu() {
    return Container(
      padding: EdgeInsets.only(left: 10, bottom: 5),
      height: Get.height * 0.1,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ColorRes.blue.withOpacity(0.7),
      ),
      child: DropdownSearch<dynamic>(
        popupBackgroundColor: ColorRes.white,
        popupBarrierColor: Colors.transparent,
        items: countries,
        showSearchBox: true,
        validator: (value) {
          if (value == null)
            return "Please select the City";
          else
            return null;
        },
        onChanged: (value) async {
          selectedId = "${cities[value]}";

          Debug.print(value);
          Debug.print("ID : ${cities[value]}");
          Debug.print("name : $value");
        },
        dropdownSearchDecoration: InputDecoration(
          border: InputBorder.none,
        ),
        hint: "Select City",
      ),
    );

    //list.addAll(model.cities.data);
  }

  String validateName(String name) {
    if (name.isEmpty) return AppRes.entername;
  }

  String validaContactNumber(int number) {
    if (number == null)
      return AppRes.enterContactNo;
    else if (number <= 10 && number > 13) return AppRes.enterproperno;
  }

  String validateAddress(String address) {
    if (address.isEmpty) return AppRes.enterAddress;
  }

  String validateCity(String city) {
    if (city.isEmpty) return AppRes.enterCity;
  }

  String validateTyeofFood(String typeodFood) {
    if (typeodFood.isEmpty) return AppRes.enterTypeofFod;
  }
}

class TypeDropDown extends StatelessWidget {
  final List<String> _dropdownValues = [
    "Individual",
    "Restaurant",
    "NGO",
    "Other",
  ];

  String selectedval;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: ColorRes.blue.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      width: Get.width,
      child: DropdownButton(
        value: selectedval,
        hint: Text(AppRes.selectType),
        style: TextStyle(color: ColorRes.black),
        underline: Container(),
        items: _dropdownValues
            .map((value) => DropdownMenuItem(child: Text(value), value: value))
            .toList(),
        onChanged: (String value) {
          selectedval = value;

          Debug.print(selectedval);
        },
        isExpanded: true,
      ),
    );
  }
}
