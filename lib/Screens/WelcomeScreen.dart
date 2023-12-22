import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff201A30),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("Assets/Images/BackGroundPattern.png"), repeat: ImageRepeat.repeat)),
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
                  Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 52, fontFamily: GoogleFonts.openSans().fontFamily)),
                  SizedBox(height: screenHeight * .07),
                  SizedBox(
                    width: screenWidth*0.6,
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
                        Navigator.pushNamed(context, '/LoginDriver');
                      }, 
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                                height: screenHeight*0.13,
                                image: const AssetImage('Assets/Images/Driver.png')
                          ),  
                          SizedBox(height: screenHeight * .01),
                          Text("Driver", style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: GoogleFonts.openSans().fontFamily)),
                        ],
                      )
                    ),
                  ),
                  SizedBox(height: screenHeight * .04),
                  SizedBox(
                    width: screenWidth*0.6,
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
                        Navigator.pushNamed(context, '/Login');
                      }, 
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                                height: screenHeight*0.13,
                                image: const AssetImage('Assets/Images/Rider.png')
                          ),  
                          SizedBox(height: screenHeight * .01),
                          Text("Rider", style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: GoogleFonts.openSans().fontFamily)),
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