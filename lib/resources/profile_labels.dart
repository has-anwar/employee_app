import 'package:app1/utilities/constants.dart';
import 'package:flutter/material.dart';

class ProfileLabelText extends StatelessWidget {
  ProfileLabelText({@required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(fontSize: 25.0, color: kOrangeColor),
    );
  }
}
