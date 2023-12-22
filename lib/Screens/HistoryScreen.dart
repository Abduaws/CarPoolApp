import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final List<Map<String, String>> historyLog = const [
    {"PickUp": "Home", "PickUpTime": "11:30 AM", "DropOff":"AinShams", "DropOffTime": "8:00 AM", "Price":"\$77.5", "CarType":"Audi", "Status":'Ride Booked', "Duration":'45 min'},
    {"PickUp": "Abbasya", "PickUpTime": "11:30 AM", "DropOff":"AinShams", "DropOffTime": "8:00 AM", "Price":"\$55.5", "CarType":"Audi", "Status":'Ride Confirmed', "Duration":'15 min'},
    {"PickUp": "Roxy", "PickUpTime": "11:30 AM", "DropOff":"AinShams", "DropOffTime": "8:00 AM", "Price":"\$7.5", "CarType":"Audi", "Status":'Waiting for Driver', "Duration":'30 min'},
    {"PickUp": "Ramsees", "PickUpTime": "11:30 AM", "DropOff":"AinShams", "DropOffTime": "8:00 AM", "Price":"\$32.5", "CarType":"Audi", "Status":'Driver Arrived', "Duration":'25 min'},
    {"PickUp": "Mokattam", "PickUpTime": "11:30 AM", "DropOff":"AinShams", "DropOffTime": "8:00 AM", "Price":"\$17.5", "CarType":"Audi", "Status":'Ride Completed', "Duration":'50 min'},
  ];

  addHistory(){
    historyLog.forEach((log) async {
      await firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}/history").push().set(
        {
          "PickUp": log['PickUp'],
          "PickUpTime": log['PickUpTime'],
          "DropOff":log['DropOff'],
          "DropOffTime": log['DropOffTime'], 
          "Price":log['Price'], 
          "CarType":log['CarType'], 
          "Status":log['Status'], 
          "Duration":log['Duration']
        }
      );
    });
  }

  Future<List<Map<Object?, Object?>>> getHistory() async {
    List<Map<Object?, Object?>> historyList = [];
    DataSnapshot dataSnapshot = await firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}/rides").get();
    Map<Object?, Object?> allUserRides = dataSnapshot.value as Map<Object?, Object?>;
    DataSnapshot dataSnapshot2 = await firebaseDatabase.child("routes").get();
    Map<Object?, Object?> allRides = dataSnapshot2.value as Map<Object?, Object?>;
    allUserRides.forEach((entryID, rideID) {
      Map<Object?, Object?> rideInfo = allRides[rideID] as Map<Object?, Object?>;
      if(rideInfo['Status'] == 'Completed' || rideInfo["Status"] == 'Cancelled'){
        historyList.add(rideInfo);
      }
    });
    return historyList;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    firebaseDatabase.child("routes").onChildChanged.listen((event) {
      if(mounted && ModalRoute.of(context)?.settings.name == "/History"){
        setState(() {});
      }
    });
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text("History", style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
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
                    future: getHistory(),
                    builder: (context, snapshot) {
                      if(snapshot.hasError){
                        return SizedBox(
                          height: screenHeight*0.85,
                          child: Center(child: Text('No History', style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)),
                        );
                      }
                      if(snapshot.hasData){
                        if(snapshot.data!.isNotEmpty){
                          return Column(
                            children: [
                              ...snapshot.data!.map((log) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, '/TrackOrder', arguments: log);
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        color: const Color(0xff38304C),
                                        child: SizedBox(
                                          width: screenWidth*0.9,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Center(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(' Pick Up', style: TextStyle(color: const Color(0xff0DF5E3), fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                                                      Text("${log['PickUpTime']}", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text("${log['PickUp']}",textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                                                  ),
                                                  SizedBox(height: screenHeight * .01),
                                                  const Divider(
                                                    color: Color(0xff201A30),
                                                    thickness: 5,
                                                  ),
                                                  SizedBox(height: screenHeight * .01),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(' Drop Off', style: TextStyle(color: const Color(0xff0DF5E3), fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                                                      Text("${log['DropOffTime']}", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: Text("${log['DropOff']}", style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                                                  ),
                                                  SizedBox(height: screenHeight * .03),
                                                  Image.asset('Assets/Images/RideCar.png'),
                                                  SizedBox(height: screenHeight * .02),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("${log['CarType']}", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                                                      Text("\$${log['Price']}", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * .03),
                                  ],
                                );
                              }).toList()
                            ],
                          );
                        }
                        else{
                          return SizedBox(
                            height: screenHeight*0.85,
                            child: Center(child: Text('No History', style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)),
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