import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';

class ChipsFormWidget extends StatefulWidget {
  final ValueChanged onChange;
  final ChipsInputSuggestions findSuggestions;
  final ChipsBuilder chipBuilder;
  final ChipsBuilder suggestionBuilder;
  const ChipsFormWidget({
    Key? key,
    required this.onChange,
    required this.findSuggestions,
    required this.chipBuilder,
    required this.suggestionBuilder,
  }) : super(key: key);

  @override
  _ChipsFormWidgetState createState() => _ChipsFormWidgetState();
}

class _ChipsFormWidgetState extends State<ChipsFormWidget> {
  final _chipKey = GlobalKey<ChipsInputState>();

  @override
  Widget build(BuildContext context) {
    return ChipsInput(
      key: _chipKey,
      allowChipEditing: true,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE3E5EA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE3E5EA)),
        ),
      ),
      findSuggestions: widget.findSuggestions,
      onChanged: widget.onChange,
      chipBuilder: widget.chipBuilder,
      suggestionBuilder: widget.suggestionBuilder,
    );
  }
}
