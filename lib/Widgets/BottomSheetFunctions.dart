import 'dart:math';
import 'package:carpool_demo/Models/CreditCardInputField.dart';
import 'package:carpool_demo/Models/CustomDialogs.dart';
import 'package:carpool_demo/Models/CustomInputFormField.dart';
import 'package:carpool_demo/Models/DatabaseController.dart';
import 'package:carpool_demo/Models/DatePicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';


Future displayProfileBottomSheet(BuildContext context, name, phone, userInfo){
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();
  DatabaseController databaseController = DatabaseController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  nameController.text = name;
  phoneController.text = phone;
  GlobalKey<FormState> formKey = GlobalKey();
  double screenHeight = MediaQuery.of(context).size.height;
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
    ),
    context: context,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: screenHeight*0.37,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/Images/BackGroundPattern.png'),
              repeat: ImageRepeat.repeat
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Color(0xff201A30),
          ),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCustomInputFormField(context, 'Name', nameController, 'text', (value){
                    if(nameController.text.isEmpty){
                      return 'Field Cannot Be Empty!';
                    }
                    return null;
                  }),
                  SizedBox(height: screenHeight*0.02,),
                  buildCustomInputFormField(context, 'Phone', phoneController, 'phone', (value){
                    if(phoneController.text.isEmpty){
                      return 'Field Cannot Be Empty!';
                    }
                    else if(!RegExp(r'\+?[(]?[0-9]{3}?[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$').hasMatch(phoneController.text)){
                      return 'Phone Number has Incorrect Format!';
                    }
                    return null;
                  }),
                  SizedBox(height: screenHeight*0.02,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0DF5E3),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                    onPressed: () async{
                      if(formKey.currentState!.validate()){
                        await databaseController.insert(
                          'DELETE FROM USERS WHERE EMAIL= "${firebaseAuth.currentUser?.email}"'
                        );
                        await databaseController.insert(
                          'INSERT INTO USERS ("EMAIL", "FullName", "Phone") VALUES ("${firebaseAuth.currentUser?.email}", "${nameController.text}", "${phoneController.text}")'
                        );
                        userInfo['FullName'] = nameController.text;
                        userInfo['Phone'] = phoneController.text;
                        await firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}").set(userInfo);
                        Navigator.pop(context);
                      }             
                    }, 
                    child: Text("Update", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily))
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future displayBillingBottomSheet(BuildContext context, userType){
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  double screenHeight = MediaQuery.of(context).size.height;
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
    ),
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (context) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: screenHeight*0.45,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xff201A30),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          border: Border.all(width: 2)
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight * .03),
            buildCreditCardInputField(context, cardNumberController, expDateController, cvvController),
            SizedBox(height: screenHeight * .03),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0DF5E3),
                padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                ),
              onPressed: () async{
                // 2244857713076837
                bool visaCardCheck = RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$').hasMatch(cardNumberController.text);
                bool visaMasterCardCheck = RegExp(r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14})$').hasMatch(cardNumberController.text);
                bool masterCardCheck = RegExp(r'^(5[1-5][0-9]{14}|2(22[1-9][0-9]{12}|2[3-9][0-9]{13}|[3-6][0-9]{14}|7[0-1][0-9]{13}|720[0-9]{12}))$').hasMatch(cardNumberController.text);
                bool cardNumberCheck = visaCardCheck || visaMasterCardCheck || masterCardCheck;
                bool cvvCheck = RegExp(r'^[0-9]{3,4}$').hasMatch(cvvController.text);
                bool expDateCheck = expDateController.text != '';
                if(cardNumberCheck && cvvCheck && expDateCheck){
                  showLoadingDialog(context, 'Adding Card');
                  if(userType == 'driver'){
                    await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}/creditCards").push().set(
                      {
                        "number": cardNumberController.text,
                        "expDate": expDateController.text,
                        "cvv": cvvController.text
                      }
                    );
                  }
                  else{
                    await firebaseDatabase.child("users/${firebaseAuth.currentUser?.uid}/creditCards").push().set(
                      {
                        "number": cardNumberController.text,
                        "expDate": expDateController.text,
                        "cvv": cvvController.text
                      }
                    );
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
                else{
                  Navigator.pop(context);
                  showErrorDialog(context, 'Invalid Credit Card!', 32.0);
                }
              }, 
              child: Text("Confirm", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily))
            ),
            
          ],
        ),
      ),
    )
  );
}

