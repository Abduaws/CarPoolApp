import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Widget buildCreditCardInputField(context, cardNumberController, expDateController, cvvController){
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

  DateTime selectedDate = DateTime.now();

  Future<dynamic> selectDate(BuildContext context) async {
    final DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)
    );
    if(dateTime != null){
      String formattedDate = DateFormat('MM/yy').format(dateTime);
      return formattedDate;
    }
    else{
      return '';
    }
  }

  return Container(
    height: screenHeight*0.3,
    width: screenWidth*0.85,
    decoration: const BoxDecoration(
      color: Color.fromARGB(255, 53, 8, 166),
      image: DecorationImage(
        image: AssetImage('Assets/Images/CreditCardAdd.png'),
        fit: BoxFit.fill
      ),
      borderRadius: BorderRadius.all(Radius.circular(50))
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ZeroPool", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
          Text("Card", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
          SizedBox(height: screenHeight * .03),
          TextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            controller: cardNumberController,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.openSans().fontFamily
            ),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: BoxConstraints(maxWidth: screenWidth*0.75),
              labelStyle: TextStyle(color: Colors.white, fontSize: 24, fontFamily: GoogleFonts.openSans().fontFamily),
              filled: true,
              fillColor: const Color.fromARGB(255, 45, 37, 68),
              labelText: 'Card Number',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: screenHeight * .035),
          SizedBox(
            width: screenWidth * 0.55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextField(
                  controller: expDateController,
                  keyboardType: TextInputType.datetime,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.openSans().fontFamily
                  ),
                  readOnly: true,
                  onTap: () async {
                    var result = await selectDate(context);
                    expDateController.text = result.toString();
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: BoxConstraints(maxWidth: screenWidth*0.3),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 24, fontFamily: GoogleFonts.openSans().fontFamily),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 45, 37, 68),
                    labelText: 'Exp Date',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                TextField(
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.openSans().fontFamily
                  ),
                  controller: cvvController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: BoxConstraints(maxWidth: screenWidth*0.2),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 24, fontFamily: GoogleFonts.openSans().fontFamily),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 45, 37, 68),
                    labelText: 'CVV',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}