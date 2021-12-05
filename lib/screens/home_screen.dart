// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_final_fields, unused_field

import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:william_serna_parcial_final/components/loader_component.dart';
import 'package:william_serna_parcial_final/helpers/api_helper.dart';
import 'package:william_serna_parcial_final/helpers/constans.dart';
import 'package:william_serna_parcial_final/models/response.dart';
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
        body: Center(
          child: RefreshIndicator(
            onRefresh: _loadFieldValues,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      _showEmail(),
                      SizedBox(
                        height: 10,
                      ),
                      _showLabelQualification(),
                      SizedBox(
                        height: 5,
                      ),
                      _showQualification(),
                      SizedBox(
                        height: 10,
                      ),
                      _showTheBest(),
                      _showTheWorst(),
                      _showRemarks(),
                      _showButton()
                    ],
                  ),
                ),
                _showLoader
                    ? LoaderComponent(text: 'Procesando...')
                    : Container(),
              ],
            ),
          ),
        ));
  }

  Widget _showLabelQualification() {
    return Text('Califica de 1 a 5 como te pareció el curso');
  }

  Widget _showQualification() {
    return Container(
      child: Column(
        children: [
          RatingBar.builder(
            initialRating: _qualification.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _qualification = rating.toInt();
            },
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            _qualificationShowError ? _qualificationError : '',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Color(0xFFFF0000)),
          ),
        ],
      ),
    );
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
                padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                    (Set<MaterialState> states) {
                  return EdgeInsets.all(13);
                }),
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

  Future<Null> _loadFieldValues() async {
    setState(() {
      _showLoader = true;
    });

    Response response = await ApiHelper.getPoll(widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    if (response.result.qualification > 0) {
      _email = response.result.email;
      _emailController.text = _email;

      _theBest = response.result.theBest;
      _theBestController.text = _theBest;

      _theWorst = response.result.theWorst;
      _theWorstController.text = _theWorst;

      _remarks = response.result.remarks;
      _remarksController.text = _remarks;

      _qualification = response.result.qualification;
    }
  }

  Future<Null> _saveForm() async {
    if (!_validateFields()) {
      return;
    }

    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'email': _email,
      'qualification': _qualification,
      'theBest': _theBest,
      'theWorst': _theWorst,
      'remarks': _remarks,
    };

    Response response =
        await ApiHelper.post('/api/Finals', request, widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    await showAlertDialog(
        context: context,
        title: '¡Enviado!',
        message: 'Los datos de la encuesta se han almacenado con éxito.',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar'),
        ]);
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

    if (_qualification <= 0) {
      isValid = false;
      _qualificationShowError = true;
      _qualificationError = 'Debes ingresar una calificación.';
    } else {
      _qualificationShowError = false;
    }

    setState(() {});
    return isValid;
  }
}
