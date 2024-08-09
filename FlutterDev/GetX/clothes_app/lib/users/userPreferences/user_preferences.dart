import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class RememberUserPrefs{
  //save-remember user-info
  static Future<void> storeUserInfo(User userInfo) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String userJsonData= jsonEncode(userInfo.toJson());
    //saving user data who is logged-in in shrededpref
    await preferences.setString("currentUser", userJsonData);
  }

  //get-read User info
static Future<User?> readUserInfo()async{
    User? currentUserInfo;
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String? userInfo= preferences.getString("currentUser"); //in json format (isme ham local storage se user data le rhe h to ye json me h
    if(userInfo !=null){
     Map<String,dynamic> userDataMap= jsonDecode(userInfo); //userInfo ko decode kiya
     currentUserInfo=User.fromJson(userDataMap);  //json se normal me change kiya

    }

    return currentUserInfo;
}
static Future<void> removeUserInfo()async{
  SharedPreferences preferences=await SharedPreferences.getInstance();
  await preferences.remove("currentUser");

}

}