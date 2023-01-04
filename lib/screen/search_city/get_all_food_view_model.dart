import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:food_serving_app/model/get_all_food_model.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/search_city/search_city_screen.dart';
import 'package:food_serving_app/utils/common_widgets.dart';
import 'package:get/get.dart';

class GetAllFoodViewModel {
  GetAllFoodModel allFood;
  SearchCityScreenState state;
  int orderPageLength = 0;
  bool canPaging = true;
  RestApi restapi = RestApi();

  GetAllFoodViewModel(this.state) {
    getAllFoodAPIInitial();
  }

  getAllFoodAPIInitial() async {
    try{
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var food = await restapi.getAllFoodAPI(0,state.selectedId);
        if (food == null) {
          allFood = GetAllFoodModel(data: []);
        } else {
          allFood = food;
        }
        if (allFood.data.length >=9) {
          orderPageLength++;
        } else {
          canPaging = false;
        }
        state.setState(() {});
      }
    }
    on SocketException catch(_){
      state.setState(() {
        state.isInternet=false;
      });
    }

  }
  getAllFoodApi(int start )async{
    //Loader().showLoader(state.context);
    var food=await  restapi.getAllFoodAPI(start,state.selectedId);
   if( food==null){
     state.isPaging=false;
     canPaging=false;
     state.setState(() {

     });
   }
    //Loader().hideLoader(state.context);
    if(food!=null){
      allFood.data.addAll(food.data);
    }

    state.isPaging = false;
    orderPageLength++;
    if(allFood.data.length <= 9){
      canPaging = false;
    }
    state.setState(() {});

  }
}
