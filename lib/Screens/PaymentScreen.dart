import 'package:carpool_demo/Models/CustomDialogs.dart';
import 'package:carpool_demo/Widgets/PaymentOption.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  dynamic currentSelection = "Cash Payment";
  DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
  Future<List<Map<Object?, Object?>>> getCreditCards() async {
    List<Map<Object?, Object?>> cardList = [];
    DataSnapshot dataSnapshot = await firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}/creditCards").get();
    Map<Object?, Object?> allCards = dataSnapshot.value as Map<Object?, Object?>;
    allCards.forEach((card, cardInfo) {
      cardInfo as Map<Object?, Object?>;
      cardList.add(cardInfo);
    });
    return cardList;
  }

  selectCurrent(selection){
    currentSelection = selection;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Map routeInfo = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text("Payment Details", style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: const Color(0xff201A30),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Assets/Images/BackGroundPattern.png'),
            repeat: ImageRepeat.repeat
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * .15),
                  Container(
                    height: screenHeight*0.1,
                    width: screenWidth*0.95,
                    decoration: const BoxDecoration(
                      color:  Color(0xff38304C),
                      image: DecorationImage(
                        image: AssetImage('Assets/Images/BackGroundPattern.png'),
                        repeat: ImageRepeat.repeat
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Total Ride Fees", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                          Text("\$${routeInfo['Price']}", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * .07),
                  SizedBox(
                    width: screenWidth*0.9,
                    child: Text("Payment Methods", style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold))
                  ),
                  SizedBox(height: screenHeight * .01),
                  generatePaymentOption(context, 'Cash Payment', '', 'Assets/Images/cashOption.png', selectCurrent, currentSelection),
                  FutureBuilder(
                    future: getCreditCards(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return Column(
                          children: snapshot.data!.map((creditCard){
                            return generatePaymentOption(context, 'Credit Card', '${creditCard["number"].toString().substring(0,4)} •••• •••• ${creditCard["number"].toString().substring(creditCard["number"].toString().length-4,creditCard["number"].toString().length)}', 'Assets/Images/creditCardOption.png', selectCurrent, currentSelection);
                          }).toList(),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              left: screenWidth*0.05,
              right: screenWidth*0.05,
              bottom: screenHeight*0.03,
              child: SizedBox(
                height: screenHeight*0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0DF5E3),
                    padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  onPressed: () async {
                    showLoadingDialog(context, 'Processing Payment');
                    DataSnapshot snapshot = await FirebaseDatabase.instance.ref('routes/${routeInfo["ID"]}/PassengerCount').get();
                    DataSnapshot snapshot2 = await FirebaseDatabase.instance.ref('routes/${routeInfo["ID"]}/MaxPassengerCount').get();
                    int currentPassengerCount = int.parse(snapshot.value as String);
                    int maxPassengerCount = int.parse(snapshot2.value as String);
                    if(currentPassengerCount + 1 == maxPassengerCount){
                      await FirebaseDatabase.instance.ref('routes/${routeInfo["ID"]}/isFull').set(true);
                    }
                    await FirebaseDatabase.instance.ref('routes/${routeInfo["ID"]}/PassengerCount').set("${currentPassengerCount + 1}");
                    String paymentType = "Cash Payment";
                    if(currentSelection != "Cash Payment"){paymentType = "Card Payment";}
                    await FirebaseDatabase.instance.ref('routes/${routeInfo["ID"]}/users').push().set({
                      'userID': "${firebaseAuth.currentUser?.uid}",
                      'paymentType': paymentType
                    });
                    await FirebaseDatabase.instance.ref('users/${FirebaseAuth.instance.currentUser?.uid}/rides').push().set(routeInfo['ID']);
                    if(paymentType != "Cash Payment"){
                      await firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}/transactionLog").push().set(
                        {
                          "Date": DateFormat("dd-MMM-yyyy").format(DateTime.now()),
                          "Time": DateFormat('hh:mm a').format(DateTime.now()),
                          "Ammount": '${routeInfo['Price']}',
                          "Type": paymentType
                        }
                      );
                    }
                    Navigator.pop(context);
                    Navigator.popUntil(context, ModalRoute.withName('/MainScreen'));
                  }, 
                  child: Text("Book Now", style: TextStyle(fontSize: 26, color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily))
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}