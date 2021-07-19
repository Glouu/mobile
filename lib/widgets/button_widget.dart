import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onClick;

  const ButtonWidget({
    Key? key,
    required this.title,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: onClick,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Fellix-Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: StadiumBorder(),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(
          vertical: 18,
        ),
        textColor: Colors.white,
      );

  // Widget buildButton() =>
}
