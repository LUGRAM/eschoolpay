import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/info_site.dart';

class InfoSiteService {
  static const String baseUrl = "https://admin.itmaster-africa.com/api";

  static Future<InfoSite?> fetchInfoSite() async {
    final response = await http.get(
      Uri.parse("$baseUrl/info-site"),
      headers: {
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return InfoSite.fromJson(data['data']);
    }
    return null;
  }
}
