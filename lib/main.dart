import 'package:app1/screens/attendance_screen.dart';
import 'package:app1/screens/maps_menu_screen.dart';
import 'package:app1/screens/navigate_to_office.dart';
import 'package:app1/screens/new_home_screen.dart';
import 'package:app1/screens/profile_screen.dart';
import 'package:app1/screens/view_attendance.dart';
import 'package:app1/utilities/date_picker_dialog.dart';
import 'package:flutter/material.dart';

// Importing Screens
import 'check_login.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/maps_menu_screen.dart';
import 'screens/AttendanceScreen.dart';
import 'screens/qr_scanner.dart';
import 'screens/vac_screen.dart';
import 'screens/password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/attendance_map_screen.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var id = preferences.getInt('parent_id');

  runApp(
    MaterialApp(
      home: id == null ? LoginScreen() : HomeView(),
      routes: <String, WidgetBuilder>{
        // '/': (context) => checkLogin(),
        '/login': (context) => LoginScreen(),
        // '/home': (context) => HomeScreen(),
        '/home': (context) => HomeView(),
        '/qr_scanner': (context) => QRScanner(),
        '/profile_screen': (context) => ProfileScreen(),
        '/attendance': (context) => AttendanceScreen(),
        // '/attendance': (context) => MarkAttendance(),

        // '/attendance': (context) => MapPage(),
        '/view_attendance': (context) => ViewAttendance(),
        '/date_time': (context) => DateTimeDialog(),

        // '/navigate_to_office': (context) => NavigateOffice(),
        '/maps_menu': (context) => MapsMenuScreen(),
        '/vac_screen': (context) => VaccinationScreen(),
        '/change_password': (context) => UpdatePassword(),
        // '/office_map': (context) => OfficeMap(),
      },
    ),
  );
}
