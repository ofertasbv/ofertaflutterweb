import 'package:flutter/material.dart';

class CircularProgressorMini extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          strokeWidth: 1,
          backgroundColor: Colors.purple[800],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[800]),
        ),
      ),
    );
  }
}
