import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_serving_app/model/get_all_city_model.dart';
import 'package:food_serving_app/model/get_all_food_model.dart';
import 'package:food_serving_app/model/shared_preference_model.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/landed_home/landed_home_screen.dart';
import 'package:food_serving_app/screen/lister_detail/get_food_detail_view_model.dart';
import 'package:food_serving_app/screen/lister_detail/lister_detail_screen.dart';
import 'package:food_serving_app/screen/search_city/get_all_food_view_model.dart';
import 'package:food_serving_app/screen/search_city/search_city_view_model.dart';
import 'package:food_serving_app/utils/app.dart';
import 'package:food_serving_app/utils/color_res.dart';
import 'package:food_serving_app/utils/common_widgets.dart';
import 'package:food_serving_app/utils/debug.dart';
import 'package:food_serving_app/utils/rest.dart';
import 'package:food_serving_app/utils/styles.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:device_info/device_info.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
String id;

class SearchCityScreen extends StatefulWidget {
  const SearchCityScreen({Key key}) : super(key: key);

  @override
  SearchCityScreenState createState() => SearchCityScreenState();
}

class SearchCityScreenState extends State<SearchCityScreen> {
  bool isInternet = true;
  SearchCityViewModel model;
  GetFoodDetailViewModel getFoodDetailViewModel;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController CityController = TextEditingController();
  String selectedval;
  Datum selectedCity;
  String deviceId;
  ScrollController controller;
  bool isPaging = false;
  int initPosition = 0;
  int page = 0;
  List<Datum> list;
  String selectedId;
  GetAllFoodViewModel allFoodViewModel;
  GetAllFoodModel foodModel;
  List<dynamic> countries = new List();
  Map<String, int> city = {};
  List<Datum> map;
  double lat;
  double lng;
  final List<String> _dropdownValues = [
    "Surat",
    "Bharuch",
    "Anand",
    "Bengaluru",
    "Ahemdabad"
  ];
  RestApi restApi = RestApi();

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);

    getcities();
    _scaffoldKey = GlobalKey();
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 100) {
      if (allFoodViewModel.canPaging && !isPaging) {
        setState(() {
          isPaging = true;
        });
        page++;
        Debug.print("page$page");
        allFoodViewModel.getAllFoodApi(page);
      }
    }
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
      city.addAll({
        responseBody["data"][i]["name"]:
            int.parse(responseBody["data"][i]["id"])
      });
    }
    Debug.print("countries");
    Debug.print(countries);
    Debug.print(city);
  }

  @override
  Widget build(BuildContext context) {
    model ?? (model = SearchCityViewModel(this));
    allFoodViewModel ?? (allFoodViewModel = GetAllFoodViewModel(this));
    return WillPopScope(
      onWillPop: () {
        Get.to(() => LandedHomeScreen());
      },
      child: RefreshIndicator(
        key: _scaffoldKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorRes.blue.withOpacity(0.70),
            title: Text(AppRes.appName),
          ),
          body: (model.cities == null || allFoodViewModel.allFood == null)
              ? allFoodViewModel.allFood == null
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
                                        model.getCity();
                                        allFoodViewModel.getAllFoodAPIInitial();
                                        Loader().hideLoader(context);
                                        setState(() {});
                                      },
                                      child: Text("OK"))
                                ])
                          : CircularProgressIndicator(),
                    )
                  : Center(
                      child: Text("Data Not Found"),
                    )
              : allFoodViewModel.allFood.data == null
                  ? Center(
                      child: Text("Data Not Found"),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: Get.width,
                        height: Get.height,
                        child: Column(
                          children: [
                            Text(
                              AppRes.availableListing,
                              style: AppTextStyle(
                                  textColor: ColorRes.black, size: 20),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            popmenu(),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            allFoodViewModel.allFood.data.isEmpty
                                ? Container(
                                    height: Get.height * 0.65,
                                    child:
                                        Center(child: Text("Data Not Found")),
                                  )
                                : Container(
                                    height: isPaging == true
                                        ? Get.height * 0.55
                                        : Get.height * 0.65,
                                    child: ListView.builder(
                                        controller: controller,
                                        itemCount: allFoodViewModel
                                            .allFood.data.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () async {
                                              getuserLocation(allFoodViewModel.allFood.data[index].address.toString(),allFoodViewModel.allFood.data[index].city.toString());
                                              id = allFoodViewModel
                                                  .allFood.data[index].id;
                                              Get.to(() => ListerDetailScreen(
                                                    name: allFoodViewModel
                                                        .allFood
                                                        .data[index]
                                                        .name,
                                                    contactNo: allFoodViewModel
                                                        .allFood
                                                        .data[index]
                                                        .mobileno,
                                                    address: allFoodViewModel
                                                        .allFood
                                                        .data[index]
                                                        .address,
                                                    city: allFoodViewModel
                                                        .allFood
                                                        .data[index]
                                                        .city,
                                                    type: allFoodViewModel
                                                        .allFood
                                                        .data[index]
                                                        .type,
                                                    food: allFoodViewModel
                                                        .allFood
                                                        .data[index]
                                                        .typeFoodAvailable,
                                                    id: allFoodViewModel
                                                        .allFood.data[index].id,
                                                  ));
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: ColorRes.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.8),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 8),
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Text("Example listing 1"),
                                                  SizedBox(
                                                    height: 1,
                                                  ),
                                                  Text(allFoodViewModel.allFood
                                                      .data[index].type),
                                                  SizedBox(
                                                    height: 1,
                                                  ),
                                                  Text(allFoodViewModel.allFood
                                                      .data[index].mobileno),
                                                  SizedBox(
                                                    height: 1,
                                                  ),
                                                  Text(allFoodViewModel.allFood
                                                      .data[index].address),
                                                  SizedBox(
                                                    height: 1,
                                                  ),
                                                  Text(allFoodViewModel
                                                      .allFood
                                                      .data[index]
                                                      .typeFoodAvailable)
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                            isPaging == true
                                ? Container(
                                    width: Get.width,
                                    height: Get.height * 0.1,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
        ),
        onRefresh: () {
          return new Future.delayed(Duration(seconds: 1), () async {
            Loader().showLoader(context);
            await restApi.getAllCity();
            await restApi.getAllFoodAPI(0, selectedId);
            Loader().hideLoader(context);
          });
        },
      ),
    );
  }

  Future<LatLng>getuserLocation(String address,String city)async{
String add=address+' '+city;

   /* Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);*/
  var loca=await  Geocoder.local.findAddressesFromQuery(add);
  print(loca[0].coordinates.latitude);
  print(loca[0].coordinates.longitude);
lat=loca[0].coordinates.latitude;
lng=loca[0].coordinates.longitude;



    LocationManager.LocationData currentLocation;
    final location = LocationManager.Location();
    try{
      List<Location> loc=await locationFromAddress("${address},${city}");
      currentLocation=await location.getLocation();
       lat=loc[0].latitude;
       lng=loc[0].longitude;

      print(lat);
      print(lng);


    }
    on PlatformException catch(e){
      if(e.code=='PERMISSION_DENIED')
        print(e.code);
      if(e.code=='PERMISSION_DENIED_NEVER_ASK')
        print(e.code);
      currentLocation=null;
      return null;
    }
  }
  citydropDown() {
    return Container(
      padding: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: ColorRes.blue.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
        //border: Border.all(color: ColorRes.black),
      ),
      width: Get.width,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<Datum>(
            isDense: false,
            value: selectedCity,
            isExpanded: true,
            hint: Text(
              "Select City",
              style: TextStyle(
                  color: ColorRes.black, fontSize: Get.width <= 500 ? 14 : 19),
            ),
            validator: (value) => value == null ? "Please select city" : null,
            onTap: () {},
            onChanged: (Datum value) async {
              selectedCity = value;
              selectedId = value.id;
              print(selectedId);

              Future.delayed(Duration(milliseconds: 0), () async {
                Loader().showLoader(context);
                await allFoodViewModel.getAllFoodAPIInitial();
              });

              Loader().hideLoader(context);
              setState(() {});
            },
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none),
            items: model.cities != null
                ? model.cities.data
                    .map((city) => DropdownMenuItem(
                        value: city,
                        child: Column(
                          children: [
                            Text(
                              '${city.name}',
                              maxLines: 1,
                              style: AppTextStyle(
                                  textColor: ColorRes.black, size: 18),
                            ),
                          ],
                        )))
                    .toList()
                : ['Empty']
                    .map((e) => DropdownMenuItem(child: Text('$e')))
                    .toList()),
      ),
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
          selectedId = "${city[value]}";
          Debug.print("selectedId${selectedId}");
          Loader().showLoader(context);
          allFoodViewModel.getAllFoodAPIInitial();
          Loader().hideLoader(context);

          Debug.print(value);
          Debug.print("ID : ${city[value]}");
          Debug.print("name : $value");
        },
        dropdownSearchDecoration: InputDecoration(border: InputBorder.none),
        hint: "Select City",
      ),
    );
  }
}
