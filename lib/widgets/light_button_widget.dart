import 'package:flutter/material.dart';

class LightButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onClick;
  final bool isButtonActive;
  final Key buttonKey;

  const LightButtonWidget({
    Key? key,
    required this.title,
    required this.onClick,
    required this.isButtonActive,
    required this.buttonKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        key: buttonKey,
        onPressed: isButtonActive ? onClick : null,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Fellix-Bold',
          ),
        ),
        shape: StadiumBorder(),
        textColor: Theme.of(context).primaryColor,
        color: Colors.white60,
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 25),
      );
}
