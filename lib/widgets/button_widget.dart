import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onClick;
  final bool isButtonActive;
  final Color buttonColor;

  const ButtonWidget({
    Key? key,
    required this.title,
    required this.onClick,
    required this.isButtonActive,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: isButtonActive ? null : onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isButtonActive
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Container(),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Fellix-Bold',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        shape: StadiumBorder(),
        color: buttonColor,
        padding: EdgeInsets.symmetric(
          vertical: 18,
        ),
        textColor: Colors.white,
        disabledColor: Theme.of(context).primaryColor.withOpacity(0.5),
        disabledTextColor: Colors.white.withOpacity(0.5),
      );
}
