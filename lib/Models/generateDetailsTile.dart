import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

Widget generateStartTile(checkedStyle, text, screenWidth, screenHeight, color){
  return TimelineTile(
    beforeLineStyle: const LineStyle(color: Color(0xff10dbcf)),
    indicatorStyle: IndicatorStyle(
      color: color,
      width: 50,
      iconStyle: checkedStyle
    ),
    isFirst: true,
    alignment: TimelineAlign.start,
    endChild: Container(
      constraints: BoxConstraints(minHeight: screenHeight*0.15),
      child: Row(
        children: [
          SizedBox(width: screenWidth*0.05,),
          const Icon(Icons.book_rounded, color: Colors.white, size: 55,),
          SizedBox(width: screenWidth*0.05,),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)
        ],
      ),
    ),
  );
}
Widget generateMidTile(currentNumber, statusNumber, checkedStyle, text, screenWidth, screenHeight, color){
  return TimelineTile(
    beforeLineStyle: const LineStyle(color: Color(0xff0ef1df)),
    indicatorStyle: IndicatorStyle(
      color: color,
      width: 50,
      iconStyle: statusNumber >= currentNumber ? checkedStyle : null
    ),
    alignment: TimelineAlign.start,
    endChild: Container(
      constraints: BoxConstraints(minHeight: screenHeight*0.15),
      child: Row(
        children: [
          SizedBox(width: screenWidth*0.05,),
          const Icon(Icons.library_add_check_rounded, color: Colors.white, size: 55,),
          SizedBox(width: screenWidth*0.05,),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)
        ],
      ),
    ),
  );
}
Widget generateFinishTile(currentNumber, statusNumber, checkedStyle, text, screenWidth, screenHeight, color){
  return TimelineTile(
    beforeLineStyle: const LineStyle(color: Color(0xff01d7fe)),
    indicatorStyle: IndicatorStyle(
      color: color,
      width: 50,
      iconStyle: statusNumber >= currentNumber ? checkedStyle : null
    ),
    isLast: true,
    alignment: TimelineAlign.start,
    endChild: Container(
      constraints: BoxConstraints(minHeight: screenHeight*0.15),
      child: Row(
        children: [
          SizedBox(width: screenWidth*0.05,),
          const Icon(Icons.done_all, color: Colors.white, size: 55,),
          SizedBox(width: screenWidth*0.05,),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)
        ],
      ),
    ),
  );
}