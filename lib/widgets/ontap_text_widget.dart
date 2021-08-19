import 'package:flutter/material.dart';

class OnTapTextWidget extends StatelessWidget {
  final TextEditingController textInput;
  final FocusNode textNode;
  final String labelTitle;
  final GestureTapCallback tapAction;
  final FormFieldValidator validationMsg;
  const OnTapTextWidget({
    Key? key,
    required this.textInput,
    required this.textNode,
    required this.labelTitle,
    required this.tapAction,
    required this.validationMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textInput,
      focusNode: textNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validationMsg,
      showCursor: false,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelTitle,
        border: OutlineInputBorder(),
      ),
      onTap: tapAction,
    );
  }
}
