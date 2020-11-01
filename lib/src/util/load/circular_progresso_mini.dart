import 'package:flutter/material.dart';

class CircularProgressorMini extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          backgroundColor: Colors.indigo[900],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.lime[900]),
        ),
      ),
    );
  }
}
