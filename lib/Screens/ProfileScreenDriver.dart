import 'package:carpool_demo/Widgets/BottomSheetFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreenDriver extends StatefulWidget {
  const ProfileScreenDriver({super.key});

  @override
  State<ProfileScreenDriver> createState() => _ProfileScreenDriverState();
}

class _ProfileScreenDriverState extends State<ProfileScreenDriver> {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();

  Future<Map> getInfoFromDatabase() async{
    DataSnapshot dataSnapshot = await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}").get();
    Map<Object?, Object?> userInfo = dataSnapshot.value as Map<Object?, Object?>;
    return userInfo;
  }

  @override
  Widget build(BuildContext context) {
    firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}").onChildChanged.listen((event) {
        if(mounted){
          setState(() {});
        }
      });

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text("Profile", style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: const Color(0xff201A30),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Assets/Images/BackGroundPattern.png'),
            repeat: ImageRepeat.repeat
          ),
        ),
        child: FutureBuilder(
          future: getInfoFromDatabase(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Column(
                children: [
                  Container(
                    height: screenHeight*0.7,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color:  Color(0xff38304C),
                      image: DecorationImage(
                        image: AssetImage('Assets/Images/BackGroundPattern.png'),
                        repeat: ImageRepeat.repeat
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * .20),
                        const CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage('Assets/Images/ProfilePic.jpeg'),
                          backgroundColor: Colors.black,
                        ),
                        SizedBox(height: screenHeight * .02),
                        Text(snapshot.data!['FullName'].toString(), style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                        SizedBox(height: screenHeight * .1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff0DF5E3),
                                padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 10),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                                ),
                              onPressed: (){
                                displayDriverProfileBottomSheet(context, snapshot.data!['FullName'].toString(), snapshot.data!['Phone'].toString(), snapshot.data!['CarType'].toString(), snapshot.data);
                              }, 
                              child: Text("Edit Profile", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily))
                            ),
                            SizedBox(width: screenWidth * .02),
                            CircleAvatar(
                              backgroundColor: const Color(0xff0DF5E3),
                              child: IconButton(
                                color: const Color(0xff1E1E32),
                                onPressed: (){},
                                icon: const Icon(Icons.camera_alt)
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * .03),
                      Container(
                        height: screenHeight*0.07,
                        width: screenWidth*0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xff38304C), width: 3),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: screenWidth * .02),
                            const Icon(Icons.person),
                            SizedBox(width: screenWidth * .02),
                            Text(firebaseAuth.currentUser!.email.toString().replaceAll("driver_", "") ,textAlign: TextAlign.center, style: TextStyle(color: const Color(0xff1E1E32), fontSize: 16, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * .02),
                      Container(
                        height: screenHeight*0.07,
                        width: screenWidth*0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xff38304C), width: 3),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: screenWidth * .02),
                            const Icon(Icons.phone_android),
                            SizedBox(width: screenWidth * .02),
                            Text(snapshot.data!['Phone'].toString(), textAlign: TextAlign.center, style: TextStyle(color: const Color(0xff1E1E32), fontSize: 16, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * .02),
                      Container(
                        height: screenHeight*0.07,
                        width: screenWidth*0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xff38304C), width: 3),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: screenWidth * .02),
                            const Icon(Icons.drive_eta_rounded),
                            SizedBox(width: screenWidth * .02),
                            Text(snapshot.data!['CarType'].toString(), textAlign: TextAlign.center, style: TextStyle(color: const Color(0xff1E1E32), fontSize: 16, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
            else{
              return const Center(child: CircularProgressIndicator(color: Colors.white,));
            }
          }
        ),
      )
    );
  }
}