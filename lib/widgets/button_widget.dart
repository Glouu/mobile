import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onClick;
  final bool isButtonActive;

  const ButtonWidget(
      {Key? key,
      required this.title,
      required this.onClick,
      required this.isButtonActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: isButtonActive ? null : onClick,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
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
        disabledColor: Theme.of(context).primaryColor.withOpacity(0.5),
        disabledTextColor: Colors.white.withOpacity(0.5),
      );

  // Widget buildButton() =>
}
