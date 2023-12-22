import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionList extends StatefulWidget {
  final dynamic transactionLog;
  const TransactionList({super.key, this.transactionLog});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {

  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<List<Map<Object?, Object?>>> getTransactionList() async {
    List<Map<Object?, Object?>> transactionList = [];
    DataSnapshot dataSnapshot = await firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}/transactionLog").get();
    Map<Object?, Object?> allTransactions = dataSnapshot.value as Map<Object?, Object?>;
    allTransactions.forEach((transaction, transactionInfo) {
      transactionInfo as Map<Object?, Object?>;
      transactionList.add(transactionInfo);
    });
    return transactionList;
  }

  @override
  Widget build(BuildContext context) {

    firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}/transactionLog").onChildChanged.listen((event) {
      if(mounted){
        setState(() {});
      }
    });

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight*0.47,
      width: screenWidth*0.95,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Color(0xff38304C),
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: getTransactionList(),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return SizedBox(
                height: screenHeight*0.47,
                child: Center(
                  child:Text('No Data', style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold))
                ),
              );
            }
            if(snapshot.hasData){
              if(snapshot.data!.isNotEmpty){
                return Column(
                  children: [
                    ...snapshot.data!.map((transaction) {
                      return Column(
                        children: [
                          SizedBox(height: screenHeight * .01),
                          Card(
                            color: const Color(0xff38304C),
                            child: SizedBox(
                              width: screenWidth*0.9,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('\$${transaction["Ammount"]}', textAlign: TextAlign.center, style: TextStyle(color: const Color(0xff0DF5E3), fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                                    Column(
                                      children: [
                                        Text(transaction['Type'].toString(), style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(transaction['Date'].toString(), style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                                        Text(transaction['Time'].toString(), style: TextStyle(color: const Color(0xff706C7A), fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ],
                                )
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    ).toList()
                  ],
                );
              }
              else{
                return SizedBox(
                  height: screenHeight*0.47,
                  child: Center(
                    child:Text('No Data', style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold))
                  ),
                );
              }
              
            }
            else{
              return SizedBox(
                  height: screenHeight*0.47,
                  child: const Center(
                    child: Center(child: CircularProgressIndicator(color: Colors.white,),)
                  ),
                );
            }
          }
        ),
      ),
    );
  }
}