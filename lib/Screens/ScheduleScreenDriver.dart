import 'package:carpool_demo/MapKeys.dart';
import 'package:carpool_demo/Models/CustomDialogs.dart';
import 'package:carpool_demo/Models/RequestAssistant.dart';
import 'package:carpool_demo/Models/ScheduleBar.dart';
import 'package:carpool_demo/Widgets/BottomSheetFunctions.dart';
import 'package:carpool_demo/Widgets/PredictionCard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleScreenDriver extends StatefulWidget {
  const ScheduleScreenDriver({super.key});

  @override
  State<ScheduleScreenDriver> createState() => _ScheduleScreenDriverState();
}

class _ScheduleScreenDriverState extends State<ScheduleScreenDriver> {

  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController passengerController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String scheduleType = '';
  dynamic searchResults;

  Future<List<dynamic>> getPredictions(screenWidth, screenHeight) async {
    if(scheduleType == ''){return [];}
    String requestURL = '';
    if(scheduleType == 'from'){
      requestURL = '''https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${toController.text}&language=en&components=country:eg&key=$mapKey''';
    }
    else{
      requestURL = '''https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${fromController.text}&language=en&components=country:eg&key=$mapKey''';
    }
    var result = await RequestAssistant.getRequest(requestURL);
    if(result == 'Failed' || result == "No Response"){return [];}
    searchResults = result['predictions'];
    return result['predictions'];
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    scheduleType = ModalRoute.of(context)?.settings.arguments as String;

    changeHandler(){
      setState(() {});
    }

    checkAndFillSearch(){
      try{
        if(scheduleType == 'from'){
          searchResults.forEach((result) {
            if(result['description'] == toController.text){return;}
          });
          toController.text = searchResults[0]['description'];
          if(fromController.text == ''){return false;}
          return true;
        }
        searchResults.forEach((result) {
          if(result['description'] == fromController.text){return;}
        });
        if(toController.text == ''){return false;}
        fromController.text = searchResults[0]['description'];
        return true;
      } catch(e){
        return false;
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xff201A30),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/Images/BackGroundPattern.png'),
              repeat: ImageRepeat.repeat
            ),
          ),
          child: Column(
            children: [
              Container(
                height: screenHeight*0.43,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color:  Color(0xff38304C),
                  image: DecorationImage(
                    image: AssetImage('Assets/Images/BackGroundPattern.png'),
                    repeat: ImageRepeat.repeat
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight*0.05),
                  child: Column(
                    children: [
                      SizedBox(
                        width: screenWidth*0.9,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () async{
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            Center(
                              child: Text("Set Location", style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight*0.04,),
                      SizedBox(
                        width: screenWidth*0.9,
                        child: Column(
                          children: [
                            ...generateScheduleBar(scheduleType, fromController, toController, screenWidth, screenHeight, changeHandler),
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
                                if(checkAndFillSearch()){
                                  displayConfirmRouteBottomSheet(context, fromController.text, toController.text, passengerController, priceController, dateController, timeController, scheduleType);
                                }
                                else{showErrorDialog(context, 'Please Fill The\nRequired Fields', 32.0);}
                              }, 
                              child: Text("Confirm Route", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily))
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ),
              Container(
                height: screenHeight*0.75,
                clipBehavior: Clip.hardEdge,
                 decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: FutureBuilder(
                  future: getPredictions(screenWidth, screenHeight),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Column(
                        children: [
                          SizedBox(
                            height: screenHeight*0.57,
                            child: ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: (){
                                    if(scheduleType == 'from'){setState(() {toController.text = snapshot.data?[index]['description'];});}
                                    else{setState(() {fromController.text = snapshot.data?[index]['description'];});}
                                  },
                                  child: generatePredictionCard(screenWidth, screenHeight, snapshot.data?[index])
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    else{
                      return SizedBox(
                        width: screenWidth*0.2,
                        height: screenHeight*0.3,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircularProgressIndicator(color: Color(0xff0DF5E3)),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                ),
              ),
              SizedBox(height: screenHeight*0.3),
            ]
          ),
        ),
      ),
    );
  }
}