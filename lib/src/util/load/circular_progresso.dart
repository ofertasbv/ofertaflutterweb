import 'package:flutter/material.dart';

class CircularProgressor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 150,
        width: 150,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey[900],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[900]),
        ),
      ),
    );
  }
}
