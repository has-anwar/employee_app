import 'dart:convert';
import 'dart:developer';

import 'package:app1/utilities/prefs.dart';
import 'package:flutter/material.dart';
import 'package:app1/utilities/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';

class NavigateOffice extends StatefulWidget {
  @override
  _NavigateOfficeState createState() => _NavigateOfficeState();
}

class _NavigateOfficeState extends State<NavigateOffice> {
  _getOfficeLocation() async {
    int id = await getEmployeeID();
    String path = '/office_location/$id';
    http.Response response = await http.get(kUrl + path);
    log(response.body.toString());
    String address = jsonDecode(response.body)["address"];
    log(address);
    return address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getOfficeLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            MapsLauncher.launchQuery(snapshot.data);
            Navigator.pop(context);
            return Center(child: Text('Opening Google Maps'));
          } else {
            return SpinKitHourGlass(
              color: kOrangeColor,
              size: 50.0,
            );
          }
        },
      ),
    );
  }
}