Future displayDriverProfileBottomSheet(BuildContext context, name, phone, carType, driverData) {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController carTypeController = TextEditingController();
  nameController.text = name;
  phoneController.text = phone;
  carTypeController.text = carType;
  GlobalKey<FormState> formKey = GlobalKey();
  double screenHeight = MediaQuery.of(context).size.height;

  return showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
    ),
    context: context,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: screenHeight*0.45,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/Images/BackGroundPattern.png'),
              repeat: ImageRepeat.repeat
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Color(0xff201A30),
          ),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCustomInputFormField(context, 'Name', nameController, 'text', (value){
                    if(nameController.text.isEmpty){
                      return 'Field Cannot Be Empty!';
                    }
                    return null;
                  }),
                  SizedBox(height: screenHeight*0.02,),
                  buildCustomInputFormField(context, 'Phone', phoneController, 'phone', (value){
                    if(phoneController.text.isEmpty){
                      return 'Field Cannot Be Empty!';
                    }
                    else if(!RegExp(r'\+?[(]?[0-9]{3}?[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$').hasMatch(phoneController.text)){
                      return 'Phone Number has Incorrect Format!';
                    }
                    return null;
                  }),
                  SizedBox(height: screenHeight*0.02,),
                  buildCustomInputFormField(context, 'Car Type', carTypeController, '', (value){
                    if(phoneController.text.isEmpty){
                      return 'Field Cannot Be Empty!';
                    }
                    return null;
                  }),
                  SizedBox(height: screenHeight*0.02,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0DF5E3),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                    onPressed: () async{
                      if(formKey.currentState!.validate()){
                        driverData['FullName'] = nameController.text;
                        driverData['Phone'] = phoneController.text;
                        driverData['carType'] = carTypeController.text;
                        await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}").set(driverData);
                        Navigator.pop(context);
                      }             
                    }, 
                    child: Text("Update", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily))
                  ),
                ],
              )
            ),
          ),
        ),
      );
    },
  );
}

