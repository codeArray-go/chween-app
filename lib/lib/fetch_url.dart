import 'dart:convert';
import 'package:chween_app/lib/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class FetchUrl {
  static const String baseUrl = "http://192.168.1.27:3000/api";

  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();

    return {"Content-Type": "application/json", if (token != null) "Authorization": "Bearer $token"};
  }

  // GET
  static Future<dynamic> get(String endpoint) async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse("$baseUrl$endpoint"), headers: headers);

    return _handleResponse(response);
  }

  // POST
  static Future<dynamic> post(String endpoint, {required Map<String, dynamic> body}) async {
    final headers = await getHeaders();

    final response = await http.post(Uri.parse("$baseUrl$endpoint"), headers: headers, body: jsonEncode(body));

    return _handleResponse(response);
  }

  // PUT
  static Future<dynamic> put(String endpoint, dynamic data) async {
    final headers = await getHeaders();
    final response = await http.put(Uri.parse("$baseUrl$endpoint"), headers: headers, body: jsonEncode(data));
    return _handleResponse(response);
  }

  // DELETE
  static Future<dynamic> delete(String endpoint) async {
    final headers = await getHeaders();
    final response = await http.delete(Uri.parse("$baseUrl$endpoint"), headers: headers);
    return _handleResponse(response);
  }

  // Common response handler (like interceptor)
  static dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['message'] ?? data['error'] ?? 'Something went wrong');
    }
  }
}
