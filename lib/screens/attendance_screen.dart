import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:app1/utilities/constants.dart';
import 'package:app1/resources/my_appbar.dart';
import 'package:app1/resources/my_drawer.dart';
import 'package:app1/utilities/prefs.dart';
import 'package:app1/data/positional_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkAttendance extends StatefulWidget {
  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}
//TODO: Get Office location
//TODO: Get distance between
//TODo: Mark attendance or prompt to move closer to location

class _MarkAttendanceState extends State<MarkAttendance> {
  Position _currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  LatLng cameraFocus;

  Future<PositionalData> _getCurrentLocation() async {
    Position userLocation = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    int empId = await getEmployeeID();
    String path = '/office_location/';
    http.Response response = await http.get(kUrl + path + empId.toString());
    log(response.body.toString());
    log('User location: ' +
        userLocation.latitude.toString() +
        " " +
        userLocation.longitude.toString());
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
    cameraFocus = LatLng(positionalData.curLat, positionalData.curLong);
    return positionalData;
  }

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  void _add(PositionalData data) {
    var markerIdVal = '0';
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(data.destLat, data.curLong),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      // onTap: () {
      //   _onMarkerTapped(markerId);
      // },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  bool flag = false;
  void setCameraFocus(PositionalData data) {
    setState(() {
      if (flag == false) {
        cameraFocus = LatLng(data.destLat, data.destLong);
        flag = true;
      } else {
        cameraFocus = LatLng(data.curLat, data.curLong);
        flag = false;
      }
    });
  }

  Future<PositionalData> getLoc;
  @override
  void initState() {
    getLoc = _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize size class duh
    SizeConfig().init(context);

    return Scaffold(
      appBar: MyAppBar(
        title: "Mark Attendance",
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
                  Expanded(
                    flex: 7,
                    child: mapCard(snapshot),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Text('Go to office marker'),
                      onPressed: () {
                        setState(() {
                          setCameraFocus(snapshot.data);
                        });
                      },
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
        child: GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
          initialCameraPosition: CameraPosition(
            zoom: 16,
            bearing: 30,
            target: cameraFocus,
          ),
          markers: Set<Marker>.of(markers.values),
          // circles: ,
        ),
      ),
    );
  }

  Card distInfoCard(snapshot) {
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
                text: snapshot.data.distM.toString() + ' meters ',
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