Future displayConfirmRouteBottomSheet(BuildContext context, from, to, passengerController, priceController, dateController, timeController, scheduleType){
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();

  bool canSchedule(){
    String currTime = DateFormat('hh:mm a').format(DateTime.now());
    if(dateController.text == 'Today'){
      if(timeController.text.contains('AM')){
        if(currTime.contains('PM')){return false;}
        if(int.parse(currTime.split(':')[0]) < int.parse(timeController.text.split(':')[0])){return true;}
        return false;
      }
      if(currTime.contains('AM')){return true;}
      if(int.parse(currTime.split(':')[0]) < int.parse(timeController.text.split(':')[0])){return true;}
      return false;
    }
    return true;
  }

  addRoutes(){
    var routeList = [
      {"from":"Faculty of Engineering Gate 2", "to":"Masr & El Soudan"},
      {"from":"Faculty of Engineering Gate 3", "to":"Masr & El Soudan"},
      {"from":"Faculty of Engineering Gate 3", "to":"Mokkatam"},
      {"from":"Faculty of Engineering Gate 2", "to":"Mokkatam"},
      {"from":"Faculty of Engineering Gate 2", "to":"Abbaseya Square"},
      {"from":"Faculty of Engineering Gate 3", "to":"Abbaseya Square"},
      {"from":"Faculty of Engineering Gate 3", "to":"Ramsis Square"},
      {"from":"Faculty of Engineering Gate 2", "to":"Ramsis Square"},
      {"from":"Faculty of Engineering Gate 3", "to":"Roxy Square"},
      {"from":"Faculty of Engineering Gate 2", "to":"Roxy Square"},
      {"from":"Faculty of Engineering Gate 3", "to":"90th Street"},
      {"from":"Faculty of Engineering Gate 2", "to":"90th Street"},
      {"from":"Faculty of Engineering Gate 3", "to":"Hadaeq Al Qubbah"},
      {"from":"Faculty of Engineering Gate 2", "to":"Hadaeq Al Qubbah"},
      {"from":"Faculty of Engineering Gate 3", "to":"Zahraa Nasr city"},
      {"from":"Faculty of Engineering Gate 2", "to":"Zahraa Nasr city"},
      {"from":"Faculty of Engineering Gate 3", "to":"New Cairo 1"},
      {"from":"Faculty of Engineering Gate 2", "to":"New Cairo 1"},
      {"from":"Faculty of Engineering Gate 3", "to":"Salah Salem Street"},
      {"from":"Faculty of Engineering Gate 2", "to":"Salah Salem Street"},
      {"from":"Faculty of Engineering Gate 3", "to":"Sayyida Aisha"},
      {"from":"Faculty of Engineering Gate 2", "to":"Sayyida Aisha"},
      {"from":"Mokkatam", "to":"Faculty of Engineering Gate 2"},
      {"from":"Mokkatam", "to":"Faculty of Engineering Gate 3"},
      {"from":"Ramsis Square", "to":"Faculty of Engineering Gate 2"},
      {"from":"Ramsis Square", "to":"Faculty of Engineering Gate 3"},
      {"from":"Roxy Square", "to":"Faculty of Engineering Gate 2"},
      {"from":"Roxy Square", "to":"Faculty of Engineering Gate 3"},
      {"from":"90th Street", "to":"Faculty of Engineering Gate 2"},
      {"from":"90th Street", "to":"Faculty of Engineering Gate 3"},
      {"from":"Hadaeq Al Qubbah", "to":"Faculty of Engineering Gate 2"},
      {"from":"Hadaeq Al Qubbah", "to":"Faculty of Engineering Gate 3"},
      {"from":"Zahraa Nasr city", "to":"Faculty of Engineering Gate 2"},
      {"from":"Zahraa Nasr city", "to":"Faculty of Engineering Gate 3"},
      {"from":"New Cairo 1", "to":"Faculty of Engineering Gate 2"},
      {"from":"New Cairo 1", "to":"Faculty of Engineering Gate 3"},
      {"from":"Salah Salem Street", "to":"Faculty of Engineering Gate 2"},
      {"from":"Salah Salem Street", "to":"Faculty of Engineering Gate 3"},
      {"from":"Sayyida Aisha", "to":"Faculty of Engineering Gate 2"},
      {"from":"Sayyida Aisha", "to":"Faculty of Engineering Gate 3"},
      {"from":"Masr & El Soudan", "to":"Faculty of Engineering Gate 2"},
      {"from":"Masr & El Soudan", "to":"Faculty of Engineering Gate 3"},
      {"from":"Abbaseya Square", "to":"Faculty of Engineering Gate 2"},
      {"from":"Abbaseya Square", "to":"Faculty of Engineering Gate 3"},
    ];
    routeList.forEach((element) async {
      element['PickUp'] = element['from']!;
      element['DropOff'] = element['to']!;
      element["PickUpTime"] = ['7:30 AM', '5:30 PM'][Random().nextInt(2)];
      element["PickUpDate"] = ['Today', 'Tomorrow'][Random().nextInt(2)];
      element["DropOffTime"] = '8:00 ZM';
      element["Price"] = ['25.7', '32.5', '42.5', '12.5', '39.5'][Random().nextInt(5)];
      element["CarType"] = ['Audi', 'Mercedes', 'Toyota', 'Mazda', 'Porche'][Random().nextInt(5)];
      element["Status"] = 'Available';
      element["Duration"] = '25 min';
      element["MaxPassengerCount"] = ['4', '5'][Random().nextInt(2)];
      element["PassengerCount"] = '0';
      final DatabaseReference dbRef = await firebaseDatabase.child("routes").push();
      dbRef.set(element);
      await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}/rides").push().set(dbRef.key);
    });
  }

  return showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
    ),
    context: context,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: screenHeight*0.72,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/Images/BackGroundPattern.png'),
              repeat: ImageRepeat.repeat
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Color(0xff201A30),
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
            padding: const EdgeInsets.only(top:20, left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                    width: screenWidth*0.45,
                    'Assets/Images/LoginCarName.png',
                    ),
                    SizedBox(width: screenWidth*0.05,),
                    SizedBox(
                      width: screenWidth*0.35,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TimelineTile(
                              afterLineStyle: const LineStyle(color: Colors.white),
                              indicatorStyle: IndicatorStyle(
                                color: Colors.white,
                                width: 50,
                                iconStyle: IconStyle(
                                  iconData: Icons.arrow_circle_up,
                                  color: Color(0xff201A30)
                                )
                              ),
                              isFirst: true,
                              alignment: TimelineAlign.start,
                              endChild: Container(
                                constraints: const BoxConstraints(minHeight: 75),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: screenWidth*0.03,),
                                    Text('  Pick Up', style: TextStyle(color: const Color(0xff0DF5E3), fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                                    Text('  ${from.length > 8 ? from.substring(0,5)+'..' : from}', style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                            ),
                            TimelineTile(
                              beforeLineStyle: const LineStyle(color: Colors.white),
                              indicatorStyle: IndicatorStyle(
                                color: Colors.white,
                                width: 50,
                                iconStyle: IconStyle(
                                  iconData: Icons.arrow_circle_down,
                                  color: const Color(0xff201A30)
                                )
                              ),
                              isLast: true,
                              alignment: TimelineAlign.start,
                              endChild: Container(
                                constraints: const BoxConstraints(minHeight: 75),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: screenWidth*0.03,),
                                    Text('  Drop Off', style: TextStyle(color: const Color(0xff0DF5E3), fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                                    Text('  ${to.length > 8 ? to.substring(0,5)+'..' : to}', style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight*0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: screenWidth*0.40,
                      height: screenHeight*0.08,
                      decoration: const BoxDecoration(
                        color: Color(0xff38304C),
                        borderRadius: BorderRadius.all(Radius.circular(50))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person, color: Colors.white, size: 36,),
                          SizedBox(width: screenWidth*0.04,),
                          SizedBox(
                            width: screenWidth*0.05,
                            child: TextField(
                              controller: passengerController,
                              style: TextStyle(
                                fontFamily: GoogleFonts.openSans().fontFamily,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white
                              ),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration.collapsed(
                                hintText: '0',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontFamily: GoogleFonts.openSans().fontFamily,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth*0.40,
                      height: screenHeight*0.08,
                      decoration: const BoxDecoration(
                        color: Color(0xff38304C),
                        borderRadius: BorderRadius.all(Radius.circular(50))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.currency_pound_outlined, color: Colors.white, size: 36,),
                          SizedBox(width: screenWidth*0.02,),
                          SizedBox(
                            width: screenWidth*0.1,
                            child: TextField(
                              controller: priceController,
                              style: TextStyle(
                                fontFamily: GoogleFonts.openSans().fontFamily,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: '0.0',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontFamily: GoogleFonts.openSans().fontFamily,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight*0.03,),
                constructDatePickerDriver(context, dateController, timeController, scheduleType),
                SizedBox(height: screenHeight*0.03,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0DF5E3),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  onPressed: () async {
                    if(canSchedule()){
                      if(from == '' || to == '' || priceController.text == '0.0' || passengerController.text == '0' || passengerController.text == '' || priceController.text == ''){
                        showErrorDialog(context, "Please Fill in\nThe Required Fields", 32.0);
                        return;
                      }
                      if(!RegExp(r'([1-9]\d*(\.\d*[1-9])?|0\.\d*[1-9]+)|\d+(\.\d*[1-9])?').hasMatch(priceController.text)){
                        showErrorDialog(context, "Enter Price\nCorrectly", 32.0);
                        return;
                      }
                      showLoadingDialog(context, 'Scheduling Ride');
                      DataSnapshot dataSnapshot = await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}").get();
                      Map<Object?, Object?> userInfo = dataSnapshot.value as Map<Object?, Object?>;
                      DateTime PickUpDate = DateTime.now();
                      if(dateController.text != "Today"){PickUpDate = PickUpDate.add(const Duration(days: 1));}
                      var rideDetails = { 
                        "PickUp": from,
                        "from": from,
                        "PickUpTime": timeController.text,
                        "PickUpDate": PickUpDate.toString(),
                        "DropOff": to,
                        "to": to,
                        "DropOffTime": "${int.parse(timeController.text[0]) + 1}:00 AM",
                        "Price":"${priceController.text}",
                        "CarType": userInfo['carType'], 
                        "Status":'Available', 
                        "Duration":'- min',
                        "MaxPassengerCount": passengerController.text,
                        "PassengerCount": "0"
                      };
                      final DatabaseReference dbRef = await firebaseDatabase.child("routes").push();
                      dbRef.set(rideDetails);
                      await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}/rides").push().set(dbRef.key);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                    else{
                      showErrorDialog(context, "Couldn't Schedule\nInvalid Time", 32.0);
                    }
                  }, 
                  child: Text("Schedule Now", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily))
                ),
              ],
            ),
                  ),
          )
        ),
      );
    },
  );
}

