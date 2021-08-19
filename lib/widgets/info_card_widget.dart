import 'package:flutter/material.dart';
import 'package:gloou/shared/colors/colors.dart';

class InfoCardWidget extends StatelessWidget {
  final String title;
  final String description;
  const InfoCardWidget({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFdadbf4),
      elevation: 0.5,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mainColor,
                letterSpacing: 0.7,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                letterSpacing: 0.8,
              ),
            )
          ],
        ),
      ),
    );
  }
}
