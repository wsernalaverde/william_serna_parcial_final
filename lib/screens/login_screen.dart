// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:william_serna_parcial_final/components/loader_component.dart';
import 'package:william_serna_parcial_final/helpers/constans.dart';
import 'package:william_serna_parcial_final/models/token.dart';
import 'package:william_serna_parcial_final/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showLoader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuesta del curso'),
        backgroundColor: Color(0xFF060606),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 90,
                ),
                _showLogo(),
                showDescription(),
                SizedBox(
                  height: 30,
                ),
                showButton()
              ],
            ),
          ),
          _showLoader ? LoaderComponent(text: 'Procesando...') : Container(),
        ],
      ),
    );
  }

  Widget _showLogo() {
    return Image(
      image: AssetImage('assets/logo-ws.png'),
      width: 180,
    );
  }

  Widget showButton() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () => _loginFacebook(),
                      icon: FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.white,
                      ),
                      label: Text('Iniciar sesi??n con Facebook'),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF3B5998), onPrimary: Colors.white)))
            ],
          )
        ],
      ),
    );
  }

  Widget showDescription() {
    return Padding(
      padding: EdgeInsets.only(left: 40, bottom: 0, right: 40, top: 20),
      child: Text(
        'D??janos los comentarios de como te pareci?? el curso y califica tu experiencia.',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF060606)),
      ),
    );
  }

  void _loginFacebook() async {
    setState(() {
      _showLoader = true;
    });

    await FacebookAuth.i.logOut();
    var result = await FacebookAuth.i.login(
      permissions: ["public_profile", "email"],
    );

    if (result.status != LoginStatus.success) {
      setState(() {
        _showLoader = false;
      });

      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'Hubo un problema al obtener el usuario de Facebook, por favor intenta m??s tarde.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    final requestData = await FacebookAuth.i.getUserData(
      fields:
          "email, name, picture.width(800).heigth(800), first_name, last_name",
    );

    var picture = requestData['picture'];
    var data = picture['data'];

    Map<String, dynamic> request = {
      'email': requestData['email'],
      'id': requestData['id'],
      'loginType': 2,
      'fullName': requestData['name'],
      'photoURL': data['url'],
      'firtsName': requestData['first_name'],
      'lastName': requestData['last_name'],
    };

    await _socialLogin(request);
  }

  Future _socialLogin(Map<String, dynamic> request) async {
    var url = Uri.parse('${Constans.apiUrl}/api/Account/SocialLogin');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    setState(() {
      _showLoader = false;
    });

    if (response.statusCode >= 400) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'El usuario ya inci?? sesi??n previamente por email o por otra red social.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    var body = response.body;

    var decodedJson = jsonDecode(body);
    var token = Token.fromJson(decodedJson);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  token: token,
                )));
  }
}
