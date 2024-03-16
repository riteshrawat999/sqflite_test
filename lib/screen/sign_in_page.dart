import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_test/database/db_helper.dart';
import 'package:sqflite_test/screen/my_home_page.dart';
import 'package:sqflite_test/screen/register_screen.dart';
import 'package:sqflite_test/screen/splash_screen.dart';
import 'package:sqflite_test/ui_helpper/UiHelper.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignPage> {

  var _formKey = GlobalKey<FormState>();

  var userEmailController = TextEditingController();
  var userPassController = TextEditingController();

  Future<void> _chechCustomer(String email , String pass) async{
    try{
      var res = await DBHelper.loginUser(email, pass);
      SharedPreferences sp = await SharedPreferences.getInstance();
      if(res!=null){
        sp.setBool(SplashScreenState.KEYLOGIN, true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(),));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid Email or Password...')));
      }

    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error : ${e}')));
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Demo..',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.red.withOpacity(.9),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/logo.png'),
            Form(
              key:_formKey,
              child: Column(
                children: [
                  UiHelper.customeTextField(userEmailController, TextInputType.emailAddress,'Email',Icons.mail),
                  UiHelper.customeTextField(userPassController, TextInputType.text,'Password',Icons.lock),
                  UiHelper.customeButton(() {
                    if(_formKey.currentState!.validate()){
                      var email = userEmailController.text.toString();
                      var pass = userPassController.text.toString();
                      _chechCustomer(email,pass);
                    }

                  }, 'Login'),
                ],
              ),
            ),

            SizedBox(height: 11,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Don't have a account? ",style: TextStyle(color: Colors.grey),),
                GestureDetector(
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(),));
                    },
                    child: Text("Register",style: TextStyle(color: Colors.red.shade500,fontWeight: FontWeight.w500),)
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
