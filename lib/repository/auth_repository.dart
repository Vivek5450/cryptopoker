

import 'package:cryptopoker/core/constants/app_url.dart';
import 'package:cryptopoker/core/network/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> loginUser(Map<String, dynamic> body) async {
    final response = await _apiClient.post(AppUrls.login, body,includeAuth: false);
    return response;
  }
}