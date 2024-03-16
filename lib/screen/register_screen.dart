import 'package:flutter/material.dart';
import 'package:sqflite_test/database/db_helper.dart';
import 'package:sqflite_test/model/user_model.dart';
import 'package:sqflite_test/screen/sign_in_page.dart';
import 'package:sqflite_test/ui_helpper/UiHelper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  var userNameController = TextEditingController();
  var userEmailController = TextEditingController();
  var userPhoneController = TextEditingController();
  var userPassController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  void _saveUserData(String userName, String userEmail ,String userPhone,String userPass) async {
    if(userName.isNotEmpty && userEmail.isNotEmpty && userPhone.isNotEmpty && userPass.isNotEmpty){
      UserModel userModel = UserModel(user_name: userName, user_email: userEmail, user_phone: userPhone, user_pass: userPass);
      var db = DBHelper.insertUser(userModel).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data insert..')));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignPage(),));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/logo.png'),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  UiHelper.customeTextField(userNameController, TextInputType.text, 'Name', Icons.person),
                  UiHelper.customeTextField(userEmailController, TextInputType.emailAddress, 'Email', Icons.mail),
                  UiHelper.customeTextField(userPhoneController, TextInputType.phone, 'Phone', Icons.phone),
                  UiHelper.customeTextField(userPassController, TextInputType.text, 'Password', Icons.lock),
                  UiHelper.customeButton(() {
                   if(_formKey.currentState!.validate()){
                     var userName = userNameController.text.toString();
                     var userEmail = userEmailController.text.toString();
                     var userPhone = userPhoneController.text.toString();
                     var userPass = userPassController.text.toString();
                     _saveUserData(userName, userEmail, userPhone, userPass);
                     userNameController.clear();
                     userEmailController.clear();
                     userPhoneController.clear();
                     userPassController.clear();
                   }
                  }, 'Register')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
