import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget generatePredictionCard(screenWidth, screenHeight, predictionInfo){
  print(predictionInfo);
  return Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)
  ),
  color: const Color(0xff38304C),
  child: SizedBox(
    width: screenWidth*0.9,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const Icon(Icons.location_on_sharp, color: Colors.white, size: 32,),
          SizedBox(width: screenWidth*0.03,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: screenWidth*0.75, child: Text("${predictionInfo['structured_formatting']['main_text']}", style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white))),
              SizedBox(height: screenHeight*0.01,),
              SizedBox(width: screenWidth*0.75, child: Text("${predictionInfo['structured_formatting']['secondary_text']}", softWrap: true, style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white54))),
            ],
          ),
        ],
      )
      ),
    ),
  );
}