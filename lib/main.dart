import 'package:carpool_demo/Screens/BillingScreen.dart';
import 'package:carpool_demo/Screens/BillingScreenDriver.dart';
import 'package:carpool_demo/Screens/BookedRidesScreen.dart';
import 'package:carpool_demo/Screens/DriverHistoryInfoScreen.dart';
import 'package:carpool_demo/Screens/HistoryScreen.dart';
import 'package:carpool_demo/Screens/HistoryScreenDriver.dart';
import 'package:carpool_demo/Screens/LoginScreenDriver.dart';
import 'package:carpool_demo/Screens/MainScreen.dart';
import 'package:carpool_demo/Screens/MainScreenDriver.dart';
import 'package:carpool_demo/Screens/MapScreen.dart';
import 'package:carpool_demo/Screens/PaymentScreen.dart';
import 'package:carpool_demo/Screens/ProfileScreen.dart';
import 'package:carpool_demo/Screens/ProfileScreenDriver.dart';
import 'package:carpool_demo/Screens/RegisterScreenDriver.dart';
import 'package:carpool_demo/Screens/ScheduleScreenDriver.dart';
import 'package:carpool_demo/Screens/ScheduleTypeScreen.dart';
import 'package:carpool_demo/Screens/ScheduledRidesScreen.dart';
import 'package:carpool_demo/Screens/SearchScreen.dart';
import 'package:carpool_demo/Screens/TrackOrderScreen.dart';
import 'package:carpool_demo/Screens/WelcomeScreen.dart';
import 'package:carpool_demo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carpool_demo/Screens/LoginScreen.dart';
import 'package:carpool_demo/Screens/RegisterScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/Welcome",
      routes: {
        "/Welcome":(context) => const WelcomeScreen(),
        "/Login" :(context) => const LoginScreen(),
        "/Register" :(context) => const RegisterScreen(),
        "/MainScreen":(context) => const MainScreen(),
        "/Profile":(context) => const ProfileScreen(),
        "/Billing":(context) => const BillingScreen(),
        "/History":(context) => const HistoryScreen(),
        "/Map":(context) => const MapScreen(),
        "/Search":(context) => const SearchScreen(),
        "/TrackOrder":(context) => const TrackOrderScreen(),
        "/Payment":(context) => const PaymentScreen(),
        "/BookedRides":(context) => const BookedRidesScreen(),
        "/LoginDriver" :(context) => const LoginScreenDriver(),
        "/RegisterDriver" :(context) => const RegisterScreenDriver(),
        "/MainScreenDriver":(context) => const MainScreenDriverDriver(),
        "/DriverHistory":(context) => const HistoryScreenDriver(),
        "/DriverBilling":(context) => const BillingScreenDriver(),
        "/DriverProfile":(context) => const ProfileScreenDriver(),
        "/ScheduleScreen":(context) => const ScheduleScreenDriver(),
        "/ScheduleType":(context) => const ScheduleTypeScreen(),
        '/ScheduledRides':(context) => const ScheduledRidesScreen(),
        "/DriverHistoryInfo":(context) => const DriverHistoryInfoScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}