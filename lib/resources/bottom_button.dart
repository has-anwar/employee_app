import 'package:flutter/material.dart';
import 'package:app1/utilities/constants.dart';

class BottomButton extends StatelessWidget {
  BottomButton({@required this.buttonTitle, @required this.onTap});

  final Function onTap;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            buttonTitle,
            style: TextStyle(fontSize: 25.0, color: Color(0xFFFF521A)),
          ),
        ),
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 80),
        width: double.infinity,
        height: kBottomContainerHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          color: kBackgroundColor,
        ),
      ),
    );
  }
}
