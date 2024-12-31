import 'dart:convert';

import 'package:http/http.dart' as http;

class WorldTimeService {
  static const String _baseUrl =
      'https://drmosalah.safehandapps.com/api/v1/time';

  Future<DateTime> getCurrentDateTime() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final DateTime dateTime = DateTime.parse(data['currentDateTime']);
      final DateTime cairoTime = dateTime.toUtc();
      return cairoTime;
    } else {
      throw Exception('Failed to load time data');
    }
  }
}
