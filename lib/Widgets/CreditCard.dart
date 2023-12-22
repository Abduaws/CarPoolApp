import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditCard extends StatelessWidget {
  final String? cardNumber;
  final String? cardExp;
  final String? cardID;
  const CreditCard(this.cardNumber, this.cardExp, this.cardID, {super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight*0.3,
      width: screenWidth*0.95,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 53, 8, 166),
        image: DecorationImage(
          image: AssetImage('Assets/Images/CreditCard.png'),
          fit: BoxFit.cover
        ),
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ZeroPool", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                    Text("Card", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                      onPressed: () async{
                        await firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}/creditCards/$cardID").remove();
                      }, 
                      child: const Icon(
                        Icons.delete
                      )
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: screenHeight * .04),
            Text(cardNumber!, style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * .05),
            Text(cardExp!, style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}