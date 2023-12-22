import 'package:carpool_demo/Models/MapBookDrawer.dart';
import 'package:carpool_demo/Models/MapSearchDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  dynamic searchHeight;
  GoogleMapController? mapController;
  Position? currentPosition;
  LatLng? currentPositionLatLong;
  Geolocator geolocator = Geolocator();
  bool? showSearchDrawer = true;
  Map<Object?, Object?> routeInfo = {};

  updateRoute(newRouteInfo){
    setState(() {
      routeInfo = newRouteInfo;
    });
  }

  void _onMapCreated(GoogleMapController googleMapController){
    mapController = googleMapController;
    locatePosition();
  }

  void locatePosition() async {
    currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPositionLatLong = LatLng(currentPosition!.latitude, currentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: currentPositionLatLong!, zoom: 15);
    mapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }

  void changeDrawer(){
    setState(() {
      if (showSearchDrawer!){
        showSearchDrawer = false;
      }
      else{showSearchDrawer = true;}
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        flexibleSpace: Image.asset('Assets/Images/BackGroundPattern.png', repeat: ImageRepeat.repeat, fit: BoxFit.cover,),
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text("Book A Ride", style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: GoogleFonts.openSans().fontFamily, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: const Color(0xff201A30),
      body: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: GoogleMap(
              padding: EdgeInsets.only(bottom: screenHeight*0.45),
              cloudMapId: "ce615ddc1aa1c5f5",
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(30.06473968263772, 31.278821424466464),
                zoom: 15.0
              ),
            ),
          ),
          showSearchDrawer! ? 
          MapSearchDrawer(changeDrawer: changeDrawer, updateRoute: updateRoute,):
          MapBookDrawer(changeDrawer: changeDrawer, routeInfo: routeInfo)
        ]
      )
    );
  }
}