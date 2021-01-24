import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xFFFCFCFC);
const kTextFieldBackgroundColor = Color(0xFFF5F6FA);
const kOrangeColor = Color(0xFFFA501C);
// const kBlackColor = Color(0xFF030303);
const kBlackColor = Colors.black87;
const kPrimaryTextColor = Color(0xFFF757575);

const kBottomContainerHeight = 60.0;
const kLabelFontSize = 40.0;

var url1 = 'http://10.0.2.2:5000/employee/1';
var kUrl = 'http://192.168.1.3:5000';
var url3 = 'http://0.0.0.0:5000/employee/1';
// var kUrl = 'http://192.168.100.52:5000';

const String kSafeGuard = "onlinevrs";

const kLogoStyleOne = TextStyle(
  color: kBlackColor,
  fontSize: 40,
  fontWeight: FontWeight.w800,
);

const kLogoStyleTwo = TextStyle(
  color: kOrangeColor,
  fontSize: 40,
  fontWeight: FontWeight.w800,
);

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}
