import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final TextEditingController textInput;
  final FocusNode textNode;
  final String labelTitle;
  final FormFieldValidator validationMsg;
  const TextWidget({
    Key? key,
    required this.textInput,
    required this.textNode,
    required this.labelTitle,
    required this.validationMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textInput,
      focusNode: textNode,
      validator: validationMsg,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelTitle,
        border: OutlineInputBorder(),
      ),
    );
  }
}
