// ignore_for_file: prefer_const_constructors

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      body: Center(
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
                      label: Text('Iniciar sesión con Facebook'),
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
        'Déjanos los comentarios de como te pareció el curso y califica tu experiencia.',
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
    print('oe');
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
              'Hubo un problema al obtener el usuario de Facebook, por favor intenta más tarde.',
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

    print(request);

    // await _socialLogin(request);
  }
}
