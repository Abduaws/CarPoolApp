import 'package:carpool_demo/Models/CustomDialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

Widget generateBookedRideCard(context, screenWidth, rideInfo, rideID, entryID){
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
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/TrackOrder', arguments: rideInfo);
              },
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
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                ),
              onPressed: () async{
                if(rideInfo['Status'] != 'Available' && rideInfo['Status'] != 'Confirmed'){
                  showErrorDialog(context, 'Ride Already\nStarted', 32.0);
                  return;
                }
                showLoadingDialog(context, 'Cancelling Ride');
                DataSnapshot snapshot = await FirebaseDatabase.instance.ref('routes/$rideID/PassengerCount').get();
                int currentPassengerCount = int.parse(snapshot.value as String);
                await FirebaseDatabase.instance.ref('routes/$rideID/isFull').set(false);
                await FirebaseDatabase.instance.ref('routes/$rideID/PassengerCount').set("${currentPassengerCount - 1}");
                String deletionID = '';
                String paymentType = '';
                for(var entryID in (rideInfo["users"] as Map<Object?, Object?>).keys){
                  entryID as String;
                  if(rideInfo["users"][entryID]['userID'] as String == FirebaseAuth.instance.currentUser?.uid as String){
                    deletionID = entryID;
                    paymentType = rideInfo['users'][entryID]['paymentType'];
                    break;
                  }
                }
                await FirebaseDatabase.instance.ref('users/${FirebaseAuth.instance.currentUser?.uid}/rides/$entryID').remove();
                await FirebaseDatabase.instance.ref('routes/$rideID/users/$deletionID').remove();
                if(paymentType == "Card Payment"){
                  await FirebaseDatabase.instance.ref("users/${FirebaseAuth.instance.currentUser?.uid}/transactionLog").push().set(
                    {
                      "Date": DateFormat("dd-MMM-yyyy").format(DateTime.now()),
                      "Time": DateFormat('hh:mm a').format(DateTime.now()),
                      "Ammount": '${rideInfo['Price']}',
                      "Type": 'Ride Refund'
                    }
                  );
                }
                
                Navigator.pop(context);
                Navigator.pop(context);
              }, 
              child: Text("Cancel Ride", style: TextStyle(color: Colors.white, fontFamily: GoogleFonts.openSans().fontFamily))
            ),
          ],
        )
      ),
    ),
  );
}