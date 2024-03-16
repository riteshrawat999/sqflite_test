import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_test/database/db_helper.dart';
import 'package:sqflite_test/model/user_model.dart';
import 'package:sqflite_test/screen/register_screen.dart';
import 'package:sqflite_test/screen/sign_in_page.dart';
import 'package:sqflite_test/screen/splash_screen.dart';
import 'package:sqflite_test/ui_helpper/UiHelper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late List<UserModel> userModel;

  var userNameC = TextEditingController();
  var userEmailC = TextEditingController();
  var userPhoneC = TextEditingController();
  var userPassC = TextEditingController();

  var updateUserNameC= TextEditingController();
  var updateUserEmailC= TextEditingController();
  var updateUserPhoneC= TextEditingController();
  var updateUserPassC= TextEditingController();



  void _saveUserData(String userName, String userEmail ,String userPhone,String userPass) async {
    if(userName.isNotEmpty && userEmail.isNotEmpty && userPhone.isNotEmpty && userPass.isNotEmpty){
      UserModel userModel = UserModel(user_name: userName, user_email: userEmail, user_phone: userPhone, user_pass: userPass);
      var db = DBHelper.insertUser(userModel).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data insert..')));
        Navigator.pop(context);
        userNameC.clear();
        userEmailC.clear();
        userPhoneC.clear();
        userPassC.clear();
        setState(() {

        });
      });
    }
  }

  void userDelete(UserModel userModel,String userName) async {

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure $userName"),
          actions: [
            UiHelper.customeButtonText(()  {
              Navigator.pop(context);
            }, 'Cancel'),
            UiHelper.customeButtonText(() async {
              await DBHelper.userDelete(userModel).then((value){
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Delete..')));
                  Navigator.pop(context);
                });
              });
            }, 'Delete'),
          ],
        );
      },);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Logout"),
                  content: Text("Are you sure..."),
                  actions: [
                    UiHelper.customeButtonText(() {
                      Navigator.pop(context);
                    }, 'Cancel'),
                    UiHelper.customeButtonText(()  {
                      loggedOut();
                    }, 'Ok'),
                  ],
                );
              },);

          }, icon: Icon(Icons.more_vert),color: Colors.white,)
        ],
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

      body: FutureBuilder(
        future: DBHelper.getAllUser(),
        builder: (context, snapshot) {
          if(snapshot.connectionState ==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else{
            var userData = snapshot.data;
            return ListView.builder(
              itemCount: userData!.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(userData![index].user_name),
                    subtitle: Text(userData![index].user_email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: (){
                            updateUserNameC.text = userData![index].user_name;
                            updateUserEmailC.text = userData![index].user_email;
                            updateUserPhoneC.text = userData![index].user_phone;
                            updateUserPassC.text = userData![index].user_pass;
                            showModalBottomSheet(
                              context: context, builder: (context) {
                              return Container(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      UiHelper.customeTextField(updateUserNameC, TextInputType.text, 'Name', Icons.person),
                                      UiHelper.customeTextField(updateUserPhoneC, TextInputType.phone, 'Phone', Icons.phone),
                                      UiHelper.customeButton(() async{
                                        var data = UserModel(user_name: updateUserNameC.text.toString(), user_email:userData![index].user_email, user_phone: updateUserPhoneC.text.toString(), user_pass: userData![index].user_pass,user_id: userData![index].user_id);
                                          await DBHelper.userUpdate(data);
                                          setState(() {
                                            Navigator.pop(context);
                                          });
                                      }, 'Update')
                                    ],
                                  ),
                                ),
                              );
                            },);
                          }, child: Icon(Icons.edit,color: Colors.green,)
                        ),
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: (){
                              userDelete(userData![index],userData![index].user_name);
                          }, child: Icon(Icons.delete,color: Colors.red,)
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(
            context: context, builder: (context) {
            return Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UiHelper.customeTextField(userNameC, TextInputType.text, 'Name', Icons.person),
                    UiHelper.customeTextField(userEmailC, TextInputType.emailAddress, 'Email', Icons.mail),
                    UiHelper.customeTextField(userPhoneC, TextInputType.phone, 'Phone', Icons.phone),
                    UiHelper.customeTextField(userPassC, TextInputType.visiblePassword, 'Password', Icons.lock),
                    UiHelper.customeButton(() {
                      var user_name = userNameC.text.toString();
                      var user_email = userEmailC.text.toString();
                      var user_phone = userPhoneC.text.toString();
                      var user_pass = userPassC.text.toString();
                      _saveUserData(user_name, user_email, user_phone, user_pass);
                    }, 'Register')
                  ],
                ),
              ),
            );
          },);
        },
    child: Icon(Icons.add),
      ),
    );
  }

  Future<void> loggedOut() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(SplashScreenState.KEYLOGIN, false).then((value) {
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen(),));
    });

  }



}
