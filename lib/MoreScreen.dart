import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 50),
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.black,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15, bottom: 30),
                child: Text(
                  'name',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 150),
                  color: Colors.white
              ),
              Container(
                  padding: EdgeInsets.only(top: 135),
                  color: Colors.purpleAccent
              ),
            ],
          )
      ),
    );

  }
}