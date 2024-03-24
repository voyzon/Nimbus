import 'package:flutter/material.dart';

class CompletedSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.black,
            height: 20,
            indent: 10,
            endIndent: 10,
          ),
        ),
        Text(
          'Completed',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.black,
            height: 20,
            indent: 10,
            endIndent: 10,
          ),
        ),
      ],
    );
  }
}
