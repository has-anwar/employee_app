import 'package:flutter/material.dart';
import 'package:app1/utilities/logo.dart';
import 'package:app1/utilities/constants.dart';
import 'package:app1/utilities/prefs.dart';
import 'package:app1/utilities/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var name = 'loading...';
  var email = 'loading...';
  getInfo() async {
    var _name = await getName();
    var _email = await getEmail();
    UserInfo userInfo = UserInfo(name: _name, email: _email);

    setState(() {
      name = userInfo.name;
      email = userInfo.email;
    });
  }

  void logOff() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.01),
                  Logo(),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    email,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: kBackgroundColor,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 25.0,
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 25.0,
                        color: kOrangeColor,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile_screen');
                },
              ),
              SizedBox(
                height: height * 0.6,
              ),
              ListTile(
                title: Row(
                  children: [
                    SizedBox(
                      width: width * 0.009,
                    ),
                    Icon(
                      Icons.exit_to_app,
                      size: 27.0,
                      color: Colors.red[900],
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Text(
                      'LOG OUT',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 27,
                        color: Colors.red[900],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text('Log out'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              logOff();
                              Navigator.popAndPushNamed(context, '/login');
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.red[900]),
                            )),
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'No',
                            style: TextStyle(color: kOrangeColor),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
