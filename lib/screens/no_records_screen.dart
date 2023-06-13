import 'package:flutter/material.dart';

class NoRecordFound extends StatelessWidget {
  const NoRecordFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "No records found",
          style: TextStyle(color: Colors.black),
        ),
        Icon(Icons.search_off),
      ],
    ));
  }
}
