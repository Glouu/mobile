import 'package:flutter/material.dart';
import 'package:gloou/shared/colors/colors.dart';

class TextWidget extends StatelessWidget {
  final TextEditingController textInput;
  final FocusNode textNode;
  final String labelTitle;
  final FormFieldValidator validationMsg;
  final int maxLines;
  const TextWidget({
    Key? key,
    this.maxLines = 1,
    required this.textInput,
    required this.textNode,
    required this.labelTitle,
    required this.validationMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        textNode.hasFocus
            ? Positioned(
                child: Text(
                  labelTitle,
                  style: TextStyle(color: Colors.grey[500]),
                ),
                left: 10,
                top: 5,
              )
            : textInput.text.isNotEmpty
                ? Positioned(
                    child: Text(
                      labelTitle,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    left: 10,
                    top: 5,
                  )
                : Text(''),
        TextFormField(
          controller: textInput,
          focusNode: textNode,
          validator: validationMsg,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: textNode.hasFocus ? null : labelTitle,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mainColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        )
      ],
    );
  }
}
