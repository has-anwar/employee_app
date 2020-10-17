import 'package:flutter/material.dart';
import 'package:app1/utilities/prefs.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

Widget checkLogin() {
  if (getEmployeeID() != null) {
    return HomeScreen();
  } else {
    return LoginScreen();
  }
}
