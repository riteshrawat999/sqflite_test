import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiHelper {

  static Widget customeTextField(TextEditingController controller,TextInputType inputType,String label,IconData iconData){
    return Container(
      padding: EdgeInsets.all(11),
      child: TextFormField(
        validator: (value) {
          if(value.toString().isEmpty){
            return 'Required..';
          }
        },
        keyboardType: inputType,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(iconData),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11)
          )
        ),
      ),
    );
  }
  
  static Widget customeButton(VoidCallback voidCallback,String label) {
    return ElevatedButton(
        onPressed: voidCallback, 
        child: Text(label,style: TextStyle(color: Colors.white),),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11)
        )
      ),
    );
  }
  static Widget customeButtonText(VoidCallback voidCallback,String label) {
    return ElevatedButton(
        onPressed: voidCallback,
        child: Text(label,style: TextStyle(color: Colors.white),),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11)
        )
      ),
    );
  }




}