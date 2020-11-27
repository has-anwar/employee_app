import 'dart:convert';
import 'dart:developer';

import 'package:app1/screens/AttendanceScreen.dart';
import 'package:flutter/material.dart';
import 'package:app1/utilities/constants.dart';
import 'package:app1/resources/my_drawer.dart';
import 'package:app1/resources/my_appbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:app1/utilities/prefs.dart';
import 'package:http/http.dart' as http;

class ViewAttendance extends StatefulWidget {
  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  Future<List> _getAttendanceList() async {
    int fid = await getEmployeeID();
    String path = '/attendance';
    http.Response response = await http.get(kUrl + path + '/$fid');
    log(response.statusCode.toString() + " " + response.body.toString());
    List attendanceList = jsonDecode(response.body)["Attendance"];
    log(attendanceList.length.toString());
    List<AttendanceData> _attendanceDataList = [];

    for (var atten in attendanceList) {
      AttendanceData attendanceData = AttendanceData(
          date: atten["Date"].toString(),
          time: atten["Time"].toString(),
          status: true);
      log(attendanceData.date + "    " + attendanceData.time);
      _attendanceDataList.add(attendanceData);
    }
    log(attendanceList.toString());
    return _attendanceDataList.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: MyAppBar(
        title: 'View Attendance',
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getAttendanceList();
        },
      ),
      body: Container(
        child: FutureBuilder(
          future: _getAttendanceList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<AttendanceData> data = snapshot.data;

              return SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text('Date'),
                    ),
                    DataColumn(
                      label: Text('Time'),
                    ),
                    DataColumn(
                      label: Text('Status'),
                    ),
                  ],
                  rows: data
                      .map(
                        (data) => DataRow(
                          cells: [
                            DataCell(
                              Container(
                                // width: SizeConfig.safeBlockHorizontal * 60,
                                child: Text(
                                  data.date,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: SizeConfig.safeBlockHorizontal * 30,
                                child: Text(
                                  data.time,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: SizeConfig.screenWidth,
                                child: Text(
                                  'Present',
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              );
            } else {
              return SpinKitHourGlass(
                color: kOrangeColor,
                size: 50.0,
              );
            }
          },
        ),
      ),
    );
  }
}

class AttendanceData {
  String date;
  String time;
  bool status;
  AttendanceData({@required this.date, @required this.time, this.status});
}
