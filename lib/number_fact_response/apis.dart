import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wheelbase/number_fact_response/number_fact_response.dart';

Future<NumberFactResponse> getnumbers({required int number}) async {
  final _response = await http.get(
    Uri.parse("http://numbersapi.com/$number?json"),
  );
  final _bodyAsJson = jsonDecode(_response.body) as Map<String, dynamic>;
  // print(_bodyAsJson);
  final _details = NumberFactResponse.fromJson(_bodyAsJson);
  return _details;
}
