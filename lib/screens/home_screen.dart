// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:william_serna_parcial_final/models/token.dart';

class HomeScreen extends StatefulWidget {
  final Token token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Vehicles'),
        ),
        body: Text('hola'));
  }
}
