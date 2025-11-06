import 'dart:convert';
import 'package:cryptopoker/token_storage/token_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_exception.dart';


class ApiClient {
  final http.Client _client = http.Client();

  Future<Map<String, String>> _baseHeaders({bool includeAuth = true}) async {
    final token = includeAuth ? await autorizationToken() : null;

    final headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }


  /// POST request
  Future<dynamic> post(
      String url,
      Map<String, dynamic> body, {
        Map<String, String>? extraHeaders,
        bool includeAuth = true, // 👈 new param
      }) async {
    try {
      final headers = await _baseHeaders(includeAuth: includeAuth);
      final bodyJson = jsonEncode(body);

      if (kDebugMode) {
        debugPrint("POST Request: $url");
        debugPrint("Headers: $headers");
        debugPrint("Body: $bodyJson");
      }

      final response = await _client.post(
        Uri.parse(url),
        headers: headers,
        body: bodyJson,
      );

      if (kDebugMode) {
        if (kDebugMode) {
          debugPrint("✅ Response from: $url");
          debugPrint("Status Code: ${response.statusCode}");
          debugPrint("Response Body: ${response.body}");
        }
      }

      return await _processResponse(response);
    } catch (e) {
      debugPrint("❌ Network Error: $e");
      throw FetchDataException('Network error: $e');
    }
  }


  Future<String?> autorizationToken() async {
    final token = TokenStorage.getToken();
    return token;
  }

  /// Processes HTTP responses
  Future<dynamic> _processResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
      case 201:
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          return Map<String, dynamic>.from(decoded);
        }
      case 400:
        throw BadRequestException(response.body);
      case 401:
        throw UnauthorisedException(response.body);
      default:
        throw FetchDataException('Error: ${response.statusCode}');
    }
  }

  /// Dispose the client when done
  void dispose() {
    _client.close();
  }
}