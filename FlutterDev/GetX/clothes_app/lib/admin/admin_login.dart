
import 'dart:convert';

import 'package:clothes_app/admin/admin_upload_items.dart';
import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/authentication/signUp_screen.dart';
import 'package:clothes_app/users/fragments/dashboard_of_fragments.dart';
import 'package:clothes_app/users/userPreferences/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;

import '../../api_connection/api_connection.dart';


class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  var formKey=GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var isObsecure=true.obs;

  loginAdminNow() async {
    try{
      var res = await http.post(
          Uri.parse(API.adminLogin),
          body:{
            "admin_email":emailController.text.trim(),
            "admin_password":passwordController.text.trim(),
          }
      );

      if(res.statusCode==200){
        var resBodyOfLogin=jsonDecode(res.body);
        if(resBodyOfLogin['success']==true){
          Fluttertoast.showToast(msg: "Dear Admin, you are logged-in Successfully");

          //after saving user info then user gona in dashboard
          Future.delayed(const Duration(microseconds: 2000),(){
            Get.to(AdminUploadItemsScreen());
          }
          );


        }
        else{
          Fluttertoast.showToast(msg: " Incorrect Credentials.\n Please write correct password or email and Try Again.");
        }
      }
      else{
        Fluttertoast.showToast(msg: "status code is not 200");
      }
    }
    catch(errorMsg){
      print("Error::" + errorMsg.toString());

    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context,cons){
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  //login screeen header
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 285,
                    child: Image.asset(
                      "images/admin.jpg",
                    ),
                  ),

                  //login screen  sign-in form
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration:const BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.all(
                              Radius.circular(60)
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0,-3),
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20,20,20,8),
                        child: Column(
                          children: [

                            //email-password-login btn
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  //getting email from user
                                  TextFormField(
                                    controller: emailController,
                                    //the user leave the email text frome field empty
                                    //then we will display an error so we use this validator
                                    validator:(val)=> val=="" ? "Please write email" :null ,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      hintText: "email...",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          )
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          )
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          )
                                      ),
                                      contentPadding:const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,

                                    ),

                                  ),

                                  const SizedBox(height: 18,),
                                  //password
                                  Obx(
                                        ()=>  TextFormField(
                                      controller: passwordController,
                                      obscureText: isObsecure.value,
                                      //the user leave the email text frome field empty
                                      //then we will display an error so we use this validator
                                      validator:(val)=> val=="" ? "Please write password" :null ,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.vpn_key_sharp,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: Obx(
                                              ()=> GestureDetector(
                                            onTap: ()
                                            {
                                              isObsecure.value=!isObsecure.value;

                                            },
                                            child: Icon(
                                              isObsecure.value ? Icons.visibility_off :Icons.visibility,
                                              color: Colors.black,

                                            ),


                                          ),
                                        ),
                                        hintText: "password...",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            )
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            )
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            )
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            )
                                        ),
                                        contentPadding:const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,

                                      ),

                                    ),
                                  ),

                                  const SizedBox(height: 18,),
                                  //button
                                  Material(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: (){
                                        if(formKey.currentState!.validate()){
                                          loginAdminNow();
                                        }

                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 28
                                        ),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                            ),

                            const SizedBox(height: 16,),

                            //i am not an admin button-button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "I am not an Admin?"
                                ),
                                TextButton(
                                    onPressed: (){
                                      Get.to(LoginScreen());

                                    },
                                    child: const Text(
                                      "Click Here",
                                      style: TextStyle(
                                          color: Colors.purpleAccent,
                                          fontSize: 16
                                      ),
                                    )
                                )
                              ],
                            ),



                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
