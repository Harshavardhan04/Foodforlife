import 'package:food_serving_app/model/resend_otp_model.dart';
import 'package:food_serving_app/model/send_otp_model.dart';
import 'package:food_serving_app/rest_api/rest_api.dart';
import 'package:food_serving_app/screen/edit_or_delete_active_list/edt_or_delete_enter_mobile_no.dart';

class OTPViewModel{
  SendOtpModel sendOtpModel;
  ReSendOtpModel reSendOtpModel;
  //EnterMobileNoScreenState state;
 // OTPViewModel(this.state);
  sendOTP(String number)async{


    sendOtpModel=await RestApi.sendOTPAPI(number);
  }
  reSendOTP(String number)async{
    reSendOtpModel=await RestApi.reSendOTPAPI(number);
  }

}