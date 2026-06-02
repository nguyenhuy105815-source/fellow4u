/// Auth Service - handles authentication logic
/// Wraps API service and local storage for auth state
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();
  static const _keyToken = 'auth_token';
  static const _keyUser = 'auth_user';

  Future<UserModel?> signIn(String email, String password) async {
    final session = await _api.signIn(email, password);
    await _saveSession(session.token, session.user);
    return session.user;
  }

  Future<UserModel?> signUp(
    String email,
    String password,
    String displayName,
    String userType,
  ) async {
    final session = await _api.signUp(
      email: email,
      password: password,
      displayName: displayName,
      userType: userType,
    );
    await _saveSession(session.token, session.user);
    return session.user;
  }

  Future<void> signOut() async {
    await clearSession();
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
    _api.clearAuthToken();
  }

  Future<UserModel> updateProfile(UserModel user) async {
    final updated = await _api.updateProfile(user);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(updated.toJson()));
    return updated;
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    if (token == null || token.isEmpty) return null;

    _api.setAuthToken(token);
    try {
      final user = await _api.getCurrentUser();
      await prefs.setString(_keyUser, jsonEncode(user.toJson()));
      return user;
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        await clearSession();
        return null;
      }
      rethrow;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> _saveSession(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
    _api.setAuthToken(token);
  }
}
