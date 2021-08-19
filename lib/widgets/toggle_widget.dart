import 'package:flutter/material.dart';
import 'package:gloou/shared/colors/colors.dart';

class ToggleWidget extends StatelessWidget {
  final bool value;
  final ValueChanged onChanged;
  final double sizeNumber;
  final FocusNode toggleNode;
  const ToggleWidget({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.sizeNumber,
    required this.toggleNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: sizeNumber,
      child: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: mainColor,
        focusNode: toggleNode,
      ),
    );
  }
}