Future displayScheduledRideBottomSheet(BuildContext context, rideInfo, rideID){
  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController statusController = TextEditingController();
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
    ),
    context: context,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: screenHeight*0.3,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/Images/BackGroundPattern.png'),
              repeat: ImageRepeat.repeat
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Color(0xff201A30),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownMenu(
                  initialSelection: rideInfo['Status'],
                  controller: statusController,
                  width: screenWidth*0.8,
                  inputDecorationTheme: InputDecorationTheme(
                    hintStyle: TextStyle(
                      fontFamily: GoogleFonts.openSans().fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    ),
                    filled: true,
                    fillColor: const Color(0xff38304C),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    iconColor: Colors.white,
                    suffixIconColor: Colors.white,
                  ),
                  menuStyle: const MenuStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    ))
                  ),
                  textStyle: TextStyle(
                    fontFamily: GoogleFonts.openSans().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white
                  ),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'Available', label: 'Available'),
                    DropdownMenuEntry(value: 'Confirmed', label: 'Confirmed'),
                    DropdownMenuEntry(value: 'Started', label: 'Started'),
                    DropdownMenuEntry(value: 'Arrived', label: 'Arrived'),
                    DropdownMenuEntry(value: 'Completed', label: 'Completed'),
                    DropdownMenuEntry(value: 'Cancelled', label: 'Cancelled'),
                  ],
                ),
                SizedBox(height: screenHeight*0.03,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0DF5E3),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  onPressed: () async{
                    bool updateCheck = true;
                    if(statusController.text == 'Available'){
                      updateCheck = false;
                    }
                    if(statusController.text == 'Confirmed'){
                      if(rideInfo['Status'] != 'Available'){updateCheck = false;} 
                    }
                    if(statusController.text == 'Started'){
                      if(rideInfo['Status'] != 'Confirmed'){updateCheck = false;} 
                    }
                    if(statusController.text == 'Arrived'){
                      if(rideInfo['Status'] != 'Started'){updateCheck = false;} 
                    }
                    if(statusController.text == 'Completed'){
                      if(rideInfo['Status'] != 'Arrived'){updateCheck = false;} 
                    }
                    if(!updateCheck){
                      showErrorDialog(context, 'Make Sure Status\nUpdate is Sequential', 32.0);
                      return;
                    }
                    showLoadingDialog(context, 'Updating');
                    rideInfo['Status'] = statusController.text;
                    await firebaseDatabase.child("routes/$rideID").set(
                      rideInfo
                    );
                    if(rideInfo['Status'] == 'Completed' || rideInfo['Status'] == 'Cancelled'){
                      await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}/history").push().set(rideInfo);
                      if(rideInfo['Status'] == 'Completed'){
                        await firebaseDatabase.child("drivers/${firebaseAuth.currentUser?.uid}/transactionLog").push().set(
                          {
                            "Date": DateFormat("dd-MMM-yyyy").format(DateTime.now()),
                            "Time": DateFormat('hh:mm a').format(DateTime.now()),
                            "Ammount": '${double.parse(rideInfo["Price"]) * double.parse(rideInfo["PassengerCount"])}',
                            "Type": 'Ride Fare'
                          }
                        ); 
                        try{
                          for(var userInfo in (rideInfo["users"] as Map<Object?, Object?>).values){
                            userInfo as Map<Object?, Object?>;
                            var userID = userInfo['userID'];
                            String paymentType = userInfo['paymentType'] as String;
                            userID as String;
                            if(paymentType == "Cash Payment"){
                              await firebaseDatabase.child("users/${userID}/transactionLog").push().set(
                                {
                                  "Date": DateFormat("dd-MMM-yyyy").format(DateTime.now()),
                                  "Time": DateFormat('hh:mm a').format(DateTime.now()),
                                  "Ammount": '${rideInfo['Price']}',
                                  "Type": 'Cash Payment'
                                }
                              );
                            }
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                      else{
                        try{
                          for(var userInfo in (rideInfo["users"] as Map<Object?, Object?>).values){
                            userInfo as Map<Object?, Object?>;
                            var userID = userInfo['userID'];
                            String paymentType = userInfo['paymentType'] as String;
                            userID as String;
                            if(paymentType != "Cash Payment"){
                              await firebaseDatabase.child("users/${userID}/transactionLog").push().set(
                                {
                                  "Date": DateFormat("dd-MMM-yyyy").format(DateTime.now()),
                                  "Time": DateFormat('hh:mm a').format(DateTime.now()),
                                  "Ammount": '${rideInfo['Price']}',
                                  "Type": 'Ride Refund'
                                }
                              );
                            }
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }, 
                  child: Text("Update", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily))
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}