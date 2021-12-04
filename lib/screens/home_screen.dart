// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_final_fields, unused_field

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:william_serna_parcial_final/components/loader_component.dart';
import 'package:william_serna_parcial_final/helpers/constans.dart';
import 'package:william_serna_parcial_final/models/token.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final Token token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showLoader = false;

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  TextEditingController _emailController = TextEditingController();

  int _qualification = 0;
  String _qualificationError = '';
  bool _qualificationShowError = false;
  TextEditingController _qualificationController = TextEditingController();

  String _theBest = '';
  String _theBestError = '';
  bool _theBestShowError = false;
  TextEditingController _theBestController = TextEditingController();

  String _theWorst = '';
  String _theWorstError = '';
  bool _theWorstShowError = false;
  TextEditingController _theWorstController = TextEditingController();

  String _remarks = '';
  String _remarksError = '';
  bool _remarksShowError = false;
  TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFieldValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Encuesta del curso'),
          backgroundColor: Color(0xFF060606),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _showEmail(),
                  _showTheBest(),
                  _showTheWorst(),
                  _showRemarks(),
                  _showButton()
                ],
              ),
            ),
            _showLoader ? LoaderComponent(text: 'Procesando...') : Container(),
          ],
        ));
  }

  Widget _showTheBest() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _theBestController,
        decoration: InputDecoration(
          hintText: 'Ingresa lo que más te gusto del curso...',
          labelText: 'Lo que más te gusto',
          errorText: _theBestShowError ? _theBestError : null,
          suffixIcon: Icon(Icons.mood),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _theBest = value;
        },
      ),
    );
  }

  Widget _showTheWorst() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _theWorstController,
        decoration: InputDecoration(
          hintText: 'Ingresa lo que menos te gusto del curso...',
          labelText: 'Lo que menos te gusto',
          errorText: _theWorstShowError ? _theWorstError : null,
          suffixIcon: Icon(Icons.mood_bad),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _theWorst = value;
        },
      ),
    );
  }

  Widget _showRemarks() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 4,
        maxLines: 4,
        controller: _remarksController,
        decoration: InputDecoration(
          hintText: 'Ingresa comentarios generales para mejorar...',
          labelText: 'Comentarios',
          errorText: _remarksShowError ? _remarksError : null,
          suffixIcon: Icon(Icons.comment),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _remarks = value;
        },
      ),
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa email...',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showButton() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Text('Guardar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Color(0xFF120E43);
                }),
              ),
              onPressed: () => _saveForm(),
            ),
          ),
        ],
      ),
    );
  }

  void _loadFieldValues() async {
    var url = Uri.parse('${Constans.apiUrl}/api/Finals');
    var response = await http.get(url, headers: {
      'content-type': 'application/json',
      'accept': 'application/json'
    });

    print(response);
  }

  void _saveForm() {
    if (!_validateFields()) {
      return;
    }

    print('melo');
  }

  bool _validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email.';
    } else if (!EmailValidator.validate(_email)) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email válido.';
    } else if (!_email.toLowerCase().endsWith('correo.itm.edu.co')) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'El email debe ser uno de dominio ITM';
    } else {
      _emailShowError = false;
    }

    if (_theBest.isEmpty) {
      isValid = false;
      _theBestShowError = true;
      _theBestError = 'Debes ingresar lo que más te gusto del curso.';
    } else {
      _theBestShowError = false;
    }

    if (_theWorst.isEmpty) {
      isValid = false;
      _theWorstShowError = true;
      _theWorstError = 'Debes ingresar lo que menos te gusto del curso.';
    } else {
      _theWorstShowError = false;
    }

    if (_remarks.isEmpty) {
      isValid = false;
      _remarksShowError = true;
      _remarksError = 'Debes ingresar un comentario.';
    } else {
      _remarksShowError = false;
    }

    setState(() {});
    return isValid;
  }
}
