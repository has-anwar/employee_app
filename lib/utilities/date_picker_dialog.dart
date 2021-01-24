import 'package:app1/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeDialog extends StatefulWidget {
  final Function dateCallback;
  DateTimeDialog({@required this.dateCallback});
  @override
  _DateTimeDialogState createState() => _DateTimeDialogState();
}

class _DateTimeDialogState extends State<DateTimeDialog> {
  DateTime _dateTime;
  String getDate() {
    DateFormat _formatter = DateFormat('yyyy/MM/dd');
    String _date = _formatter.format(_dateTime);
    return _date;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            _dateTime == null
                ? 'No date has been picked so re-administration date will not be updated'
                : "Re-administration date: ${getDate()}",
            style: TextStyle(
                color: _dateTime == null ? Colors.red[800] : Colors.black87),
          ),
          SizedBox(
            height: 22.0,
          ),
          Row(
            children: [
              Text('Pick date'),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.calendar_today,
                  color: kOrangeColor,
                ),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(2225),
                  ).then((date) {
                    setState(() {
                      _dateTime = date;
                      widget.dateCallback(getDate());
                    });
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
