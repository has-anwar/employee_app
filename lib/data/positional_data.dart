import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PositionalData {
  double curLat;
  double curLong;
  double destLat;
  double destLong;
  double distM;

  PositionalData(
      {@required this.curLat,
      @required this.curLong,
      @required this.destLat,
      @required this.destLong,
      @required this.distM});
}
