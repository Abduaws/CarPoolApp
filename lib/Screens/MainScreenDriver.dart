import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreenDriverDriver extends StatelessWidget {
  const MainScreenDriverDriver({super.key});

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
                children: [
                  SizedBox(height: screenHeight * .15),
                  SizedBox(
                    width: screenWidth*0.85,
                    child: Text("Zero Pool", style: TextStyle(color: Colors.white, fontSize: 48, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: screenHeight * .09),
                  SizedBox(
                    height: screenHeight*0.07,
                    width: screenWidth* 0.90,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff38304C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                      onPressed: (){
                        Navigator.pushNamed(context, '/ScheduleType');
                      }, 
                      child: Text("Schedule A Ride ?", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold))
                    ),
                  ),
                  SizedBox(height: screenHeight * .03),
                  SizedBox(
                    width: screenWidth*0.9,
                    height: screenHeight*0.09,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                      onPressed: (){
                        Navigator.pushNamed(context, '/DriverProfile');
                      }, 
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                                height: screenHeight*0.07,
                                image: const AssetImage('Assets/Images/Profile.png')
                          ),  
                          SizedBox(width: screenHeight * .01),
                          Text("Profile", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily)),
                        ],
                      )
                    ),
                  ),
                  SizedBox(height: screenHeight * .02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth*0.44,
                        height: screenHeight*0.09,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                            ),
                          onPressed: (){
                            Navigator.pushNamed(context, '/DriverHistory');
                          }, 
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                height: screenHeight*0.07,
                                image: const AssetImage('Assets/Images/History.png')
                              ),
                              SizedBox(width: screenHeight * .01),
                              Text("History", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily)),
                            ],
                          )
                        ),
                      ),
                      SizedBox(width: screenHeight * .01),
                      SizedBox(
                        width: screenWidth*0.44,
                        height: screenHeight*0.09,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                            ),
                          onPressed: (){
                            Navigator.pushNamed(context, '/DriverBilling');
                          }, 
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                height: screenHeight*0.07,
                                image: const AssetImage('Assets/Images/Billing.png')
                              ),
                              SizedBox(width: screenHeight * .01),
                              Text("Billing", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * .02),
                  SizedBox(
                    width: screenWidth*0.9,
                    height: screenHeight*0.09,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                      onPressed: (){
                        Navigator.pushNamed(context, '/ScheduledRides');
                      }, 
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                                height: screenHeight*0.07,
                                image: const AssetImage('Assets/Images/Schedule.png')
                          ),  
                          SizedBox(width: screenHeight * .01),
                          Text("Scheduled Rides", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily)),
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