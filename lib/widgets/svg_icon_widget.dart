import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconWidget extends StatelessWidget {
  final String imageLoc;
  final String value;
  final VoidCallback onPress;
  final Color color;
  const SvgIconWidget(
      {Key? key,
      required this.imageLoc,
      required this.value,
      required this.onPress, required this.color,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            child: SvgPicture.asset(
              imageLoc,
              color: color,
              height: 24,
              width: 24,
            ),
            onTap: onPress,
          ),
        ),
        Text(
          value,
          style: TextStyle(color: color),
        )
      ],
    );
  }
}
