import 'package:flutter/material.dart';

class NumberWidget extends StatelessWidget {
  final TextEditingController textInput;
  final FocusNode textNode;
  final String labelTitle;
  final FormFieldValidator validationMsg;
  final int numberMax;
  const NumberWidget({
    Key? key,
    required this.textInput,
    required this.textNode,
    required this.numberMax,
    required this.labelTitle,
    required this.validationMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textInput,
      focusNode: textNode,
      maxLength: numberMax,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validationMsg,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelTitle,
        border: OutlineInputBorder(),
      ),
    );
  }
}
