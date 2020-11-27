import 'package:app1/resources/my_appbar.dart';
import 'package:flutter/material.dart';
import 'attendance_screen.dart';
import 'package:app1/resources/my_drawer.dart';
import 'package:app1/resources/home_card.dart';
import 'package:app1/utilities/constants.dart';
import 'dart:developer';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: MyDrawer(),
      appBar: MyAppBar(
        title: 'Dashboard',
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Card(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/qr_scanner');
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: kOrangeColor, width: 4)),
                  width: SizeConfig.screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MdiIcons.qrcodeScan,
                        size: SizeConfig.safeBlockHorizontal * 15,
                        color: kOrangeColor,
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockHorizontal * 4,
                      ),
                      Text(
                        'Scan QR Code',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            color: kOrangeColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                myCard(MdiIcons.accountCheckOutline, 'Mark Attendance',
                    'attendance'),
                myCard(MdiIcons.history, 'View Attendance', 'view_attendance'),
                myCard(MdiIcons.mapCheckOutline, 'Locations', 'maps_menu'),
                // myCard(MdiIcons.navigationOutline,
                //     'Navigate to Office', 'navigate_to_office')
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card myCard(IconData iconData, String title, String navigateTo) {
    return Card(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/' + navigateTo);
        },
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: kOrangeColor, width: 4)),
          width: SizeConfig.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: SizeConfig.safeBlockHorizontal * 13,
                color: kOrangeColor,
              ),
              SizedBox(
                height: SizeConfig.safeBlockHorizontal * 4,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: kOrangeColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
