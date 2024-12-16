
import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var formKey=GlobalKey<FormState>();
  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var isObsecure=true.obs;
  validateUserEmail() async
  {
    //validate email that it is already exist or not in db
    try {
      //response from server
      var res = await http.post(
          Uri.parse(API.validateEmail),
          body: {
            'user_email': emailController.text.trim(),
          }
      );

      if (res.statusCode == 200) //from flutter app the connection with api to server-success
          {
        var resBodyOfValidateEmail = jsonDecode(res.body);

        if (resBodyOfValidateEmail['emailFound'] == true) {
          //email is already exist length==1
          Fluttertoast.showToast(
              msg: "Email is already in someone else use. Try another email.");
        }
        else {
          //register and save new user record to database
          registerAndSaveUserRecord();
        }
      }
      else{
        Fluttertoast.showToast(msg: "Status code is not 200");
      }
    }
    catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

    registerAndSaveUserRecord() async
    {
      //nama email password pehle User model ko pass kiya usne isko json me convert kr diya
        User userModel=User(
        1,
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim()
        );

        try{
          var res = await http.post(
              Uri.parse(API.signUp),
              body: userModel.toJson(),
            );

          if(res.statusCode==200){
            var resBodyOfSignUp=jsonDecode(res.body);
            if(resBodyOfSignUp['success']==true){
              Fluttertoast.showToast(msg: "Congratulations,you are SignUp Successfully");
              setState(() {
                //after click button of signup details will be clear
                nameController.clear();
                emailController.clear();
                passwordController.clear();
              });
            }
            else{
              Fluttertoast.showToast(msg: "Error Occured,Try Again.");
            }
          }

          else{
            Fluttertoast.showToast(msg: "Status code not 200");
          }
        }
    catch(e){
            print(e.toString());
            Fluttertoast.showToast(msg: e.toString());
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

                  //signUp screeen header
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: Image.asset(
                      "images/register.jpg",
                    ),
                  ),

                  //signUp screen  signup-in form
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
                        padding: const EdgeInsets.fromLTRB(30,30,30,8),
                        child: Column(
                          children: [

                            //email-password-name signup btn
                            Form(
                              key: formKey,
                              child: Column(
                                children: [

                                  //name
                                  TextFormField(
                                    controller: nameController,

                                    validator:(val)=> val=="" ? "Please write name" :null ,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.black,
                                      ),
                                      hintText: "name...",
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
                                          //validate the email
                                          //if any field like email name password
                                          //khali reh jaye isliye validate check
                                          //krege
                                          validateUserEmail();
                                        }

                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 28
                                        ),
                                        child: Text(
                                          'SignUp',
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

                            //dont have account then create account
                            //Already  have an account button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                      "Already have an Account?"
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                      onPressed: (){
                                        Get.to(LoginScreen());

                                      },
                                      child: const Text(
                                        "Login Here",
                                        style: TextStyle(
                                            color: Colors.purpleAccent,
                                            fontSize: 16
                                        ),
                                      )
                                  ),
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
