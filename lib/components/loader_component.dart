// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class LoaderComponent extends StatelessWidget {
  final String text;

  LoaderComponent({this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xFFFFEB3B),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
