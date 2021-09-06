import 'package:flutter/material.dart';

class TextIconWidget extends StatelessWidget {
  final IconData icons;
  final double iconSize;
  final String value;
  final VoidCallback onPress;
  final Color color;
  const TextIconWidget({
    Key? key,
    required this.icons,
    required this.iconSize,
    required this.value,
    required this.onPress,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPress,
          icon: Icon(icons),
          color: color,
          iconSize: iconSize,
        ),
        Text(
          value,
          style: TextStyle(color: color),
        )
      ],
    );
  }
}
