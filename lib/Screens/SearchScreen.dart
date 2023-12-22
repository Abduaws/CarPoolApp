import 'package:carpool_demo/Widgets/RouteCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();

  TextEditingController searchController = TextEditingController();

  final routeList = const [
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

  Future<List<Widget>> getRoutes(screenWidth, screenHeight) async {
    DataSnapshot dataSnapshot = await firebaseDatabase.child('routes').get();
    DataSnapshot dataSnapshot2 = await firebaseDatabase.child("users/${FirebaseAuth.instance.currentUser?.uid}/rides").get();
    Map<Object?, Object?> bookedRides = {};
    if(dataSnapshot2.value != null){bookedRides = dataSnapshot2.value as Map<Object?, Object?>;}
    Map<Object?, Object?> routes = dataSnapshot.value as Map<Object?, Object?>;
    List<Widget> routeList = [];
    routes.forEach((route, routeInfo) {
      routeInfo as Map<Object?, Object?>;
      bool fromCheck = "${routeInfo['from']}".toLowerCase().contains(searchController.text.toLowerCase());
      bool toCheck = "${routeInfo['to']}".toLowerCase().contains(searchController.text.toLowerCase()); 
      bool completedCheck = routeInfo['Status'] == 'Completed';
      bool startedCheck = routeInfo['Status'] == 'Started';
      bool availableCheck = routeInfo['Status'] == 'Available';
      bool confirmedCheck = routeInfo['Status'] == 'Confirmed';
      bool fullCheck = routeInfo['PassengerCount'] == routeInfo['MaxPassengerCount'];
      bool cancelledCheck = routeInfo['Status'] == 'Cancelled';
      bool bookedCheck = false;
      DateTime rideDate = DateTime.parse(routeInfo['PickUpDate'] as String);
      bookedRides.forEach((entryID, bookedRideId) {
        if(bookedRideId == route){bookedCheck = true; }
      });
      if(completedCheck || fullCheck || cancelledCheck || startedCheck || bookedCheck || rideDate.isBefore(DateTime.now())){}
      else if((fromCheck || toCheck) && (availableCheck || confirmedCheck)){
        routeList.add(
          GestureDetector(
            onTap: () {
              routeInfo['ID'] = route;
              Navigator.pop(context, routeInfo);
            },
            child: generateRouteCard(screenWidth, routeInfo)
          ),
        );
        routeList.add(SizedBox(height: screenHeight * .03),);
      }
    });
    return routeList;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    firebaseDatabase.child("routes").onChildChanged.listen((event) {
      if(mounted){
        setState(() {});
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xff201A30),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
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
                height: screenHeight*0.25,
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
                              child: Text("Search Rides", style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight*0.04,),
                      SizedBox(
                        width: screenWidth*0.9,
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_sharp, color: Colors.white,),
                            SizedBox(width: screenWidth*0.03,),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {});
                                },
                                controller: searchController,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.openSans().fontFamily,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white
                                ),
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xff201A30),
                                  hintStyle: TextStyle(
                                    fontFamily: GoogleFonts.openSans().fontFamily,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ),
              SizedBox(height: screenHeight*0.02,),
              Container(
                height: screenHeight*0.75,
                clipBehavior: Clip.hardEdge,
                 decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: FutureBuilder(
                  future: getRoutes(screenWidth, screenHeight),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return snapshot.data?[index];
                        },
                      );
                    }
                    else if(snapshot.hasError){
                      return Center(child: Text("No Rides Available", style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white)),);
                    }
                    else{
                      return const Center(child: CircularProgressIndicator(color: Color(0xff0DF5E3)));
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