import 'dart:io';

import 'package:food_serving_app/model/get_all_city_model.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/add_listing/add_listing.dart';

class AddListingViewModel{
  GetAllCityModel cities;
  AddListingScreenState state;
  RestApi restApi=RestApi();
  AddListingViewModel(this.state){
    getCity();
  }
  getCity()async{
    try{
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        cities=await restApi.getAllCity();
        state.setState(() {
          state.isInternet=false;
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