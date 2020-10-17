import 'package:flutter/material.dart';
import 'package:app1/utilities/constants.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  MyAppBar({@required this.title});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.0),
      child: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: kOrangeColor,
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
