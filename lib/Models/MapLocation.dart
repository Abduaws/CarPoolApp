import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MapLocation extends StatelessWidget {
  final String? mainText;
  final String? subText;
  final IconData? icon;
  const MapLocation({super.key, this.mainText, this.subText, this.icon});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth= MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff38304C),
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      child: SizedBox(
        height: screenHeight*0.1,
        child: Row(
          children: [
            SizedBox(width: screenWidth*0.03,),
            Icon(icon, color: Colors.white, size: screenWidth*0.07,),
            SizedBox(width: screenWidth*0.03,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mainText!, style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                SizedBox(height: screenHeight*0.01,),
                Text(subText!, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}