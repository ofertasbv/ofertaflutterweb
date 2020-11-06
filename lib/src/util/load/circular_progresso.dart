import 'package:flutter/material.dart';

class CircularProgressor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 150,
        width: 150,
        child: CircularProgressIndicator(
          backgroundColor: Colors.indigo[900],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.lime[900]),
        ),
      ),
    );
  }
}
