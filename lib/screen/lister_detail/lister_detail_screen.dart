import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:food_serving_app/model/get_food_detail.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/lister_detail/get_food_detail_view_model.dart';
import 'package:food_serving_app/utils/app.dart';
import 'package:food_serving_app/utils/color_res.dart';
import 'package:food_serving_app/utils/common_widgets.dart';
import 'package:food_serving_app/utils/debug.dart';
import 'package:food_serving_app/utils/rest.dart';
import 'package:food_serving_app/utils/styles.dart';
import 'package:get/get.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as LocationManager;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class ListerDetailScreen extends StatefulWidget {
  final String name;
  final String contactNo;
  final String address;
  final String city;
  final String type;
  final String food;
  final String id;
 final double lat;
 final double lng;

  const ListerDetailScreen({
    this.name,
    this.contactNo,
    this.address,
    this.city,
    this.type,
    this.food,
    this.id,
    this.lat,
    this.lng
  });

  @override
  ListerDetailScreenState createState() => ListerDetailScreenState();
}

// Destination latitude
double _destLatitude = 21.7645;
// Destination Longitude
double _destLongitude = 72.1519;
// Markers to show points on the map
Map<MarkerId, Marker> markers = {};
PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};
double originLatitude;
// Starting point longitude
double originLongitude;

class ListerDetailScreenState extends State<ListerDetailScreen> {
  bool isInternet = true;
  String id;
  GetFoodDetailViewModel getFoodDetailViewModel;
  Model model;
  RestApi restApi = RestApi();
  Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _kGooglePlex=CameraPosition(
    target: LatLng(originLatitude == null ? 28.6139 : originLatitude,
        originLongitude == null ? 77.2090 : originLongitude),
    zoom: 9.4746,
  );

  @override
  void initState() {
    getlocation();
    super.initState();
  }

  GoogleMapController mapController;

  BitmapDescriptor customIcon1;

  createMarker(context) {
    if (customIcon1 == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/images/fire.png')
          .then((icon) {
        setState(() {
          customIcon1 = icon;
        });
      });
    }
  }

  Future<LatLng> getUserLocation() async {
    LocationManager.LocationData currentLocation;
    final location = LocationManager.Location();

    try {
      List<Location> loction1 =
          await locationFromAddress("${widget.address},${widget.city}");
      currentLocation = await location.getLocation();
      final lat =loction1[0].latitude;
      final lng =loction1[0].longitude;
      Debug.print(lat);
      Debug.print(lng);
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  getlocation() async {
    List<Location> loction = await locationFromAddress(
        "${widget.address == null ? "New Delhi" : widget.address},${widget.city == null ? "New Dekhi" : widget.city}");
    print(loction[0].longitude);
    print(loction[0].latitude);
    originLatitude =
        loction[0].latitude == null ? 28.6139 : loction[0].latitude;
    originLongitude =
        loction[0].longitude == null ? 77.2090 : loction[0].longitude;
    _kGooglePlex=null;
    _kGooglePlex = CameraPosition(
      target: LatLng(originLatitude == null ? 28.6139 : originLatitude,
          originLongitude == null ? 77.2090 : originLongitude),
      zoom: 9.4746,
    );
    _addMarker(
      LatLng(originLatitude == null ? 28.6139 : originLatitude,
          originLongitude == null ? 77.2090 : originLongitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );
  }

  getfooddetail() async {
    model = await restApi.getFoodDetailApi();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getFoodDetailViewModel =
        (getFoodDetailViewModel ?? GetFoodDetailViewModel(this));
    createMarker(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppRes.appName),
        backgroundColor: ColorRes.blue.withOpacity(0.70),
      ),
      body: WillPopScope(
        onWillPop: () {
          Get.back();
        },
        child: getFoodDetailViewModel.foodDetail == null
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
                                  getFoodDetailViewModel.getFoodDetail();
                                  Loader().hideLoader(context);
                                  setState(() {});
                                },
                                child: Text("OK"))
                          ])
                    : CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    children: [
                      Text(
                        AppRes.detailsOfLister,
                        style: AppTextStyle(
                            textColor: ColorRes.black,
                            size: 20,
                            weight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CommonContainer(
                                width: Get.width * 0.4,
                                height: Get.height * 0.08,
                                text: AppRes.nameOfContact,
                              ),
                              CommonContainer(
                                width: Get.width * 0.4,
                                height: Get.height * 0.08,
                                text:
                                    getFoodDetailViewModel.foodDetail.data.name,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CommonContainer(
                                width: Get.width * 0.4,
                                height: Get.height * 0.08,
                                text: AppRes.contactNumber,
                              ),
                              InkWell(
                                  onTap: () async {
                                    FlutterPhoneDirectCaller.callNumber(
                                        widget.contactNo);
                                  },
                                  child: CommonContainer(
                                    width: Get.width * 0.4,
                                    height: Get.height * 0.08,
                                    text: getFoodDetailViewModel
                                        .foodDetail.data.mobileno,
                                    color: ColorRes.blue,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CommonContainer(
                                width: Get.width * 0.4,
                                height: Get.height * 0.08,
                                text: AppRes.address,
                              ),
                              CommonContainer(
                                height: Get.height * 0.1,
                                width: Get.width * 0.4,
                                text: getFoodDetailViewModel
                                    .foodDetail.data.address,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CommonContainer(
                                width: Get.width * 0.4,
                                height: Get.height * 0.08,
                                text: AppRes.city,
                              ),
                              InkWell(
                                onTap: () async {},
                                child: CommonContainer(
                                  width: Get.width * 0.4,
                                  height: Get.height * 0.08,
                                  text: getFoodDetailViewModel
                                      .foodDetail.data.city,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CommonContainer(
                                width: Get.width * 0.4,
                                height: Get.height * 0.08,
                                text: AppRes.type,
                              ),
                              CommonContainer(
                                width: Get.width * 0.4,
                                height: Get.height * 0.08,
                                text:
                                    getFoodDetailViewModel.foodDetail.data.type,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CommonContainer(
                                height: Get.height * 0.08,
                                text: AppRes.typeofFood,
                              ),
                              CommonContainer(
                                width: Get.width * 0.4,
                                height: Get.height * 0.08,
                                text: getFoodDetailViewModel
                                    .foodDetail.data.typeFoodAvailable,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: Get.height*0.3,
                        width: Get.width,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: _kGooglePlex,
                          myLocationButtonEnabled: true,
                          tiltGesturesEnabled: true,
                          compassEnabled: true,
                          scrollGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                          polylines: Set<Polyline>.of(polylines.values),
                          markers: Set<Marker>.of(markers.values),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          gestureRecognizers: Set()
                            ..add(Factory<PanGestureRecognizer>(
                                () => PanGestureRecognizer())),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }
}
