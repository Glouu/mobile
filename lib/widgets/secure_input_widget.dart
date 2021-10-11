import 'package:flutter/material.dart';

class SecureInputWidget extends StatelessWidget {
  final TextEditingController textInput;
  final FocusNode textNode;
  final String labelTitle;
  final FormFieldValidator validationMsg;
  final bool isPasswordVisible;
  final VoidCallback onClick;
  const SecureInputWidget({
    Key? key,
    required this.textInput,
    required this.textNode,
    required this.labelTitle,
    required this.validationMsg,
    required this.isPasswordVisible,
    required this.onClick,
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
          obscureText: isPasswordVisible,
          decoration: InputDecoration(
            hintText: textNode.hasFocus ? null : labelTitle,
            suffixIcon: IconButton(
              onPressed: onClick,
              icon: isPasswordVisible
                  ? Icon(Icons.visibility_off_outlined)
                  : Icon(Icons.visibility_outlined),
            ),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
