import 'package:carpool_demo/Widgets/BottomSheetFunctions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

Widget generateScheduledRideCard(context, screenWidth, rideInfo, rideID){
  return Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)
  ),
  color: const Color(0xff38304C),
  child: SizedBox(
    width: screenWidth*0.9,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
          children: [
            TimelineTile(
              afterLineStyle: const LineStyle(color: Colors.white),
              indicatorStyle: IndicatorStyle(
                color: Colors.white,
                width: 50,
                iconStyle: IconStyle(
                  iconData: Icons.arrow_circle_up,
                  color: const Color(0xff201A30)
                )
              ),
              isFirst: true,
              alignment: TimelineAlign.start,
              endChild: Container(
                constraints: const BoxConstraints(minHeight: 75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenWidth*0.03,),
                    Text('  Pick Up', style: TextStyle(color: const Color(0xff0DF5E3), fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text('${rideInfo["from"]}', style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
            ),
            TimelineTile(
              beforeLineStyle: const LineStyle(color: Colors.white),
              indicatorStyle: IndicatorStyle(
                color: Colors.white,
                width: 50,
                iconStyle: IconStyle(
                  iconData: Icons.arrow_circle_down,
                  color: const Color(0xff201A30)
                )
              ),
              isLast: true,
              alignment: TimelineAlign.start,
              endChild: Container(
                constraints: const BoxConstraints(minHeight: 75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenWidth*0.03,),
                    Text('  Drop Off', style: TextStyle(color: const Color(0xff0DF5E3), fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text('${rideInfo["to"]}', style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text('${rideInfo["PassengerCount"]}/${rideInfo["MaxPassengerCount"]}', style: TextStyle(color: Colors.white54, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0DF5E3),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                ),
              onPressed: (){
                displayScheduledRideBottomSheet(context, rideInfo, rideID);
              }, 
              child: Text("Update Status", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily))
            ),
          ],
        )
      ),
    ),
  );
}