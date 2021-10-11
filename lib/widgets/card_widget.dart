import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final int index;
  const CardWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Image.network(
        'https://source.unsplash.com/random?sig=${widget.index}',
        fit: BoxFit.cover,
      ),
    );
  }
}
