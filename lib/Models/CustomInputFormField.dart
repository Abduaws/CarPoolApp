import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

buildCustomInputFormField(BuildContext context, String labelText, dynamic controller, String inputType, String? Function(String?) validator){
  
  bool isPassword = false;
  TextInputType inputFieldType = TextInputType.text;
  if(inputType == "email"){inputFieldType = TextInputType.emailAddress;}
  else if(inputType == "password"){inputFieldType = TextInputType.visiblePassword;isPassword = true;}
  else if(inputType == "phone"){inputFieldType = TextInputType.phone;}

  double screenWidth = MediaQuery.of(context).size.width;
  return TextFormField(
    validator: validator,
    keyboardType: inputFieldType,
    obscureText: isPassword,
    controller: controller,
    cursorColor: Colors.white,
    style: TextStyle(
      color: Colors.white,
      fontFamily: GoogleFonts.openSans().fontFamily
    ),
    decoration: InputDecoration(
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade900, width: 2),
        borderRadius: BorderRadius.circular(12)
      ),
      errorStyle: TextStyle(
        color: Colors.red,
        fontSize: 18,
        fontFamily: GoogleFonts.openSans().fontFamily 
      ),
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
