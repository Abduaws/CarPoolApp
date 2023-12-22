import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

buildCustomInputField(BuildContext context, String labelText, dynamic controller, String inputType){
  
  bool isPassword = false;
  TextInputType inputFieldType = TextInputType.text;
  if(inputType == "email"){inputFieldType = TextInputType.emailAddress;}
  else if(inputType == "password"){inputFieldType = TextInputType.visiblePassword;isPassword = true;}
  else if(inputType == "phone"){inputFieldType = TextInputType.phone;}

  double screenWidth = MediaQuery.of(context).size.width;
  return TextField(
    keyboardType: inputFieldType,
    obscureText: isPassword,
    controller: controller,
    cursorColor: Colors.white,
    style: const TextStyle(
      color: Colors.white,
    ),
    decoration: InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: BoxConstraints(maxWidth: screenWidth*0.9),
      labelStyle: TextStyle(color: Colors.white, fontSize: 24, fontFamily: GoogleFonts.openSans().fontFamily),
      filled: true,
      fillColor: const Color(0xff38304C),
      labelText: labelText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
