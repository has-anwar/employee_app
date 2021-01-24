import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:app1/utilities/constants.dart';
import 'package:app1/resources/my_appbar.dart';
import 'package:app1/resources/my_drawer.dart';
import 'package:app1/utilities/prefs.dart';
import 'package:app1/data/positional_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:units/units.dart';

class MarkAttendance extends StatefulWidget {
  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  Position _currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  LatLng officeFocus;
  LatLng curPosFocus;
  List<Marker> markers = [];
  GoogleMapController _googleMapController;
  Future<PositionalData> getLoc;
  Set<Circle> circleSet = {};
  bool _isDisabled;

////////////////////////////////////////////
  loc.LocationData currentLocation;
  loc.Location location;
  /////////////

  Future<PositionalData> _getCurrentLocation() async {
    Position userLocation = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    int empId = await getEmployeeID();
    String path = '/office_location/';
    http.Response response = await http.get(kUrl + path + empId.toString());

    var officeLoc = jsonDecode(response.body);
    double distanceInMeters = await Geolocator().distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        officeLoc["lat"],
        officeLoc["long"]);
    PositionalData positionalData = PositionalData(
        curLat: userLocation.latitude,
        curLong: userLocation.longitude,
        destLat: officeLoc["lat"],
        destLong: officeLoc["long"],
        distM: distanceInMeters);
    officeFocus = LatLng(positionalData.destLat, positionalData.destLong);
    curPosFocus = LatLng(positionalData.curLat, positionalData.curLong);
    if (positionalData.distM <= 10) {
      setState(() {
        _isDisabled = false;
      });
    } else {
      setState(() {
        _isDisabled = true;
      });
    }
    print(positionalData.distM);
    markers.add(
      Marker(
        markerId: MarkerId('OfficeMarker'),
        draggable: false,
        position: officeFocus,
      ),
    );
    Circle circle = Circle(
      center: officeFocus,
      radius: 50,
      strokeWidth: 0,
      // strokeColor: Colors.red,
      fillColor: Color(0x220000FF),
      circleId: CircleId("OfficeRadius"),
    );
    circleSet.add(circle);
    return positionalData;
  }

  _markAttendance() async {
    int fid = await getOfficeID();
    String path = '/attendance/$fid';
    http.Response response = await http.post(
      kUrl + path,
    );
    if (response.statusCode == 200) {
      AlertDialog alert = AlertDialog(
        title: Text("Success"),
        content: Text("Attendance Marked"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Ok'),
          )
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      AlertDialog alert = AlertDialog(
        title: Text("Something went wrong"),
        content: Text(
            "Attendance not marked. Check your internet connection and try again."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok'),
          )
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  @override
  void initState() {
    getLoc = _getCurrentLocation();
    super.initState();
    location = new loc.Location();
    location.changeSettings(interval: 1000);
    location.onLocationChanged.listen((loc.LocationData cLoc) {
      setState(() {
        currentLocation = cLoc;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize size class duh
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance'),
        backgroundColor: kOrangeColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/attendance');
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: FutureBuilder(
        future: getLoc,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: distInfoCard(snapshot),
                  ),
                  Text(
                    'Refresh to update location if button is disabled',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.redAccent,
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: mapCard(snapshot),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ButtonTheme(
                      buttonColor: kOrangeColor,
                      minWidth: SizeConfig.screenWidth / 2,
                      child: RaisedButton(
                        child: Text(
                          'Mark Attendance',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _isDisabled ? null : _markAttendance,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return onWait();
          }
        },
      ),
    );
  }

  Container mapCard(snapshot) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Stack(children: [
          GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: true,
            initialCameraPosition: CameraPosition(
              zoom: 16,
              bearing: 30,
              target: curPosFocus,
            ),
            onMapCreated: (controller) {
              setState(() {
                _googleMapController = controller;
              });
            },
            markers: Set.from(markers),
            // circles: circleSet,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.7,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    moveToMarker(snapshot.data.destLat, snapshot.data.destLong);
                  },
                  backgroundColor: Colors.white,
                  icon: Icon(
                    Icons.location_city,
                    color: Colors.black,
                  ),
                  // elevation: 5.0,
                  label: Text('Go to Office Pin',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _currentPosition = controller;
    });
  }

  void moveToMarker(latitude, longitude) {
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 17,
      ),
    ));
  }

  Widget distInfoCard(snapshot) {
    String dist;
    if (snapshot.data.distM > 500) {
      // dist = snapshot.data.distM.inKilometers.toString();
      dist = double.parse((snapshot.data.distM / 1000).toString())
              .toStringAsFixed(1) +
          ' Km ';
      double km = snapshot.data.distM / 1000;
    } else {
      dist = double.parse((snapshot.data.distM).toString()).toStringAsFixed(1) +
          ' m ';
    }
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            text: 'You are ',
            style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 5,
              color: Colors.black87,
            ),
            children: <TextSpan>[
              TextSpan(
                // text: dist,
                text: currentLocation.latitude.toString() +
                    "       " +
                    currentLocation.longitude.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' away from the attendance mark point',
              )
            ],
          ),
        ),
      ),
    );
  }

  Center onWait() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitHourGlass(
            color: kOrangeColor,
            size: 50.0,
          ),
          SizedBox(
            height: SizeConfig.safeBlockHorizontal * 5,
          ),
          Text('Getting your location...'),
        ],
      ),
    );
  }
}
