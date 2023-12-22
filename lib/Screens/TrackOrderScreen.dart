import 'dart:math';

import 'package:carpool_demo/Models/generateDetailsTile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Map rideInfo = ModalRoute.of(context)!.settings.arguments as Map;
    IconStyle checkedStyle = IconStyle(
      iconData: Icons.check_rounded,
      color: Colors.black,
      fontSize: screenWidth*0.1
    );
    int statusNumber = 0;
    if(rideInfo['Status'] == 'Available'){rideInfo['Status'] = 'Ride Booked';statusNumber = 0;}
    if(rideInfo['Status'] == 'Confirmed'){rideInfo['Status'] = 'Ride Confirmed';statusNumber = 1;}
    if(rideInfo['Status'] == 'Started'){rideInfo['Status'] = 'Waiting for Driver';statusNumber = 2;}
    if(rideInfo['Status'] == 'Arrived'){rideInfo['Status'] = 'Driver Arrived';statusNumber = 3;}
    if(rideInfo['Status'] == 'Completed'){rideInfo['Status'] = 'Ride Completed';statusNumber = 4;}
    if(rideInfo['Status'] == 'Cancelled'){
      rideInfo['Status'] = 'Ride Cancelled';
      statusNumber = 5;
      checkedStyle = IconStyle(
        iconData: Icons.close_rounded,
        color: Colors.black,
        fontSize: screenWidth*0.1
      );
    }
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text("Ride Details", style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: const Color(0xff201A30),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Assets/Images/BackGroundPattern.png'),
            repeat: ImageRepeat.repeat
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight*0.1,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: screenHeight * .10,
                  width: screenWidth*0.45,
                  decoration: const BoxDecoration(
                    color:  Color(0xff38304C),
                    image: DecorationImage(
                      image: AssetImage('Assets/Images/BackGroundPattern.png'),
                      repeat: ImageRepeat.repeat
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: screenWidth*0.07,),
                      const Icon(Icons.access_time_filled, color: Colors.white, size: 35,),
                      SizedBox(width: screenWidth*0.03,),
                      Text(rideInfo['Duration'], style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                Container(
                  height: screenHeight * .10,
                  width: screenWidth*0.45,
                  decoration: const BoxDecoration(
                    color:  Color(0xff38304C),
                    image: DecorationImage(
                      image: AssetImage('Assets/Images/BackGroundPattern.png'),
                      repeat: ImageRepeat.repeat
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: screenWidth*0.07,),
                      const Icon(Icons.attach_money_rounded, color: Colors.white, size: 35,),
                      SizedBox(width: screenWidth*0.03,),
                      Text(rideInfo['Price'], style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight*0.03,),
            Stack(
              children: [
                Container(
                  height: screenHeight*0.75,
                  width: screenWidth*0.95,
                  decoration: const BoxDecoration(
                    color:  Color(0xff38304C),
                    borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(width: screenWidth*0.07,),
                        SizedBox(
                          width: screenWidth*0.85,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              generateStartTile(checkedStyle, 'Ride Booked', screenWidth, screenHeight, const Color(0xff10dbcf)),
                              generateMidTile(1, statusNumber, checkedStyle, 'Ride Confirmed', screenWidth, screenHeight, const Color(0xff0ef1df)),
                              generateMidTile(2, statusNumber, checkedStyle, 'Waiting for Driver', screenWidth, screenHeight, const Color(0xff0af5ee)),
                              generateMidTile(3, statusNumber, checkedStyle, 'Driver Arrived', screenWidth, screenHeight, const Color(0xff04e4f9)),
                              generateFinishTile(4, statusNumber, checkedStyle, 'Ride Completed', screenWidth, screenHeight, const Color(0xff01d7fe)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                statusNumber == 5 ? Container(
                  height: screenHeight*0.75,
                  width: screenWidth*0.95,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(150, 0, 0, 0),
                    borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: Center(
                    child: Transform.rotate(angle: -pi/6, child: Text("Cancelled", style: TextStyle(color: Colors.red.shade900, fontSize: 72, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),))
                  ),
                )
                : SizedBox()
              ],
            )
          ]
        )
      )
    );
  }
}