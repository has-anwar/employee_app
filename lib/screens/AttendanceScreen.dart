import 'package:flutter/material.dart';

import 'package:app1/utilities/constants.dart';
import 'package:local_auth/local_auth.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final LocalAuthentication localAuth = LocalAuthentication();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        centerTitle: true,
        backgroundColor: kOrangeColor,
      ),
      body: GestureDetector(
        onTap: () async {
          bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;
          if (weCanCheckBiometrics) {
            bool authentiacated = await localAuth.authenticateWithBiometrics(
              localizedReason: "Authenticate to mark attendance",
            );
            print(authentiacated);
          }
          print("Touch Authn started");
        },
        child: Container(
          color: Colors.pink,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.fingerprint,
                size: 124.0,
              ),
              Center(
                child: Text(
                  "Tap here",
                  style: TextStyle(fontSize: 50.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
