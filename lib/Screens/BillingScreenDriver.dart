import 'package:carpool_demo/Models/CustomDialogs.dart';
import 'package:carpool_demo/Widgets/BottomSheetFunctions.dart';
import 'package:carpool_demo/Widgets/CreditCard.dart';
import 'package:carpool_demo/Widgets/TransactionListDriver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BillingScreenDriver extends StatefulWidget {
  const BillingScreenDriver({super.key});

  @override
  State<BillingScreenDriver> createState() => _BillingScreenDriverState();
}

class _BillingScreenDriverState extends State<BillingScreenDriver> {

  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final List<Map<String, String>> transactionLog = const [
    {"Date":"7-Jan", "Time":"7:00PM", "Ammount": "\$17.5", "Type": "Card Payment"},
    {"Date":"8-Feb", "Time":"1:00PM", "Ammount": "\$55.5", "Type": "Cash Payment"},
    {"Date":"9-June", "Time":"3:00PM", "Ammount":"\$23.5", "Type": "Card Payment"},
    {"Date":"3-May", "Time":"2:00PM", "Ammount": "\$42.5", "Type": "Cash Payment"},
    {"Date":"5-July", "Time":"4:00PM", "Ammount":"\$33.5", "Type": "Card Payment"},
    {"Date":"6-Oct", "Time":"5:00PM", "Ammount":"\$7.5", "Type": "Cash Payment"},
    {"Date":"6-Nov", "Time":"12:00PM", "Ammount":"\$69.5", "Type": "Card Payment"},
    {"Date":"6-Dec", "Time":"1:00PM", "Ammount":"\$89.5", "Type": "Card Payment"},
    {"Date":"6-March", "Time":"4:00PM", "Ammount":"\$15.5", "Type": "Cash Payment"},
    {"Date":"6-April", "Time":"3:00PM", "Ammount":"\$12.5", "Type": "Card Payment"},
  ];

  addTransactions() async{
    transactionLog.forEach((log) async {
      await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}/transactionLog").push().set(
        {
          "Date": log['Date'],
          "Time": log['Time'],
          "Ammount":log['Ammount'],
          "Type": log['Type']
        }
      );
    });
  }

  Future<List<Map<Object?, Object?>>> getCreditCards() async {
    List<Map<Object?, Object?>> cardList = [];
    DataSnapshot dataSnapshot = await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}/creditCards").get();
    Map<Object?, Object?> allCards = dataSnapshot.value as Map<Object?, Object?>;
    allCards.forEach((card, cardInfo) {
      cardInfo as Map<Object?, Object?>;
      cardInfo['ID'] = card;
      cardList.add(cardInfo);
    });
    return cardList;
  }

  @override
  Widget build(BuildContext context) {

    firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}/creditCards").onChildChanged.listen((event) {
      if(mounted){
        setState(() {});
      }
    });
    firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}/transactionLog").onChildChanged.listen((event) {
      if(mounted){
        setState(() {});
      }
    });

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text("Billing", style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
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
        child: Column(
          children: [
            Container(
              height: screenHeight*0.5,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xff38304C),
                image: DecorationImage(
                  image: AssetImage('Assets/Images/BackGroundPattern.png'),
                  repeat: ImageRepeat.repeat
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))
              ),
              child: FutureBuilder(
                future: getCreditCards(),
                builder: (context, snapshot) {
                  if(snapshot.hasError){
                    return Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0DF5E3),
                          padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 10),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                          ),
                        onPressed: ()async{
                          displayBillingBottomSheet(context, "driver");
                        }, 
                        child: Text(
                          "Add Credit Card",
                          style: TextStyle(
                            color: const Color(0xff1E1E32),
                            fontFamily: GoogleFonts.openSans().fontFamily,
                          )
                        )
                      ),
                    );
                  }
                  if(snapshot.hasData){
                    if(snapshot.data!.isNotEmpty){
                      return Column(
                        children: [
                          SizedBox(height: screenHeight * .12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(width: screenWidth*.025,),
                                ...snapshot.data!.map((card) {
                                  return Row(
                                    children: [
                                      CreditCard('${card["number"].toString().substring(0,4)} •••• •••• ${card["number"].toString().substring(card["number"].toString().length-4,card["number"].toString().length)}', card["expDate"].toString(), card['ID'].toString()),
                                      SizedBox(width: screenWidth*.025,),
                                    ],
                                  );
                                },),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * .01),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0DF5E3),
                              padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 10),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                              ),
                            onPressed: ()async{
                              if(snapshot.data!.length > 2){
                                showErrorDialog(context, 'Maximum limit \nReached', 32.0);
                              }
                              else{
                                displayBillingBottomSheet(context, "driver");
                              }
                            }, 
                            child: Text(
                              "Add",
                              style: TextStyle(
                                color: const Color(0xff1E1E32),
                                fontFamily: GoogleFonts.openSans().fontFamily,
                              )
                            )
                          ),
                        ],
                      );
                    }
                    else{
                      return Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0DF5E3),
                            padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 10),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                            ),
                          onPressed: ()async{
                            displayBillingBottomSheet(context, "driver");
                          }, 
                          child: Text(
                            "Add Credit Card",
                            style: TextStyle(
                              color: const Color(0xff1E1E32),
                              fontFamily: GoogleFonts.openSans().fontFamily,
                            )
                          )
                        ),
                      );
                    }
                  }
                  else{
                    return const Center(child: CircularProgressIndicator(color: Colors.white,),);
                  }
                }
              ),
            ),
            SizedBox(height: screenHeight * .01),
            TransactionListDriver(transactionLog: transactionLog,)
          ],
        ), 
      )
    );
  }
}