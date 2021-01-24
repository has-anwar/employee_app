// Flutter imports
import 'package:flutter/material.dart';
import 'dart:convert';

//  Resource imports
import 'package:app1/resources/my_appbar.dart';
import 'package:app1/resources/my_drawer.dart';
import 'package:app1/utilities/prefs.dart';
import 'package:app1/utilities/constants.dart';

//  Package imports
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  GoogleMapController _googleMapController;
  LatLng _officeLoc;
  double _distInMeters;
  List<Marker> markers = [];
  bool _isDisabled;

  _checkLocationServiceStatus() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  _initializeData() async {
    //  Get user initial position
    LatLng _locationDataLatLng;
    LocationData _locationData = await location.getLocation();
    _locationDataLatLng =
        LatLng(_locationData.latitude, _locationData.longitude);

    return _locationDataLatLng;
  }

  _getOfficeLocation() async {
    //  Get user Id and send GET req for office location
    int empId = await getEmployeeID();
    String path = '/office_location/';
    http.Response response = await http.get(kUrl + path + empId.toString());

    var data = jsonDecode(response.body);
    _officeLoc = LatLng(data["lat"], data["long"]);
    addOfficeMarker();
  }

  LocationData currentLocation;
  _trackLocation() {
    location.changeSettings(interval: 100);
    location.onLocationChanged.listen((LocationData cLoc) async {
      // print(cLoc.latitude);
      double dist = await _getDistanceFromOffice(cLoc);
      if (mounted) {
        setState(() {
          currentLocation = cLoc;
          _distInMeters = dist;
          if (dist >= 10) {
            _isDisabled = true;
          } else {
            _isDisabled = false;
          }
        });
      }
    });
  }

  Future<double> _getDistanceFromOffice(LocationData locationData) async {
    double dist = await Geolocator().distanceBetween(
      locationData.latitude,
      locationData.longitude,
      _officeLoc.latitude,
      _officeLoc.longitude,
    );

    return dist;
  }

  void addOfficeMarker() {
    markers.add(
      Marker(
        markerId: MarkerId('OfficeMarker'),
        draggable: false,
        position: _officeLoc,
      ),
    );
  }

  void moveToOffice() {
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _officeLoc,
        zoom: 17,
      ),
    ));
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
    _checkLocationServiceStatus();
    _getOfficeLocation();
    _trackLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: FutureBuilder(
        future: _initializeData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Container(
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      compassEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: true,
                      initialCameraPosition: CameraPosition(
                        zoom: 16,
                        bearing: 30,
                        target: snapshot.data,
                      ),
                      onMapCreated: (controller) {
                        setState(() {
                          _googleMapController = controller;
                        });
                      },
                      markers: Set.from(markers),
                    ),
                    Container(
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.screenWidth,
                      // color: Colors.pink,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Opacity(
                                opacity: 0.7,
                                child: FloatingActionButton(
                                  mini: true,
                                  shape: RoundedRectangleBorder(),
                                  onPressed: () {
                                    moveToOffice();
                                  },
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.location_city,
                                    size: SizeConfig.safeBlockHorizontal * 5,
                                    color: Colors.black,
                                  ),
                                  // elevation: 5.0,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: distCard(),
                          ),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 69.8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ButtonTheme(
                              buttonColor: kOrangeColor,
                              minWidth: SizeConfig.screenWidth / 2,
                              child: RaisedButton(
                                child: Text(
                                  _distInMeters > 10
                                      ? 'Move closer to mark attendance'
                                      : 'Mark Attendance',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: _distInMeters > 10
                                    ? null
                                    : () {
                                        if (_distInMeters <= 10) {
                                          _markAttendance();
                                        } else {
                                          AlertDialog alert = AlertDialog(
                                            title: Text("Attention"),
                                            content: Text(
                                                "You should be at least 10 meters away from location to mark attendance"),
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
                                      },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return loading();
          }
        },
      ),
    );
  }

  Widget distCard() {
    if (_distInMeters == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Container(
          width: SizeConfig.safeBlockHorizontal * 90,
          height: SizeConfig.safeBlockVertical * 10,
          child: Card(
            margin: EdgeInsets.symmetric(),
            color: kOrangeColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[500],
                highlightColor: Colors.white,
                child: Text(
                  'Please wait...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      String dist;
      if (_distInMeters >= 500) {
        dist =
            double.parse((_distInMeters / 1000).toString()).toStringAsFixed(1) +
                ' Km ';
        double km = _distInMeters / 1000;
      } else {
        dist =
            double.parse((_distInMeters).toString()).toStringAsFixed(1) + ' m ';
      }
      return Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Container(
          width: SizeConfig.safeBlockHorizontal * 90,
          height: SizeConfig.safeBlockVertical * 10,
          child: Card(
            margin: EdgeInsets.symmetric(),
            color: kOrangeColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  text: 'You are ',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: dist,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                    TextSpan(
                      text: ' away from the attendance mark point',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Center loading() {
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
