import 'package:flutter/material.dart';

class ToastMessage extends StatelessWidget {
  final String status;
  final String message;
  const ToastMessage({Key? key, required this.status, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Icon(
              () {
                if (status == 'success') {
                  return Icons.check_circle_rounded;
                } else if (status == 'error') {
                  return Icons.error_rounded;
                } else if (status == 'warning') {
                  return Icons.warning_rounded;
                } else if (status == 'info') {
                  return Icons.info_rounded;
                }
              }(),
              color: () {
                if (status == 'success') {
                  return Colors.green;
                } else if (status == 'error') {
                  return Colors.red;
                } else if (status == 'warning') {
                  return Colors.amber;
                } else if (status == 'info') {
                  return Colors.blue;
                }
              }(),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          )
        ],
      ),
    );
    // return Scaffold(
    //   body: Container(
    //     padding: EdgeInsets.all(32),
    //     alignment: Alignment.center,
    //     child: ,
    //   ),
    // );
  }
}
