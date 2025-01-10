import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    });

    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/splash_image.webp'), // Add your splash image here
      ),
    );
  }
}
