import 'package:app1/screens/maps_menu_screen.dart';
import 'package:app1/screens/profile_screen.dart';
import 'package:flutter/material.dart';

// Importing Screens
import 'check_login.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/maps_menu_screen.dart';
import 'screens/AttendanceScreen.dart';
import 'screens/qr_scanner.dart';
import 'screens/vac_screen.dart';
import 'screens/password_screen.dart';

void main() => runApp(
      MaterialApp(
        routes: <String, WidgetBuilder>{
          '/': (context) => checkLogin(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/qr_scanner': (context) => QRScanner(),
          '/profile_screen': (context) => ProfileScreen(),
          '/attendance': (context) => AttendanceScreen(),
          '/maps_menu': (context) => MapsMenuScreen(),
          '/vac_screen': (context) => VaccinationScreen(),
          '/change_password': (context) => UpdatePassword(),
        },
      ),
    );
