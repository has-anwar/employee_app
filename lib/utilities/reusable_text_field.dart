import 'package:flutter/material.dart';
import 'package:app1/utilities/constants.dart';

class ReusableTextField extends StatefulWidget {
  ReusableTextField({
    @required this.hint,
    @required this.icon,
    @required this.obscureText,
    @required this.myController,
  });

  final String hint;
  final Icon icon;
  final bool obscureText;
  final TextEditingController myController;

  @override
  _ReusableTextFieldState createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  @override
  void dispose() {
    widget.myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Theme(
        child: TextFormField(
          controller: widget.myController,
          cursorColor: kOrangeColor,
          decoration: InputDecoration(
            prefixIcon: widget.icon,
            border: InputBorder.none,
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontSize: 18.0,
            ),
          ),
          obscureText: widget.obscureText,
          autofocus: false,
        ),
        data: Theme.of(context).copyWith(primaryColor: kOrangeColor),
      ),
    );
  }
}
