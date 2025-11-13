import 'package:cryptopoker/core/network/api_response.dart';
import 'package:cryptopoker/model/login_response_model.dart';
import 'package:cryptopoker/repository/auth_repository.dart';
import 'package:cryptopoker/screen/lobby/lobby_view.dart';
import 'package:cryptopoker/token_storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{
  final AuthRepository _authRepo = AuthRepository();

  // Reactive variables
RxBool isLoading = false.obs;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  Future<void> login(String email, String password) async {
    if (isLoading.value) return; // prevent multiple taps
    isLoading.value = true;

    final body = {"email": email, "password": password};

    try {
      final responseJson = await _authRepo.loginUser(body);
      final loginResponse = LoginResponseModel.fromJson(responseJson);

      if (loginResponse.code == 200 && loginResponse.data != null) {
        final data = loginResponse.data!;
        await TokenStorage.saveTokens(data.token ?? '', data.refreshToken ?? '');
        await TokenStorage.saveUser(data.toJson());
        debugPrint("✅ Login successful for: ${data.username}");

        Get.offAll(()=>LobbyView());
      } else {
        debugPrint("❌ Login failed: ${loginResponse.message}");
      }
    } catch (e) {
      debugPrint("❌ Login exception: $e");
    } finally {
      isLoading.value = false; // stop loader no matter what
    }
  }

  Future<void> sendOtp(String email) async {
    if (isLoading.value) return; // prevent multiple taps
    isLoading.value = true;

    final body = {"email": email};

    try {
      final responseJson = await _authRepo.sendOtp(body);
      //final loginResponse = LoginResponseModel.fromJson(responseJson);

     /* if (loginResponse.code == 200 && loginResponse.data != null) {
        final data = loginResponse.data!;
        await TokenStorage.saveTokens(data.token ?? '', data.refreshToken ?? '');
        await TokenStorage.saveUser(data.toJson());
        debugPrint("✅ Login successful for: ${data.username}");

        Get.offAllNamed('/letsplay');
      } else {
        debugPrint("❌ Login failed: ${loginResponse.message}");
      }*/
    } catch (e) {
      debugPrint("❌ Login exception: $e");
    } finally {
      isLoading.value = false; // stop loader no matter what
    }
  }

}