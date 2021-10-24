import 'package:flutter/material.dart';

class friends extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('세세한 기록'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 300),
              color: Colors.amberAccent,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 300),
              color: Colors.amber,
            ),
          ],
        ),

      ),

      );
  }
}