import 'package:carpool_demo/Widgets/BookedRideCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookedRidesScreen extends StatefulWidget {
  const BookedRidesScreen({super.key});

  @override
  State<BookedRidesScreen> createState() => _BookedRidesScreenState();
}

class _BookedRidesScreenState extends State<BookedRidesScreen> {
  
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();

  Future<List<Widget>> getBookedRides(screenWidth, screenHeight) async {
    List<Widget> rideList = [];
    DataSnapshot dataSnapshot = await firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}/rides").get();
    Map<Object?, Object?> rides = dataSnapshot.value as Map<Object?, Object?>;
    for( var entryID in rides.keys){
      var rideID = rides[entryID];
      DataSnapshot dataSnapshot = await firebaseDatabase.child("routes/$rideID").get();
      Map<Object?, Object?> rideInfo = dataSnapshot.value as Map<Object?, Object?>;
      if(rideInfo['Status'] == 'Completed' || rideInfo['Status'] == 'Cancelled'){continue;}
      rideList.add(
        generateBookedRideCard(context, screenWidth, rideInfo, rideID, entryID)
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
        title: Text("Booked Rides", style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
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
                    future: getBookedRides(screenWidth, screenHeight),
                    builder: (context, snapshot) {
                      if(snapshot.hasError){
                        return SizedBox(
                          height: screenHeight*0.85,
                          child: Center(child: Text('No Booked Rides', style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)),
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
                            child: Center(child: Text('No Booked Rides', style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)),
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