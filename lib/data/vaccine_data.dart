import 'package:flutter/material.dart';

class Vaccine {
  int vacID;
  String vacName;

  Vaccine({@required this.vacID, @required this.vacName});

  void display() {
    print('$vacID, $vacName');
  }
}
