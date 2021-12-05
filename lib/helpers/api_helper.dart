import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:william_serna_parcial_final/helpers/constans.dart';
import 'package:william_serna_parcial_final/models/poll.dart';
import 'package:william_serna_parcial_final/models/response.dart';
import 'package:william_serna_parcial_final/models/token.dart';

class ApiHelper {
  static Future<Response> getPoll(Token token) async {
    if (!_validToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }

    var url = Uri.parse('${Constans.apiUrl}/api/Finals');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);

    return Response(isSuccess: true, result: Poll.fromJson(decodedJson));
  }

  static bool _validToken(Token token) {
    if (DateTime.parse(token.expiration).isAfter(DateTime.now())) {
      return true;
    }

    return false;
  }
}
