import 'dart:io';

import 'package:food_serving_app/model/get_all_city_model.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/search_city/search_city_screen.dart';
import 'package:food_serving_app/utils/common_widgets.dart';
import 'package:stacked/stacked.dart';
class SearchCityViewModel  {
  GetAllCityModel cities;
  SearchCityScreenState state;
  RestApi restApi=RestApi();
  SearchCityViewModel(this.state){
    getCity();
  }

  getCity()async{
    try{
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //Loader().showLoader(state.context);
        cities=await restApi.getAllCity();
        //Loader().hideLoader(state.context);
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