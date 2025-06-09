import 'dart:convert';
import 'package:http/http.dart' as http;

const String BASE_URL = 'http://localhost:3000'; // Ganti dengan IP jika perlu
const String LOGIN_ENDPOINT = '/auth/login'; // Endpoint login sesuai backend

class HttpService {
  final String baseUrl = BASE_URL;

  Future<http.Response> postRequest({
    required String endpoint,
    required Map<String, String> headers,
    required dynamic body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl$LOGIN_ENDPOINT');
    final headers = {'Content-Type': 'application/json'};
    final body = {'email': email, 'password': password}; // Pastikan key 'email'

    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
