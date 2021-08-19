import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onClick;
  final double fontSize;

  const TextButtonWidget({
    Key? key,
    required this.title,
    required this.onClick,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
      onPressed: onClick,
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Fellix-Bold',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ));
}
