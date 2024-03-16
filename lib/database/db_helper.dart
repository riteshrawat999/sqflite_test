import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_test/model/user_model.dart';

class DBHelper {

  static  String _dbName = 'USER.db';
  static int _version = 1;
  static String _tableName = 'user';

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(),_dbName),
      onCreate: (db, _version) async=> await db.execute(
        'CREATE TABLE $_tableName(user_id INTEGER PRIMARY KEY,user_name TEXT NOT NULL,user_email TEXT NOT NULL,user_phone TEXT NOT NULL,user_pass TEXT NOT NULL)'
      ),
      version: _version
    );
  }

  static Future<int> insertUser(UserModel userModel) async{
    final db = await _getDB();
    return db.insert(_tableName, userModel.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<UserModel>> getAllUser() async{
    final db = await _getDB();
    List<Map<String,dynamic>> maps = await db.query(_tableName);

    return maps.map((e) => UserModel.fromJson(e)).toList();
  }

  static Future<UserModel?> loginUser(String user_email,String user_pass) async{
    final db = await _getDB();
    var res = await db.rawQuery('SELECT * FROM $_tableName WHERE user_email="$user_email" and user_pass = "$user_pass"');
    // var res = await db.rawQuery('SELECTE * FROM $_tableName WHERE user_email =?,[$user_email] AND user_pass =?,[$user_pass}]',);
    if(res.length>0){
      return UserModel.fromJson(res.first);
    }
    return null;
  }
  
  static Future<int> userUpdate(UserModel userModel) async{
    final db = await _getDB();
    return db.update(_tableName, userModel.toMap(),where: 'user_id=?',whereArgs: [userModel.user_id],conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> userDelete(UserModel userModel) async {
    final db = await _getDB();
    return db.delete(_tableName,where: 'user_id=?' ,whereArgs: [userModel.user_id]);
  }


}