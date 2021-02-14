import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app1/utilities/constants.dart';
import 'package:app1/utilities/reusable_text_field.dart';
import 'package:app1/resources/my_drawer.dart';
import 'package:app1/resources/profile_labels.dart';
import 'package:app1/utilities/prefs.dart';
import 'package:app1/resources/my_appbar.dart';
import 'package:http/http.dart' as http;

class UpdatePassword extends StatefulWidget {
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController currentPasswordController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  bool currentFlag = true;
  bool newFlag = true;
  bool confirmFlag = true;
  bool lengthFlag = true;

  IconData iconData;

  getUsername() async {
    String username = await getEmail();
    return username;
  }

  final Color errorColor = Colors.red[900];

  Color backgroundColor = kBackgroundColor;

  void getFlags() {
    if (currentPasswordController.text.isEmpty) {
      currentFlag = false;
    }
    if (newPasswordController.text.isEmpty) {
      newFlag = false;
    }
    if (confirmPasswordController.text.isEmpty) {
      confirmFlag = false;
    }
    if (newPasswordController.text.length <= 7 ||
        confirmPasswordController.text.length <= 7) {
      lengthFlag = false;
    }
  }

  confirmCurrentPassword() async {
    int id = await getEmployeeID();
    String path = '/employee/$id';

    var response = await http.post(
      kUrl + path,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'passcode': currentPasswordController.text,
          'new': confirmPasswordController.text
        },
      ),
    );
    return response;
  }

  void updatePassword(context) async {
    getFlags();
    if (currentFlag && newFlag && confirmFlag) {
      if (confirmPasswordController.text == newPasswordController.text) {
        var response = await confirmCurrentPassword();
        var userInfo = jsonDecode(response.body);
        if (userInfo['flag'] == true) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline_outlined,
                  color: Colors.yellow,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text('Password updated successfully!')
              ],
            ),
          ));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline_outlined,
                  color: Colors.yellow,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text('Incorrect password entered')
              ],
            ),
          ));
        }
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline_outlined,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text('Passwords do not match')
            ],
          ),
        ));
      }
    } else {
      if (!currentFlag) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline_outlined,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text('Current password cannot be left empty')
            ],
          ),
        ));
      }
      if (!newFlag) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline_outlined,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text('Please enter a new password')
            ],
          ),
        ));
      }
      if (!confirmFlag) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline_outlined,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text('Please confirm new password')
            ],
          ),
        ));
      }
      setState(() {
        currentFlag = true;
        newFlag = true;
        confirmFlag = true;
      });
    }
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  void resetErrors() {
    setState(() {
      backgroundColor = kBackgroundColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(
        title: 'Change Password',
      ),
      drawer: MyDrawer(),
      body: GestureDetector(
        onTap: () {
          resetErrors();
        },
        child: Container(
          height: height * 0.95,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.15,
                ),
                ProfileLabelText(label: 'Current Password'),
                ReusableTextField(
                  hint: 'Enter current password',
                  myController: currentPasswordController,
                  obscureText: true,
                  icon: Icon(
                    Icons.vpn_key,
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                ProfileLabelText(label: 'Enter new Password'),
                ReusableTextField(
                  hint: 'Enter new password',
                  myController: newPasswordController,
                  obscureText: true,
                  icon: Icon(
                    Icons.vpn_key,
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                ProfileLabelText(label: 'Confirm new Password'),
                ReusableTextField(
                  hint: 'Confirm new password',
                  myController: confirmPasswordController,
                  obscureText: true,
                  icon: Icon(
                    Icons.vpn_key,
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Builder(
                  builder: (context) {
                    return ButtonTheme(
                      minWidth: 200.0,
                      height: 60.0,
                      child: RaisedButton(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.red[900],
                        textColor: Colors.white,
                        child: Text('Update Password'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () {
                          updatePassword(context);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
