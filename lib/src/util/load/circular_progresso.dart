import 'package:flutter/material.dart';

class CircularProgressor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 150,
        width: 150,
        child: CircularProgressIndicator(
          backgroundColor: Colors.purple[800],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow[800]),
        ),
      ),
    );
  }
}
