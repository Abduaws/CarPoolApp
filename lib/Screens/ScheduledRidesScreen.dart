import 'package:carpool_demo/Widgets/ScheduledRideCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ScheduledRidesScreen extends StatefulWidget {
  const ScheduledRidesScreen({super.key});

  @override
  State<ScheduledRidesScreen> createState() => _ScheduledRidesScreenState();
}

class _ScheduledRidesScreenState extends State<ScheduledRidesScreen> {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();

  Future<List<Widget>> getScheduledRides(screenWidth, screenHeight) async {
    List<Widget> rideList = [];
    DataSnapshot dataSnapshot = await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}/rides").get();
    Map<Object?, Object?> rides = dataSnapshot.value as Map<Object?, Object?>;
    for( var rideID in rides.values){
      DataSnapshot dataSnapshot = await firebaseDatabase.child("routes/$rideID").get();
      Map<Object?, Object?> rideInfo = dataSnapshot.value as Map<Object?, Object?>;
      DateTime rideDate = DateTime.parse(rideInfo['PickUpDate'] as String);
      bool continueCheck = false;
      if(rideDate.add(const Duration(days: 1)).isBefore(DateTime.now()) && rideInfo['Status'] != 'Completed' ){
        continueCheck = true;
        rideInfo['Status'] = 'Cancelled';
        await firebaseDatabase.child("routes/$rideID").set(rideInfo);
        await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}/history").push().set(rideInfo);
        try{
          for(var userInfo in (rideInfo["users"] as Map<Object?, Object?>).values){
            userInfo as Map<Object?, Object?>;
            var userID = userInfo['userID'];
            String paymentType = userInfo['paymentType'] as String;
            userID as String;
            if(paymentType != "Cash Payment"){
              await firebaseDatabase.child("users/$userID/transactionLog").push().set(
                {
                  "Date": DateFormat("dd-MMM-yyyy").format(DateTime.now()),
                  "Time": DateFormat('hh:mm a').format(DateTime.now()),
                  "Ammount": '${rideInfo['Price']}',
                  "Type": 'Ride Refund'
                }
              );
            }
          }
          continue;
        } catch (e) {
          print(e);
          continue;
        }
      }
      if(rideInfo['Status'] == 'Completed' || rideInfo['Status'] == 'Cancelled' || continueCheck){continue;}
      rideList.add(
        generateScheduledRideCard(context, screenWidth, rideInfo, rideID)
      );
      rideList.add(SizedBox(height: screenHeight * .03),);
    };
    return rideList;
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    firebaseDatabase.child("routes").onChildChanged.listen((event) {
      if(mounted){
        setState(() {});
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text("Scheduled Rides", style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: const Color(0xff201A30),
        body: Container(
          height: double.infinity,
          decoration:const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/Images/BackGroundPattern.png'),
              repeat: ImageRepeat.repeat
            )
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * .10),
                  FutureBuilder(
                    future: getScheduledRides(screenWidth, screenHeight),
                    builder: (context, snapshot) {
                      if(snapshot.hasError){
                        return SizedBox(
                          height: screenHeight*0.85,
                          child: Center(child: Text('No Scheduled Rides', style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)),
                        );
                      }
                      if(snapshot.hasData){
                        if(snapshot.data!.isNotEmpty){
                          return Column(
                            children: [
                              ...?snapshot.data
                            ],
                          );
                        }
                        else{
                          return SizedBox(
                            height: screenHeight*0.85,
                            child: Center(child: Text('No Scheduled Rides', style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)),
                          );
                        }
                      }
                      else{
                        return SizedBox(
                          height: screenHeight*0.85,
                          child: const Center(child: CircularProgressIndicator(color: Colors.white,),),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        )
    );
  }
}