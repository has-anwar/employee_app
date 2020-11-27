import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:app1/utilities/constants.dart';
import 'package:app1/resources/bottom_button.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:app1/data/child_data.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var qrText = "";
  var errorMessage = "";
  bool flag = false;

  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          controller.resumeCamera();
        },
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: kOrangeColor,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: 300,
                      ),
                    ),
                    Center(
                      child: Text(
                        errorMessage,
                        style: TextStyle(fontSize: 20.0, color: Colors.red),
                      ),
                    ),
                  ],
                )),
            // Expanded(
            //   flex: 1,
            //   child: Center(
            //     child: Text('Scan result: $qrText'),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        setState(
          () async {
            qrText = scanData;
            List<String> safeGuard = scanData.split(" ");
            if ((safeGuard[0]) == kSafeGuard && safeGuard[2] == kSafeGuard) {
              // dispose();
              controller.pauseCamera();
              errorMessage = "";
              HapticFeedback.lightImpact();
              ChildData childData = await getChildInfo(safeGuard[1]);
              Navigator.popAndPushNamed(context, '/vac_screen',
                  arguments: childData);
            } else {
              controller.pauseCamera();
              HapticFeedback.lightImpact();
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Incorrect QR Code Scanned'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Generate new QR Code from official app'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          'Re-scan',
                          style: TextStyle(color: kOrangeColor),
                        ),
                        onPressed: () {
                          controller.resumeCamera();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<ChildData> getChildInfo(String token) async {
    // api.add_resource(ChildResource, '/child/<int:id>')
    // String path = '/child/$id';
    String path = '/child_token';
    var childResponse = await http.post(kUrl + path,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"token": "$token"}));
    print(childResponse);
    var data1 = jsonDecode(childResponse.body);
    int childId = data1['parent_id'];
    path = '/parent_info/$childId';
    var parentResponse = await http.get(kUrl + path);
    var parentData = jsonDecode(parentResponse.body);
    // TODO: Remove dis
    // print(data1);
    // print(parentData);
    ChildData childData = ChildData(
        data1['child_id'],
        data1['name'],
        data1['dob'],
        data1['parent_id'],
        data1['age'],
        parentData['father'],
        parentData['mother']);

    return childData;
  }
}
