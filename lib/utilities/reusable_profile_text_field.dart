import 'package:flutter/material.dart';
import 'constants.dart';

class ReusableProfileTextField extends StatefulWidget {
  ReusableProfileTextField(
      {this.myController, this.hint, this.icon, this.enabled});

  final TextEditingController myController;
  final String hint;
  final Icon icon;
  final bool enabled;

  @override
  _ReusableProfileTextFieldState createState() =>
      _ReusableProfileTextFieldState();
}

class _ReusableProfileTextFieldState extends State<ReusableProfileTextField> {
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
        child: GestureDetector(
          child: TextFormField(
            enabled: widget.enabled,
            cursorColor: kOrangeColor,
            controller: widget.myController,
            decoration: InputDecoration(
              prefixIcon: widget.icon,
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: 18.0,
              ),
            ),
            autofocus: false,
          ),
        ),
        data: Theme.of(context).copyWith(primaryColor: kOrangeColor),
      ),
    );
  }
}
