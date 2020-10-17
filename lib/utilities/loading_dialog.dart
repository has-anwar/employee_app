import 'package:flutter/material.dart';
import 'constants.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            key: key,
            backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(kOrangeColor),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please Wait....",
                      style: TextStyle(color: kOrangeColor),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
