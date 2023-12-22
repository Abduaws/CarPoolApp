import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showLoadingDialog(context, loadingText){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      return Center(
        child: Container(
          width: screenWidth*0.85,
          height: screenHeight*0.5,
          decoration: const BoxDecoration(
            color: Color(0xff201A30),
            image: DecorationImage(
              image: AssetImage('Assets/Images/BackGroundPattern.png'),
              repeat: ImageRepeat.repeat
            ),
            borderRadius: BorderRadius.all(Radius.circular(50))
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(loadingText, style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
                Text('', style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
                SizedBox(height: screenHeight*0.04,),
                SizedBox(
                  height: screenHeight*0.1,
                  width: screenHeight*0.1,
                  child: CircularProgressIndicator(
                    strokeWidth: screenWidth * 0.02,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  );
}

showErrorDialog(context, errorText, fontSize){
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      return Center(
        child: Container(
          width: screenWidth*0.85,
          height: screenHeight*0.4,
          decoration: const BoxDecoration(
            color: Color(0xff201A30),
            image: DecorationImage(
              image: AssetImage('Assets/Images/BackGroundPattern.png'),
              repeat: ImageRepeat.repeat
            ),
            borderRadius: BorderRadius.all(Radius.circular(50))
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(errorText, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: fontSize, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
                Text('', style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
                SizedBox(height: screenHeight*0.01,),
                SizedBox(
                  height: screenHeight*0.1,
                  width: screenHeight*0.1,
                  child: Icon(
                    Icons.error_rounded,
                    size: screenWidth * 0.2,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  );
}