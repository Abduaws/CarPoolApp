import 'package:carpool_demo/Models/MapLocation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MapSearchDrawer extends StatelessWidget {
  final dynamic changeDrawer;
  final dynamic updateRoute;
  const MapSearchDrawer({super.key, this.changeDrawer, this.updateRoute});

  final favoriteList = const [
    {"from":"Faculty of Engineering Gate 2", "to":"Masr & El Soudan"},
    {"from":"Abbaseya Square", "to":"Faculty of Engineering Gate 2"},
    {"from":"Faculty of Engineering Gate 3", "to":"Mokkatam"},
  ];

  List<Widget> getFavoriteList(List<Map<String, String>> favoriteList, double screenHeight) {
    List<Widget> tempList = [];
    favoriteList.forEach((favorite) {
      tempList.add(MapLocation(mainText: favorite["to"], subText: favorite["from"], icon: Icons.star,));
      tempList.add(SizedBox(height: screenHeight*0.03,));
    });
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth= MediaQuery.of(context).size.width;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: screenHeight * 0.45,
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi there, ", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                Text("Where to?, ", style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
                SizedBox(height: screenHeight*0.03,),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff38304C),
                    borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      updateRoute(await Navigator.pushNamed(context, '/Search'));
                      changeDrawer();
                    },
                    child: SizedBox(
                      height: screenHeight*0.05,
                      child: Row(
                        children: [
                          SizedBox(width: screenWidth*0.03,),
                          Icon(Icons.search, color: Colors.white, size: screenWidth*0.07,),
                          SizedBox(width: screenWidth*0.03,),
                          Text("Search", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.03,),
                Column(
                  children: getFavoriteList(favoriteList, screenHeight)
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}