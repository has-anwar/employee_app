import 'package:flutter/material.dart';
import 'package:app1/utilities/constants.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'online',
        style: kLogoStyleOne,
        children: [
          TextSpan(
            text: 'VRS',
            style: kLogoStyleTwo,
          ),
        ],
      ),
    );
  }
}
