import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final Color color;
  final void Function() onpress;
  const RoundButton({
    required Key key,
    required this.text,
    required this.color,
    required this.onpress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: Material(
        elevation: 5.0,
        color: this.color,
        borderRadius: BorderRadius.circular(18.0),
        child: MaterialButton(
          onPressed: onpress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
