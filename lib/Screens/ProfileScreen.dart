import 'package:carpool_demo/Models/DatabaseController.dart';
import 'package:carpool_demo/Widgets/BottomSheetFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseController databaseController = DatabaseController();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();

  String name = '';
  String mobile = '';

  Future<Map> getInfoFromDatabase(bool useSqflite) async{
    if(useSqflite){
      List<Map> usersInfo = await databaseController.query("SELECT * FROM USERS WHERE EMAIL='user_${firebaseAuth.currentUser?.email}'");
      return usersInfo[0];
    }
    else{
      DataSnapshot dataSnapshot = await firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}").get();
      Map<Object?, Object?> userInfo = dataSnapshot.value as Map<Object?, Object?>;
      return userInfo;
    }
  }


  @override
  Widget build(BuildContext context) {
    firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}").onChildChanged.listen((event) {
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
          future: getInfoFromDatabase(false),
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
                        Text(snapshot.data?['FullName'], style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
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
                                displayProfileBottomSheet(context, snapshot.data?['FullName'].toString(), snapshot.data?['Phone'].toString(), snapshot.data);
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
                      SizedBox(height: screenHeight * .07),
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
                            Text(firebaseAuth.currentUser!.email.toString().replaceAll("user_", "") ,textAlign: TextAlign.center, style: TextStyle(color: const Color(0xff1E1E32), fontSize: 16, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
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
                            Text(snapshot.data?['Phone'], textAlign: TextAlign.center, style: TextStyle(color: const Color(0xff1E1E32), fontSize: 16, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
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