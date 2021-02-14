import 'dart:convert';

import 'package:app1/utilities/date_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app1/data/child_data.dart';
import 'package:app1/utilities/constants.dart';
import 'package:app1/data/vaccine_data.dart';
import 'package:app1/resources/my_appbar.dart';
import 'package:app1/utilities/prefs.dart';
import 'package:http/http.dart' as http;

class VaccinationScreen extends StatefulWidget {
  @override
  _VaccinationScreenState createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> {
  List<bool> flags = [];
  String vaccineName;
  List<Vaccine> vacs = [];
  double _fontSize = 20.0;
  Color textColor = Color(0xFFF212121);
  Color cardColor = Color(0xFFFE5E5E5);

  Future<List<Vaccine>> getVaccines() async {
    String path = '/vaccine_list';
    var response = await http.get(kUrl + path);
    var data = jsonDecode(response.body);
    // print('Data: $data');
    List<Vaccine> vaccines = [];
    for (var vac in data['names']) {
      Vaccine vaccine = Vaccine(vacID: vac['id'], vacName: vac['name']);
      vaccines.add(vaccine);
      flags.add(false);
    }
    vacs = List.from(vaccines);
    return vaccines;
  }

  Future<int> getEmpID() async {
    empID = await getEmployeeID();
    return empID;
  }

  bool _isValid = false;
  isVaccineValid() {
    if (vaccineName != null) {
      setState(() {
        _isValid = true;
      });
    } else {
      setState(() {
        _isValid = false;
      });
    }
  }

  void eSignRecord(ChildData args, String date) {
    {
      showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text("Confirm"),
              content: Text(
                "Are you sure you want to update vaccination record of ${args.childName} with $vaccineName?",
              ),
              actions: <Widget>[
                Row(
                  children: [
                    MaterialButton(
                        splashColor: Colors.red[100],
                        elevation: 5.0,
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.red[900]),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    MaterialButton(
                      splashColor: Colors.orange[100],
                      elevation: 5.0,
                      child: Text(
                        "Yes",
                        style: TextStyle(color: kOrangeColor),
                      ),
                      onPressed: () async {
                        String path = '/vaccine_records/${args.childId}';
                        final http.Response response = await http.post(
                          kUrl + path,
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(
                            <String, String>{
                              "vac_name": "$vaccineName",
                              "child_id": "${args.childId}",
                              "emp_id": "$empID",
                              if (date != null) 'dor': "$date"
                            },
                          ),
                        );
                        Navigator.of(context).pop();
                        if (response.statusCode == 200) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return WillPopScope(
                                onWillPop: () async => false,
                                child: AlertDialog(
                                  title: Text("Updated!"),
                                  content: Text(
                                    "Record has been successfully updated",
                                  ),
                                  actions: <Widget>[
                                    MaterialButton(
                                        elevation: 5.0,
                                        child: Text(
                                          "Go to Dashboard",
                                          style: TextStyle(color: kOrangeColor),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context)
                                              .popAndPushNamed('/home');
                                        })
                                  ],
                                  elevation: 24.0,
                                  // backgroundColor: kOrangeColor,
                                ),
                              );
                            },
                            barrierDismissible: false,
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return WillPopScope(
                                onWillPop: () async => false,
                                child: AlertDialog(
                                  title: Text("Error"),
                                  content: Text(
                                    "Something went wrong",
                                  ),
                                  actions: <Widget>[
                                    MaterialButton(
                                        elevation: 5.0,
                                        child: Text(
                                          "Re-Try",
                                          style: TextStyle(color: kOrangeColor),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })
                                  ],
                                  elevation: 24.0,
                                  // backgroundColor: kOrangeColor,
                                ),
                              );
                            },
                            barrierDismissible: false,
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
              elevation: 24.0,
              // backgroundColor: kOrangeColor,
            ),
          );
        },
        barrierDismissible: false,
      );
    }
    ;
  }

  Future<void> _showMyDialog(ChildData args) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('Select Date for Re-administration'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  DateTimeDialog(
                    dateCallback: dateCallback,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                splashColor: Colors.red[100],
                child: Text(
                  'Dismiss',
                  style: TextStyle(color: Colors.red[900]),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                splashColor: Colors.orange[100],
                child: Text(
                  'Approve and Update',
                  style: TextStyle(color: kOrangeColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  eSignRecord(args, date);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void dateCallback(_dateFromCallback) {
    setState(() {
      print('Date from callback>>>$_dateFromCallback');
      date = _dateFromCallback;
      print('Date>>>$date');
    });
  }

  String date;

  int empID;

  Future<List<Vaccine>> _func;

  @override
  void initState() {
    print(vaccineName);
    getEmpID();
    _func = getVaccines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ChildData args = ModalRoute.of(context).settings.arguments;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(
        title: 'Vaccination',
      ),
      body: Container(
        child: FutureBuilder(
          future: _func,
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                height: height * 0.7,
                child: SimpleDialog(
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
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: Card(
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      margin: EdgeInsets.all(20.0),
                      elevation: 7.0,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
                            child: Text(
                              '${args.childName}',
                              style: TextStyle(
                                fontSize: _fontSize + 5,
                                color: textColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Divider(
                            color: Color(0xFFFBDBDBD),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0,
                                top: 0.0,
                                right: 25.0,
                                bottom: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  'Father: ${args.fatherName}',
                                  style: TextStyle(
                                    fontSize: _fontSize,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0,
                                top: 0.0,
                                right: 25.0,
                                bottom: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  'Mother: ${args.motherName}',
                                  style: TextStyle(
                                    fontSize: _fontSize,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Vaccines',
                          style: TextStyle(
                            color: kOrangeColor,
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    flex: 7,
                    fit: FlexFit.loose,
                    child: ScrollConfiguration(
                      behavior: ScrollBehavior(),
                      child: GlowingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        color: kOrangeColor,
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            Vaccine vac = snapshot.data[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: SizedBox(
                                height: height * 0.06,
                                child: Column(
                                  children: [
                                    CheckboxListTile(
                                      title: Text(vac.vacName),
                                      value: flags[index],
                                      activeColor: kOrangeColor,
                                      onChanged: (bool value) {
                                        if (!value) {
                                          setState(() {
                                            vaccineName = null;
                                            _isValid = false;
                                            for (int i = 0;
                                                i < flags.length;
                                                i++) {
                                              flags[i] = false;
                                            }
                                          });
                                        }
                                        if (value) {
                                          setState(() {
                                            _isValid = true;
                                            flags[index] = value;
                                            vaccineName = vacs[index].vacName;
                                            for (int i = 0;
                                                i < flags.length;
                                                i++) {
                                              if (i != index) {
                                                flags[i] = false;
                                              }
                                            }
                                          });
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 300.0, top: 10.0, bottom: 20.0),
                      child: FloatingActionButton.extended(
                        backgroundColor: _isValid ? kOrangeColor : Colors.grey,
                        icon: Icon(
                          Icons.assignment_outlined,
                          // size: 40.0,
                          color: Colors.white,
                        ),
                        label: Text('e-Sign'),
                        onPressed: _isValid ? () => _showMyDialog(args) : null,
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
