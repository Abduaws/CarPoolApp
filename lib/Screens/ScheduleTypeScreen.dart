import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleTypeScreen extends StatefulWidget {
  const ScheduleTypeScreen({super.key});

  @override
  State<ScheduleTypeScreen> createState() => _ScheduleTypeScreenState();
}

class _ScheduleTypeScreenState extends State<ScheduleTypeScreen> {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * .10),
                  Image.asset(
                    'Assets/Images/LoginCarName.png',
                  ),
                  SizedBox(height: screenHeight * .05),
                  Text("Choose Ride Type", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: GoogleFonts.openSans().fontFamily)),
                  SizedBox(height: screenHeight * .04),
                  SizedBox(
                    width: screenWidth*0.6,
                    height: screenHeight*0.25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff38304C),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/ScheduleScreen', arguments: 'from');
                      }, 
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: screenWidth*0.03),
                            child: Image(
                                  width: screenWidth*0.7,
                                  image: const AssetImage('Assets/Images/fromCollege.png')
                            ),
                          ),  
                          SizedBox(height: screenHeight * .02),
                          Text("From College", style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: GoogleFonts.openSans().fontFamily)),
                        ],
                      )
                    ),
                  ),
                  SizedBox(height: screenHeight * .04),
                  SizedBox(
                    width: screenWidth*0.6,
                    height: screenHeight*0.25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff38304C),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/ScheduleScreen', arguments: 'to');
                      }, 
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: screenWidth*0.03),
                            child: Image(
                                  height: screenHeight*0.13,
                                  image: const AssetImage('Assets/Images/toCollege.png')
                            ),
                          ),  
                          SizedBox(height: screenHeight * .01),
                          Text("To College", style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: GoogleFonts.openSans().fontFamily)),
                        ],
                      )
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
    );
  }
}