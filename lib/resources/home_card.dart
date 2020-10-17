import 'package:flutter/material.dart';

class HomeCard extends StatefulWidget {
  HomeCard({@required this.title, @required this.imageName});

  String title;
  String imageName;

  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 1,
        margin: EdgeInsets.fromLTRB(40, 20, 40, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/${widget.imageName}'),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7),
                      BlendMode.dstATop,
                    ),
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              Center(
                child: Opacity(
                  opacity: 1,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
