import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onClick;

  const TextButtonWidget({Key? key, required this.title, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
      onPressed: onClick,
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            fontFamily: 'Fellix-Bold',
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ));
}
