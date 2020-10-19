import 'package:flutter/material.dart';

class CircularProgressor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: CircularProgressIndicator(
          backgroundColor: Colors.indigo[900],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
        ),
      ),
    );
  }
}
