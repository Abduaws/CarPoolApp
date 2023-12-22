import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<Widget> generateScheduleBar(type, fromController, toControllet, screenWidth, screenHeight, changeHandler){
  List<Widget> conditionalWidgets = [];
  if(type == 'from'){
    conditionalWidgets.add(getDropDown('From', screenWidth, screenHeight, fromController));
    conditionalWidgets.add(SizedBox(height: screenHeight*0.03,),);
    conditionalWidgets.add(getSearch('To', screenWidth, screenHeight, toControllet, changeHandler));
  }
  else{
    conditionalWidgets.add(getSearch('From', screenWidth, screenHeight, fromController, changeHandler));
    conditionalWidgets.add(SizedBox(height: screenHeight*0.03,),);
    conditionalWidgets.add(getDropDown('To', screenWidth, screenHeight, toControllet));
  }
  return conditionalWidgets;
}

Widget getSearch(text, screenWidth, screenHeight, controller, changeHandler){
  return Row(
    children: [
      const Icon(Icons.location_on_sharp, color: Colors.white,),
      SizedBox(width: screenWidth*0.03,),
      SizedBox(
        width: screenWidth*0.8,
        child: TextField(
          onChanged: (value) {
            changeHandler();
          },
          controller: controller,
          style: TextStyle(
            fontFamily: GoogleFonts.openSans().fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: screenWidth*0.047, horizontal: screenWidth*0.03),
            hintText: text,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            filled: true,
            fillColor: const Color(0xff201A30),
            hintStyle: TextStyle(
              fontFamily: GoogleFonts.openSans().fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white
            ),
            isDense: true,
          ),
        ),
      ),
    ],
    );
}

Widget getDropDown(text, screenWidth, screenHeight, controller){
  return Row(
    children: [
      const Icon(Icons.location_on_sharp, color: Colors.white,),
      SizedBox(width: screenWidth*0.03,),
      DropdownMenu(
        controller: controller,
        width: screenWidth*0.8,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            fontFamily: GoogleFonts.openSans().fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white
          ),
          filled: true,
          fillColor: const Color(0xff201A30),
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          iconColor: Colors.white,
          suffixIconColor: Colors.white,
        ),
        menuStyle: const MenuStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.white),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))
          ))
        ),
        hintText: text,
        textStyle: TextStyle(
          fontFamily: GoogleFonts.openSans().fontFamily,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white
        ),
        dropdownMenuEntries: const [
          DropdownMenuEntry(value: 'Gate 3', label: 'Gate 3'),
          DropdownMenuEntry(value: 'Gate 2', label: 'Gate 2'),
        ],
      ),
    ],
  );
}