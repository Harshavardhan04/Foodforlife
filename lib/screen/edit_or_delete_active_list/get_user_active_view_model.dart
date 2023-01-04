import 'dart:io';

import 'package:food_serving_app/model/get_active_user_food_model.dart';
import 'package:food_serving_app/model/get_all_city_model.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/edit_or_delete_active_list/edit_or_delete_active_list_screen.dart';

class GetUserActiveFoodViewModel{
  GetUserActiveFoodModel model;
  GetAllCityModel cities;
  EditOrDeleteActvieListScreenState state;
  RestApi restApi=RestApi();
  GetUserActiveFoodViewModel(this.state){
    getUserActiveFoodData();
    getCity();
  }
  getUserActiveFoodData()async{
    try{
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var deatil=await restApi.getUserActiveFoodAPI();
        model=deatil;
        state.setState(() {
        });
      }

    }
    on SocketException catch(_){
      state.setState(() {
        state.isInternet=false;
      });
    }

  }
  getCity()async{
    try{
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        cities=await restApi.getAllCity();
        state.setState(() {
        });
      }
    }
    on SocketException catch(_){
      state.setState(() {
        state.isInternet=false;
      });
    }


  }
}