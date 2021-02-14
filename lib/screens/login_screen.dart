import 'package:app1/screens/splash_screen.dart';
import 'package:app1/utilities/prefs.dart';
import 'package:flutter/material.dart';
import 'package:app1/utilities/constants.dart';
import 'package:app1/utilities/reusable_card.dart';
import 'package:app1/utilities/reusable_text_field.dart';
import 'package:app1/resources/bottom_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:app1/utilities/prefs.dart';
import 'package:app1/utilities/logo.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final textController = TextEditingController();
  final passwordController = TextEditingController();

  final usernameSnackBar = SnackBar(
      content: Text(
    'Incorrect email or password',
    style: TextStyle(
      fontSize: 20.0,
    ),
  ));

  bool checkEmpty() {
    if (textController.text.isEmpty || passwordController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void login(context) async {
    String username = textController.text;
    String password = passwordController.text;
    String path = '/employee/account/$username';
    var response = await http.post(
      kUrl + path,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{'email': username, 'passcode': password},
      ),
    );
    var userInfo = jsonDecode(response.body);
    print('userInfo');
    print(userInfo);
    if (userInfo['flag'] == true) {
      setPrefs(userInfo);
      Navigator.pushReplacementNamed(context, SplashScreen.id);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline_outlined,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text('Incorrect login credentials entered'),
            ],
          ),
        ),
      );
    }
  }

  final Color errorColor = Colors.red[900];
  Color backgroundColor = kBackgroundColor;

  void displayErrorLogin() {
    backgroundColor = errorColor;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            height: height,
            color: kBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.2),
                Center(
                  child: Hero(tag: 'tag1', child: Logo()),
                ),
                SizedBox(height: height * 0.1),
                Row(
                  children: [
                    SizedBox(width: width * 0.2),
                    Icon(
                      Icons.cancel,
                      color: backgroundColor,
                    ),
                    SizedBox(width: width * 0.04),
                    Text(
                      'Incorrect email or password',
                      style: TextStyle(color: backgroundColor, fontSize: 20.0),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                ReusableCard(
                  cardChild: ReusableTextField(
                    hint: 'example@gmail.com',
                    icon: Icon(Icons.account_circle),
                    obscureText: false,
                    myController: textController,
                  ),
                  colour: kTextFieldBackgroundColor,
                ),
                SizedBox(height: height * 0.009),
                ReusableCard(
                  cardChild: ReusableTextField(
                    hint: 'password',
                    icon: Icon(Icons.lock),
                    obscureText: true,
                    myController: passwordController,
                  ),
                  colour: kTextFieldBackgroundColor,
                ),
                SizedBox(height: height * 0.1),
                Builder(
                  builder: (context) => BottomButton(
                    buttonTitle: 'Log In',
                    onTap: () async {
                      bool flag = checkEmpty();
                      if (flag) {
                        print(flag);
                        login(context);
                      } else {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  Icons.error_outline_outlined,
                                  color: Colors.yellow,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text('Please enter login credentials'),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
