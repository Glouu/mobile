import 'package:flutter/material.dart';

class TextMediaWidget extends StatelessWidget {
  final TextEditingController textInput;
  final FocusNode textNode;
  final String labelTitle;
  final FormFieldValidator validationMsg;
  final int maxLines;
  final Widget prefix;
  const TextMediaWidget({
    Key? key,
    this.maxLines = 1,
    required this.textInput,
    required this.textNode,
    required this.labelTitle,
    required this.validationMsg,
    required this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textInput,
      focusNode: textNode,
      validator: validationMsg,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelTitle,
        filled: true,
        fillColor: Color(0xFFE3E5EA),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFFE3E5EA)),
        ),
        labelStyle: TextStyle(height: 5),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFFE3E5EA)),
        ),
        prefixIcon: prefix,
      ),
    );
  }
}
