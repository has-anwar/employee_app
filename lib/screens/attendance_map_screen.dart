import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:app1/resources/my_appbar.dart';
import 'package:app1/utilities/OfficeLocation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:app1/utilities/prefs.dart';
import 'package:app1/resources/future_loader.dart';

import 'package:app1/utilities/constants.dart';

class OfficeMap extends StatefulWidget {
  @override
  _OfficeMapState createState() => _OfficeMapState();
}

class _OfficeMapState extends State<OfficeMap> {
  double CAMERA_ZOOM = 16;
  double CAMERA_TILT = 80;
  double CAMERA_BEARING = 30;
  LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
  LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

  Future<LatLng> _getOfficeLatLong() async {
    int id = await getEmployeeID();
    String path = '/office_location/';
    http.Response response = await http.get(kUrl + path + '$id');
    var data = jsonDecode(response.body);
    LatLng latLng = LatLng(data["lat"], data["long"]);
    log('UwU');
    return latLng;
  }

  Future<LatLng> _func;

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = '<AIzaSyCF6mhH81fZk8ozGtN9TneIEpcCu3EDNHE>';

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  LocationData currentLocation;
  LocationData destinationLocation;

  Location location;

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();

    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }

  void setPolylines() async {
    List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        currentLocation.latitude,
        currentLocation.longitude,
        destinationLocation.latitude,
        destinationLocation.longitude);
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId('poly'),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
      });
    }
  }

  void showPinsOnMap() {
    var pinPosition = LatLng(
        currentLocation.latitude,
        currentLocation
            .longitude); // get a LatLng out of the LocationData object
    var destPosition = LatLng(destinationLocation.latitude,
        destinationLocation.longitude); // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon)); // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon));

    setPolylines();
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    setState(() {
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition,
          icon: sourceIcon));
    });
  }

  @override
  void initState() {
    super.initState();
    _func = _getOfficeLatLong();

    location = new Location();
    polylinePoints = PolylinePoints();

    location.onLocationChanged.listen((LocationData cLoc) {
      updatePinOnMap();
    });
    setSourceAndDestinationIcons();
    setInitialLocation();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }

    return Scaffold(
      body: FutureBuilder<LatLng>(
          future: _func,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                child: Center(
                  child: CircularProgressIndicator(
                    // backgroundColor: kOrangeColor,
                    valueColor: AlwaysStoppedAnimation<Color>(kOrangeColor),
                  ),
                ),
              );
            } else {
              var latLng1 = snapshot.data;
              return Stack(
                children: <Widget>[
                  GoogleMap(
                      myLocationEnabled: true,
                      compassEnabled: true,
                      tiltGesturesEnabled: false,
                      markers: _markers,
                      polylines: _polylines,
                      mapType: MapType.normal,
                      initialCameraPosition: initialCameraPosition,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(
                            controller); // my map has completed being created;
                        // i'm ready to show the pins on the map
                        showPinsOnMap();
                      })
                ],
              );
            }
          }),
    );
  }
}
