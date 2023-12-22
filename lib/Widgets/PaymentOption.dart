import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget generatePaymentOption(context, optionText, optionSubText, optionImage, selectCurrent, currentSelection){
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  Color backgroundColor = const Color(0xff38304C);
  List<Widget> displayedWidgets = [
    SizedBox(width: screenWidth*0.07,),
    Container(
      width: screenWidth*0.1,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(optionImage),
          fit: BoxFit.fitWidth
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50))
      ),
    ),
    SizedBox(width: screenWidth*0.03,)
  ];
  if(optionSubText == ''){
    displayedWidgets.add(Text(optionText, style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)));
  }
  else{
    displayedWidgets.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(optionText, style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
          Text(optionSubText, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
        ],
      )
    );
  }
  if(currentSelection == optionText+optionSubText){
    backgroundColor = Color.fromARGB(255, 86, 74, 118);
  }
  return GestureDetector(
    onTap: () {
      selectCurrent(optionText+optionSubText);
    },
    child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50)
    ),
    color: backgroundColor,
    child: Container(
        height: screenHeight*0.1,
        width: screenWidth*0.95,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(50))
        ),
        child: Center(
          child: Row(
            children: displayedWidgets,
          ),
        ),
      ),
    ),
  );
}