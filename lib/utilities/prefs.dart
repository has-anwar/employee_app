import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

setEmployeeID(int id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setInt('parent_id', id);
}

getEmployeeID() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getInt('parent_id');
}

setCNIC(String cnic) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('cnic', cnic);
}

getCNIC() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('cnic');
}

setName(String name) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('name', name);
}

getName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('name');
}

setPhoneNumber(String number) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('number', number);
}

getPhoneNumber() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('number');
}

setPassword(String password) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('password', password);
}

getPassword() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('password');
}

setOfficeID(int id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setInt('office_id', id);
}

getOfficeID() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getInt('office_id');
}

setEmail(String email) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('email', email);
}

getEmail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('email');
}

setPrefs(userInfo) async {
  int id = userInfo['id'];
  String name = userInfo['name'];
  String cnic = userInfo['cnic'];
  String email = userInfo['email'];
  int office_id = userInfo['office_id'];
  String number = userInfo['number'];
  setEmployeeID(id);
  setName(name);
  setCNIC(cnic);
  setEmail(email);
  setPhoneNumber(number);
  setOfficeID(office_id);
}

getPrefs() async {
  print('PRINTING STORED PREFS');
  int id = await getEmployeeID();
  print(id);
  String name = await getName();
  print(name);
  String cnic = await getCNIC();
  print(cnic);
  String email = await getEmail();
  print(email);
  String number = await getPhoneNumber();
  print(number);
  int address = await getOfficeID();
  print(address);
}
