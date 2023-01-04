import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:food_serving_app/model/get_food_detail.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/lister_detail/lister_detail_screen.dart';
import 'package:food_serving_app/screen/search_city/search_city_screen.dart';

class GetFoodDetailViewModel {
  ListerDetailScreenState state;
  Model foodDetail;
  RestApi restApi = RestApi();

  GetFoodDetailViewModel(this.state){
    getFoodDetail();
  }


  getFoodDetail() async {
    try{
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var details = await restApi.getFoodDetailApi();
        print(details);
        foodDetail=details;
        state.setState(() {});
      }
    }
    on SocketException catch(_){
      state.isInternet=false;
    }
  }
}
