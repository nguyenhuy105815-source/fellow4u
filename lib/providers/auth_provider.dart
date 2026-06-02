/// Auth Provider - manages authentication state (MVVM ViewModel)
library;

import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    ApiService().onUnauthorized = _handleUnauthorized;
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        _user = user;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = _messageFromError(e);
      _status = AuthStatus.error;
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signIn(email, password);
      _user = user;
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _messageFromError(e);
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(
    String email,
    String password,
    String displayName,
    String userType,
  ) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user =
          await _authService.signUp(email, password, displayName, userType);
      _user = user;
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _messageFromError(e);
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> updateUser(UserModel updated) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.updateProfile(updated);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _messageFromError(e);
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status =
          _user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    }
    notifyListeners();
  }

  Future<void> _handleUnauthorized() async {
    await _authService.clearSession();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = 'Session expired. Please sign in again.';
    notifyListeners();
  }

  String _messageFromError(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }
}
