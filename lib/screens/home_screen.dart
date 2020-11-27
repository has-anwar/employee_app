import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:app1/utilities/constants.dart';
import 'package:app1/resources/home_card.dart';
import 'package:app1/utilities/prefs.dart';
import 'package:app1/utilities/OfficeLocation.dart';
import 'package:app1/utilities/loading_dialog.dart';
import 'package:app1/resources/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kOrangeColor,
      ),
      // drawer: MyDrawer(),
      body: Container(
        width: width,
        height: height,
        color: kBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              // Container(
              //   margin: EdgeInsets.only(left: 20.0, right: 20.0),
              // ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/qr_scanner');
                  },
                  child: HomeCard(
                    title: 'Scan QR Code',
                    imageName: 'qr3.jpg',
                    // navigate: '/scan_qr',
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    log('maps pressed');
                    Navigator.pushNamed(context, '/attendance');
                  },
                  child: HomeCard(
                    title: 'Mark Attendance',
                    imageName: 'ccalander.jpg',
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/maps_menu');
                  },
                  child: HomeCard(
                    title: 'Locations',
                    imageName: 'map.jpg',
                    // navigate: '/maps_menu',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
