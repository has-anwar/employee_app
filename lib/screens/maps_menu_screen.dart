import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';

import 'package:app1/utilities/constants.dart';
import 'package:app1/utilities/prefs.dart';
import 'package:app1/utilities/Location.dart';

class MapsMenuScreen extends StatefulWidget {
  @override
  _MapsMenuScreenState createState() => _MapsMenuScreenState();
}

class _MapsMenuScreenState extends State<MapsMenuScreen> {
  Future<List<Location>> getLocations() async {
    int id = await getEmployeeID();
    String url = kUrl + '/visit_locations/$id';
    var response = await http.get(url);
    var locations = jsonDecode(response.body);
    List<Location> locationList = [];

    for (var location in locations['locs']) {
      Location loc = Location(location: location['loc']);
      locationList.add(loc);
    }
    return locationList;
  }

  Future<List<Location>> _func;

  @override
  void initState() {
    _func = getLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Locations'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kOrangeColor,
      ),
      body: Container(
        child: FutureBuilder<List<Location>>(
          future: _func,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                width: width,
                height: height * 0.4,
                child: Center(
                  child: CircularProgressIndicator(
                    // backgroundColor: kOrangeColor,
                    valueColor: AlwaysStoppedAnimation<Color>(kOrangeColor),
                  ),
                ),
              );
            } else {
              List<Location> data = snapshot.data;
              return Container(
                height: height,
                width: width,
                child: DataTable(
                  showCheckboxColumn: false,
                  sortColumnIndex: 0,
                  sortAscending: true,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // fontSize: 25.0,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Navigate',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // fontSize: 25,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: data
                      .map(
                        (loc) => DataRow(
                          onSelectChanged: (bool selected) =>
                              MapsLauncher.launchQuery(loc.location),
                          cells: [
                            DataCell(
                              Container(
                                width: SizeConfig.safeBlockHorizontal * 60,
                                child: Text(
                                  loc.location,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: IconButton(
                                  icon: Icon(Icons.map),
                                  onPressed: () {
                                    MapsLauncher.launchQuery(loc.location);
                                  },
                                  // color: kOrangeColor,
                                  // size: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
