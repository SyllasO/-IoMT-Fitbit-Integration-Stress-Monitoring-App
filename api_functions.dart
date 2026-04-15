import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getHeartRate(String startdate, String enddate) async {
  final url = Uri.parse(
    'https://q47wdkbgf5.execute-api.us-east-1.amazonaws.com/testBackend/HeartRateData',
  );

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "startdate": startdate,
      "enddate": enddate,
    }),
  );

  print('QUERY STATUS = ${response.statusCode}');
  print('QUERY RAW BODY = ${response.body}');

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Fail to get data. ${response.body}');
  }
}

Future<String> saveHeartRate(String collectDate) async {
  final url = Uri.parse(
    'https://q47wdkbgf5.execute-api.us-east-1.amazonaws.com/testBackend/saveHeartRate',
  );

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "collect_date": collectDate,
    }),
  );

  print('SAVE STATUS = ${response.statusCode}');
  print('SAVE RAW BODY = ${response.body}');

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Fail to save Fitbit data. ${response.body}');
  }
}

Future<String> saveStress(
  String checkinDate,
  int stressScore,
  String notes,
) async {
  final url = Uri.parse(
    'https://q47wdkbgf5.execute-api.us-east-1.amazonaws.com/testBackend/saveStress',
  );

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "checkin_date": checkinDate,
      "stress_score": stressScore,
      "notes": notes,
    }),
  );

  print('STRESS STATUS = ${response.statusCode}');
  print('STRESS RAW BODY = ${response.body}');

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Fail to save stress data. ${response.body}');
  }
}