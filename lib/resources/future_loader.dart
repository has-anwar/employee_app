import 'package:flutter/material.dart';
import 'package:app1/utilities/constants.dart';

Container futureLoader(){
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
}