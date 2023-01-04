import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_serving_app/model/get_active_user_food_model.dart';
import 'package:food_serving_app/model/get_all_city_model.dart';
import 'package:food_serving_app/model/shared_preference_model.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/edit_or_delete_active_list/get_user_active_view_model.dart';
import 'package:food_serving_app/screen/search_city/get_all_food_view_model.dart';
import 'package:food_serving_app/screen/search_city/search_city_screen.dart';
import 'package:food_serving_app/utils/app.dart';
import 'package:food_serving_app/utils/color_res.dart';
import 'package:food_serving_app/utils/common_widgets.dart';
import 'package:food_serving_app/utils/debug.dart';
import 'package:food_serving_app/utils/rest.dart';
import 'package:food_serving_app/utils/styles.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;

class EditOrDeleteActvieListScreen extends StatefulWidget {
  const EditOrDeleteActvieListScreen({Key key}) : super(key: key);

  @override
  EditOrDeleteActvieListScreenState createState() =>
      EditOrDeleteActvieListScreenState();
}

class EditOrDeleteActvieListScreenState
    extends State<EditOrDeleteActvieListScreen> {
  bool isInternet = true;
  final _formKey = GlobalKey<FormState>();
  final List<String> _dropdownValues = [
    "Individual",
    "Restaurant",
    "NGO",
    "Other",
  ];
  GetAllFoodViewModel allFoodViewModel;
  List<dynamic> countries = new List();
  Map<String, int> cities = {};
  Datum selectedCity;
  String selectedId;
  String city;
  String selectedval;
  GetUserActiveFoodViewModel getUserActiveFoodViewModel;
  GetUserActiveFoodModel model;
  bool flage = true;
  TextEditingController NameController = TextEditingController();
  TextEditingController ContactnoController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  TextEditingController CityController = TextEditingController();
  TextEditingController TypeofFoodController = TextEditingController();
  RestApi restApi = RestApi();

  @override
  void initState() {
    restApi.getUserActiveFoodAPI();
    getcities();
    super.initState();
  }

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

  putDataInController() async {
    assert(getUserActiveFoodViewModel != null);
    assert(getUserActiveFoodViewModel.model.data != null);
    NameController..text = getUserActiveFoodViewModel.model.data?.name ?? "";
    ContactnoController
      ..text = getUserActiveFoodViewModel.model.data?.mobileno ?? "";
    AddressController
      ..text = getUserActiveFoodViewModel.model.data?.address ?? "";

    TypeofFoodController
      ..text = getUserActiveFoodViewModel.model.data?.typeFoodAvailable ?? "";
    flage = false;
  }

  @override
  Widget build(BuildContext context) {
    getUserActiveFoodViewModel ??
        (getUserActiveFoodViewModel = GetUserActiveFoodViewModel(this));
    if (flage) {
      if (getUserActiveFoodViewModel != null &&
          getUserActiveFoodViewModel.model != null) {
        putDataInController();
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorRes.blue.withOpacity(0.7),
        title: Padding(
            padding: EdgeInsets.only(left: 60),
            child: Text(
              AppRes.yourList,
              textAlign: TextAlign.center,
            )),
      ),
      body: getUserActiveFoodViewModel.model == null
          ? Center(
              child: isInternet == false
                  ? AlertDialog(
                      title: Text(
                        "Netwoek Unavailable",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      content: Text(
                        "Please Check internet Connection",
                        style: TextStyle(fontSize: 15),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Loader().showLoader(context);
                              getUserActiveFoodViewModel.getCity();
                              getUserActiveFoodViewModel
                                  .getUserActiveFoodData();
                              Loader().hideLoader(context);
                            },
                            child: Text("Ok"))
                      ],
                    )
                  : CircularProgressIndicator(),
            )
          : getUserActiveFoodViewModel.model.data != null
              ? SingleChildScrollView(
                  child: getUserActiveFoodViewModel.cities == null
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.only(top: 30),
                          width: Get.width,
                          height: Get.height,
                          child: Column(
                            children: [
                              Text(
                                AppRes.yourList,
                                style: AppTextStyle(
                                    textColor: ColorRes.black,
                                    weight: FontWeight.bold,
                                    size: 20),
                              ),
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
                                            else if (value.length != 13)
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
                                              hintText: AppRes.enterAddress),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        popmenu(),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        typDropDown(),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        TextFormField(
                                          validator: validateTyeofFood,
                                          controller: TypeofFoodController,
                                          decoration: InputDecoration(
                                              hintText: AppRes.enterTypeofFod),
                                        ),
                                        SizedBox(
                                          height: 70,
                                        ),

                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                )
              : Center(
                  child: Text("Data Not Found"),
                ),
      bottomSheet:  Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () async {
                  return showDialog(
                      context: context,
                      builder: (BuildContext
                      context) {
                        return AlertDialog(
                          title: Text(
                              "Do you want to delete"),
                          content: Text(
                              "Are you sure you want to delete your active listing?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  deleteData();
                                },
                                child: Text(
                                    AppRes
                                        .yes)),
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                    AppRes
                                        .cancel))
                          ],
                        );
                      });
                },
                child: CommonButton(
                    AppRes.delete,
                    Get.width * 0.4,
                    TextAlign.center)),
            InkWell(
                onTap: () async {
                  updateData();
                },
                child: CommonButton(
                    AppRes.update,
                    Get.width * 0.4,
                    TextAlign.center)),
          ],
        ),
      ),
    );
  }

  updateData() async {
    Debug.print("selectedval");
    Debug.print(selectedval);
    Debug.print(selectedId);
    Loader().showLoader(context);
    var id = await getAuthToken();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String url = RestRes.baseUrl + RestRes.addUpdateFood;
      http.Response response = await http.post(Uri.parse(url), headers: {
        "Authorization": id.toString()
      }, body: {
        "name": NameController.text.trim().toString(),
        "mobileno": ContactnoController.text.trim().toString(),
        "address": AddressController.text.trim().toString(),
        "city_id": selectedId == null
            ? getUserActiveFoodViewModel.model.data.cityId
            : selectedId,
        "type": selectedval == null
            ? getUserActiveFoodViewModel.model.data.type
            : selectedval,
        "type_food_available": TypeofFoodController.text.trim().toString(),
        "id": getUserActiveFoodViewModel.model.data.id
      });
      Debug.print(response.statusCode);
      Debug.print(response.body);
      var jsonResp = jsonDecode(response.body);
      Debug.print(jsonResp);
      if (response.statusCode == 200) {
        Loader().hideLoader(context);
        Get.to(() => SearchCityScreen());
        Get.snackbar("Success", "Listing Updated Successfully",
            backgroundColor: ColorRes.blue,colorText: ColorRes.white);
      } else if (response.statusCode == 422) {
        Loader().hideLoader(context);
        Get.to(() => SearchCityScreen());
        Get.snackbar("Error", "Something Went to Wrong Please try again later",
            backgroundColor: ColorRes.blue,colorText: ColorRes.white);
      } else {
        Loader().hideLoader(context);
        Get.to(() => SearchCityScreen());
        Get.snackbar("Error", "Something Went to Wrong Please try again later",backgroundColor: ColorRes.blue,colorText: ColorRes.white);
      }
    } else {
      Get.snackbar("Error", "Please Fill Up All the Inforamation given Below",
          backgroundColor: ColorRes.blue,colorText: ColorRes.white);
    }
  }

  deleteData() async {
    Loader().showLoader(context);
    var id = await getAuthToken();
    String url = RestRes.baseUrl + RestRes.deleteActiveFood;
    http.Response response = await http.post(Uri.parse(url),
        headers: {"Authorization": id.toString()},
        body: {"id": getUserActiveFoodViewModel.model.data.id});
    Debug.print(response.statusCode);
    var jsonResp = jsonDecode(response.body);
    Debug.print(jsonResp);
    if (response.statusCode == 200) {
      Loader().hideLoader(context);
      Get.snackbar("Success", "Listing successfully deleted",
          backgroundColor: ColorRes.blue,colorText: ColorRes.white);
      Future.delayed(Duration(seconds: 1), () {
        Get.to(() => SearchCityScreen());
      });
    } else if (response.statusCode != 200) {
      Loader().hideLoader(context);
      Get.snackbar("Error", "Something Went to Wrong Please try again later",
          backgroundColor: ColorRes.blue,colorText: ColorRes.white);
    } else {
      Loader().hideLoader(context);
      Get.snackbar("Error", "Something Went to Wrong Please try again later",backgroundColor: ColorRes.blue,colorText: ColorRes.white);
    }
  }

  typDropDown() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: ColorRes.blue.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      width: Get.width,
      child: DropdownButton(
          onTap: () {
            setState(() {});
            selectedval = null;
          },
          hint: getUserActiveFoodViewModel.model.data == null
              ? Text(
                  AppRes.selectType,
                  style: TextStyle(color: ColorRes.black),
                )
              : Text(getUserActiveFoodViewModel.model.data.type),
          style: TextStyle(color: ColorRes.black),
          underline: Container(),
          items: _dropdownValues
              .map(
                  (value) => DropdownMenuItem(child: Text(value), value: value))
              .toList(),
          onChanged: (String value) {
            print(value);

            selectedval = value;
            setState(() {});
            print(selectedval);
          },
          isExpanded: true,
          value: selectedval),
    );
  }

  popmenu() {
    return Container(
      padding: EdgeInsets.only(left: 10),
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
        onChanged: (value) async {
          selectedId = "${cities[value]}";
          Debug.print(value);
          Debug.print("ID : ${cities[value]}");
          Debug.print("name : $value");
        },
        dropdownSearchDecoration: InputDecoration(border: InputBorder.none),
        hint: getUserActiveFoodViewModel.model.data == null
            ? "Select City"
            : getUserActiveFoodViewModel.model.data.city,
      ),
    );
  }

  String validateName(String name) {
    if (name.isEmpty) return AppRes.entername;
  }

  String validaContactNumber(int number) {
    if (number == null)
      return AppRes.enterContactNo;
    else if (number <= 10 && number > 14) return AppRes.enterproperno;
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
