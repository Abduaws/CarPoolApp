import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreenDriver extends StatefulWidget {
  const HistoryScreenDriver({super.key});

  @override
  State<HistoryScreenDriver> createState() => _HistoryScreenDriverState();
}

class _HistoryScreenDriverState extends State<HistoryScreenDriver> {

  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<List<Map<Object?, Object?>>> getHistory() async {
    List<Map<Object?, Object?>> historyList = [];
    DataSnapshot dataSnapshot = await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}/history").get();
    Map<Object?, Object?> allHistory = dataSnapshot.value as Map<Object?, Object?>;
    allHistory.forEach((history, historyInfo) {
      historyInfo as Map<Object?, Object?>;
      historyList.add(historyInfo);
    });
    return historyList;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}/history").onChildChanged.listen((event) {
      if(mounted){
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
                                print(log);
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, '/DriverHistoryInfo', arguments: {
                                          "Price":"${log['Price']!}",
                                          "Status":log['Status']!, 
                                          "Duration":log['Duration']!
                                        });
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
                                                    child: Text("${log['PickUp']!}",textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
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
                                                    child: Text("${log['DropOff']!}", style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
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