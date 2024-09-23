import 'package:firebasebookingapp/shared/constants.dart';
import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    labelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w300),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor, width: 2.0),
    ));

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void ShowSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message,style: const TextStyle(color: secondaryColor, fontSize: 14.0),),
    backgroundColor: color,
    duration: const  Duration(seconds: 2),
    action: SnackBarAction(label: "OK", onPressed: (){},
    textColor: secondaryColor,
  )));
}
