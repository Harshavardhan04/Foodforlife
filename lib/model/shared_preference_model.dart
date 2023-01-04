import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<bool> setDeviceId(String deviceId) async {
  final SharedPreferences prefs = await _prefs;
  return await prefs.setString("deviceId", deviceId);
}
Future<String> getDeviceId() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString("deviceId");
}
Future<bool>setAuthToken(String authToken)async{
  final SharedPreferences prefs=await _prefs;
  return await prefs.setString("authToken", authToken);
}
Future<String>getAuthToken()async{
  final SharedPreferences prefs=await _prefs;
  return prefs.getString("authToken");
}
Future<bool>setDevice(String device)async{
  final SharedPreferences prefs=await _prefs;
  return prefs.setString(device, "device");
}
Future<String>getDevice()async{
  final SharedPreferences prefs=await _prefs;
  return prefs.getString("device");
}