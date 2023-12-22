import 'package:carpool_demo/Models/CustomDialogs.dart';
import 'package:carpool_demo/Models/DatePicker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MapBookDrawer extends StatefulWidget {
  final dynamic changeDrawer;
  final dynamic routeInfo;
  const MapBookDrawer({super.key, this.changeDrawer, this.routeInfo});

  @override
  State<MapBookDrawer> createState() => _MapBookDrawerState();
}

class _MapBookDrawerState extends State<MapBookDrawer> {

  dynamic dateSelected;
  dynamic timeSelected;
  
  selectCurrentDate(int selection){
    setState(() {
      dateSelected = selection;
    });
  }

  selectCurrentTime(int selection){
    setState(() {
      timeSelected = selection;
    });
  }

  @override
  void initState() {
    if(DateTime.parse(widget.routeInfo['PickUpDate'] as String).day != DateTime.now().day){widget.routeInfo['PickUpDate'] = "Tomorrow";}
    else{widget.routeInfo['PickUpDate'] = "Today";}
    super.initState();
  }

  bool canBook(){
    String currTime = DateFormat('hh:mm a').format(DateTime.now());
    if(widget.routeInfo['PickUpTime']! == "7:30 AM"){
      if(widget.routeInfo['PickUpDate']! == "Today"){return false;}
      if(currTime.contains('PM') && int.parse(currTime.split(':')[0]) < 10){return true;}
      return false;
    }
    if((currTime.contains('PM') && int.parse(currTime.split(':')[0]) < 1) || currTime.contains('AM') || widget.routeInfo['PickUpDate']! == "Tomorrow"){return true;}
    return false;
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: screenHeight * 0.75,
        decoration:const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Assets/Images/BackGroundPattern.png'),
            repeat: ImageRepeat.repeat
          ),
          color:  Color(0xff201A30),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18))
        ),
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
                                color: const Color(0xff201A30)
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
                                  Text('  ${widget.routeInfo["from"].length <= 8 ? widget.routeInfo["from"] : widget.routeInfo["from"].substring(0,6) + ".."}', style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
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
                                  Text('  ${widget.routeInfo["to"].length <= 8 ? widget.routeInfo["to"] : widget.routeInfo["to"].substring(0,6) + ".."}', style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),),
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
                        SizedBox(width: screenWidth*0.03,),
                        Text(widget.routeInfo["MaxPassengerCount"] ?? '4', style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)
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
                        Text(widget.routeInfo["Price"].replaceAll('\$', '') ?? "33.7", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight*0.03,),
              constructDatePickerRider(context, widget.routeInfo['PickUpDate'] ?? 'Tozay', widget.routeInfo['PickUpTime'] ?? '1:00 ZM'),
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
                if(canBook()){
                  widget.changeDrawer();
                  Navigator.pushNamed(context, "/Payment", arguments: widget.routeInfo);
                }
                else{
                  showErrorDialog(context, "Couldn't Book\nToo Late", 32.0);
                }
              }, 
              child: Text("Book Now", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily))
            ),
            ],
          ),
        )
      ),
    );
  }
}