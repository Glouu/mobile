import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

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
        Bounce(
          child: Icon(
            icons,
            color: color,
            size: iconSize,
          ),
          duration: Duration(milliseconds: 300),
          onPressed: onPress,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          value,
          style: TextStyle(color: color),
        )
      ],
    );
  }
}
