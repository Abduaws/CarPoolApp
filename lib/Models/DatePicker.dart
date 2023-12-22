import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget constructDatePickerRider(context, date, time){
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth= MediaQuery.of(context).size.width;
  return Container(
    width: screenWidth*0.85,
    height: screenHeight*0.3,
    decoration: const BoxDecoration(
      color: Color(0xff38304C),
      borderRadius: BorderRadius.all(Radius.circular(25))
    ),
    child: Padding(
      padding: EdgeInsets.only(left: screenWidth*0.1, top: screenHeight*0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Date", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
          SizedBox(height: screenHeight*0.01,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * .5,
                height: screenHeight *.07,
                decoration: const BoxDecoration(
                  color: Color(0xff201A30),
                  borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                child: Center(
                  child: Text(date, style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)
                )
              ),
              SizedBox(width: screenWidth*0.07,)
            ],
          ),
          SizedBox(height: screenHeight*0.02,),
          Text("Time", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
          SizedBox(height: screenHeight*0.01,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * .5,
                height: screenHeight *.07,
                decoration: const BoxDecoration(
                  color: Color(0xff201A30),
                  borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                child: Center(
                  child: Text(time, style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)
                )
              ),
              SizedBox(width: screenWidth*0.07,)
            ],
          ),
        ],
      ),
    ),
  );
}

Widget constructDatePickerDriver(context, dateController, timeController, scheduleType){
  String dropdownText = '';
  if(scheduleType == 'from'){dropdownText = "5:30 PM";}
  else{dropdownText = "7:30 AM";}
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth= MediaQuery.of(context).size.width;
  return Container(
    width: screenWidth*0.85,
    height: screenHeight*0.3,
    decoration: const BoxDecoration(
      color: Color(0xff38304C),
      borderRadius: BorderRadius.all(Radius.circular(25))
    ),
    child: Padding(
      padding: EdgeInsets.only(left: screenWidth*0.1, top: screenHeight*0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Date", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
          SizedBox(height: screenHeight*0.01,),
          DropdownMenu(
            controller: dateController,
            width: screenWidth*0.65,
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
            initialSelection: 'Today',
            textStyle: TextStyle(
              fontFamily: GoogleFonts.openSans().fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white
            ),
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 'Today', label: 'Today'),
              DropdownMenuEntry(value: 'Tomorrow', label: 'Tomorrow'),
            ],
          ),
          SizedBox(height: screenHeight*0.02,),
          Text("Time", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
          SizedBox(height: screenHeight*0.01,),
          DropdownMenu(
            controller: timeController,
            width: screenWidth*0.65,
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
            initialSelection: dropdownText,
            textStyle: TextStyle(
              fontFamily: GoogleFonts.openSans().fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white
            ),
            dropdownMenuEntries: [
              DropdownMenuEntry(value: dropdownText, label: dropdownText),
            ],
          ),
        ],
      ),
    ),
  );
}