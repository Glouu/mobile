import 'package:flutter/material.dart';

class TextPostWidget extends StatelessWidget {
  final TextEditingController textInput;
  final FocusNode textNode;
  final String labelTitle;
  final FormFieldValidator validationMsg;
  final int maxLines;
  final Widget prefix;
  final String hint;
  const TextPostWidget({
    Key? key,
    required this.textInput,
    required this.textNode,
    required this.labelTitle,
    required this.validationMsg,
    required this.maxLines,
    required this.prefix,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        textNode.hasFocus ? Text('') : Positioned(child: Text(labelTitle)),
        TextFormField(
          controller: textInput,
          focusNode: textNode,
          validator: validationMsg,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: textNode.hasFocus ? hint : null,
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }
}
