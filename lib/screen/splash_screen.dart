import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_test/screen/my_home_page.dart';
import 'package:sqflite_test/screen/sign_in_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  static const String KEYLOGIN = 'login';


  @override
  void initState() {
    super.initState();
    whereTo();
  }

  whereTo() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    var isLogin = sp.getBool(KEYLOGIN);
    Timer.periodic(Duration(seconds: 2), (timer) {
      if(isLogin!=null){
        if(isLogin){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(),));
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignPage(),));
        }
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignPage(),));
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            SizedBox(height: 20,),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
