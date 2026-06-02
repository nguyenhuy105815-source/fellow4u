/// API Service - handles REST API communication.
library;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/guide_model.dart';
import '../models/message_model.dart';
import '../models/tour_model.dart';
import '../models/trip_model.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? details;

  const ApiException({
    required this.message,
    this.statusCode,
    this.details,
  });

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => message;
}

class AuthSession {
  final String token;
  final UserModel user;

  const AuthSession({
    required this.token,
    required this.user,
  });
}

class ApiService {
  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;

  ApiService._();

  final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 20);

  String _authToken = '';
  Future<void> Function()? onUnauthorized;

  void setAuthToken(String token) => _authToken = token;
  void clearAuthToken() => _authToken = '';

  Map<String, String> _headers({bool authenticated = true}) => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (authenticated && _authToken.isNotEmpty)
          'Authorization': 'Bearer $_authToken',
      };

  // ========== Auth ==========
  Future<AuthSession> signIn(String email, String password) async {
    final data = await _post(
      '/auth/signin',
      body: {
        'email': email,
        'password': password,
      },
      authenticated: false,
    );
    return _parseAuthSession(data);
  }

  Future<AuthSession> signUp({
    required String email,
    required String password,
    required String displayName,
    String userType = 'traveler',
  }) async {
    final data = await _post(
      '/auth/signup',
      body: {
        'email': email,
        'password': password,
        'displayName': displayName,
        'userType': userType,
      },
      authenticated: false,
    );
    return _parseAuthSession(data);
  }

  Future<UserModel> getCurrentUser() async {
    final data = await _get('/auth/me');
    final map = _asMap(data);
    return UserModel.fromJson(_asMap(map['user'] ?? map));
  }

  Future<UserModel> updateProfile(UserModel user) async {
    final data = await _put('/users/me', body: user.toJson());
    final map = _asMap(data);
    return UserModel.fromJson(_asMap(map['user'] ?? map));
  }

  // ========== Tours ==========
  Future<List<TourModel>> getTours({String? search, String? location}) async {
    final data = await _get(
      '/tours',
      queryParameters: {
        'search': search,
        'location': location,
      },
    );
    return _listFromData(data, 'tours')
        .map((item) => TourModel.fromJson(_asMap(item)))
        .toList();
  }

  Future<TourModel> getTourById(String id) async {
    final data = await _get('/tours/${Uri.encodeComponent(id)}');
    final map = _asMap(data);
    return TourModel.fromJson(_asMap(map['tour'] ?? map));
  }

  // ========== Guides ==========
  Future<List<GuideModel>> getGuides({
    String? search,
    String? location,
    String? language,
  }) async {
    final data = await _get(
      '/guides',
      queryParameters: {
        'search': search,
        'location': location,
        'language': language,
      },
    );
    return _listFromData(data, 'guides')
        .map((item) => GuideModel.fromJson(_asMap(item)))
        .toList();
  }

  Future<GuideModel> getGuideById(String id) async {
    final data = await _get('/guides/${Uri.encodeComponent(id)}');
    final map = _asMap(data);
    return GuideModel.fromJson(_asMap(map['guide'] ?? map));
  }

  // ========== Trips ==========
  Future<List<TripModel>> getMyTrips(String userId) async {
    final data = await _get('/users/me/trips');
    return _listFromData(data, 'trips')
        .map((item) => TripModel.fromJson(_asMap(item)))
        .toList();
  }

  Future<List<TripModel>> getCurrentTrips(String userId) =>
      _getTripsByStatus('current');

  Future<List<TripModel>> getNextTrips(String userId) =>
      _getTripsByStatus('next');

  Future<List<TripModel>> getPastTrips(String userId) =>
      _getTripsByStatus('past');

  Future<List<TripModel>> _getTripsByStatus(String status) async {
    final data = await _get(
      '/users/me/trips',
      queryParameters: {'status': status},
    );
    return _listFromData(data, 'trips')
        .map((item) => TripModel.fromJson(_asMap(item)))
        .toList();
  }

  Future<TripModel> bookTour({
    required TourModel tour,
    required DateTime date,
    required int adults,
    int children = 0,
  }) async {
    final data = await _post(
      '/bookings',
      body: {
        'tourId': tour.id,
        'date': date.toIso8601String(),
        'adults': adults,
        'children': children,
      },
    );
    final map = _asMap(data);
    return TripModel.fromJson(_asMap(map['trip'] ?? map));
  }

  Future<TripModel> updateTripStatus(String tripId, TripStatus status) async {
    final data = await _patch(
      '/trips/${Uri.encodeComponent(tripId)}/status',
      body: {'status': status.name},
    );
    final map = _asMap(data);
    return TripModel.fromJson(_asMap(map['trip'] ?? map));
  }

  // ========== Wishlist ==========
  Future<List<TourModel>> getWishlistTours(String userId) async {
    final data = await _get('/users/me/wishlist');
    return _listFromData(data, 'tours')
        .map((item) => TourModel.fromJson(_asMap(item)))
        .toList();
  }

  Future<void> addWishlistTour(String tourId) async {
    await _post('/users/me/wishlist/${Uri.encodeComponent(tourId)}');
  }

  Future<void> removeWishlistTour(String tourId) async {
    await _delete('/users/me/wishlist/${Uri.encodeComponent(tourId)}');
  }

  // ========== Chat ==========
  Future<List<MessageModel>> getMessages(String guideId) async {
    final data = await _get('/guides/${Uri.encodeComponent(guideId)}/messages');
    return _listFromData(data, 'messages')
        .map((item) => MessageModel.fromJson(_asMap(item)))
        .toList();
  }

  Future<MessageModel> sendMessage(String guideId, String content) async {
    final data = await _post(
      '/guides/${Uri.encodeComponent(guideId)}/messages',
      body: {'content': content},
    );
    final map = _asMap(data);
    final message = map['message'];
    return MessageModel.fromJson(_asMap(message is Map ? message : map));
  }

  // ========== Feedback & Settings ==========
  Future<void> sendFeedback({
    required String subject,
    required String message,
  }) async {
    await _post(
      '/feedback',
      body: {
        'subject': subject,
        'message': message,
      },
    );
  }

  Future<Map<String, dynamic>> getSettings() async {
    final data = await _get('/users/me/settings');
    final map = _asMap(data);
    return _asMap(map['settings'] ?? map);
  }

  Future<Map<String, dynamic>> updateSettings({
    String? language,
    bool? notificationsEnabled,
  }) async {
    final body = <String, dynamic>{
      if (language != null) 'language': language,
      if (notificationsEnabled != null)
        'notificationsEnabled': notificationsEnabled,
    };
    final data = await _put('/users/me/settings', body: body);
    final map = _asMap(data);
    return _asMap(map['settings'] ?? map);
  }

  Future<Object?> _get(
    String path, {
    Map<String, String?>? queryParameters,
    bool authenticated = true,
  }) =>
      _request(
        'GET',
        path,
        queryParameters: queryParameters,
        authenticated: authenticated,
      );

  Future<Object?> _post(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) =>
      _request(
        'POST',
        path,
        body: body,
        authenticated: authenticated,
      );

  Future<Object?> _put(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) =>
      _request(
        'PUT',
        path,
        body: body,
        authenticated: authenticated,
      );

  Future<Object?> _patch(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) =>
      _request(
        'PATCH',
        path,
        body: body,
        authenticated: authenticated,
      );

  Future<Object?> _delete(
    String path, {
    bool authenticated = true,
  }) =>
      _request(
        'DELETE',
        path,
        authenticated: authenticated,
      );

  Future<Object?> _request(
    String method,
    String path, {
    Map<String, String?>? queryParameters,
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    final uri = _uri(path, queryParameters);
    final encodedBody = body == null ? null : jsonEncode(body);

    try {
      final response = await _send(
        method,
        uri,
        headers: _headers(authenticated: authenticated),
        body: encodedBody,
      ).timeout(_timeout);

      return _decodeResponse(response, authenticated: authenticated);
    } on TimeoutException {
      throw const ApiException(message: 'Request timed out. Please try again.');
    } on http.ClientException catch (e) {
      throw ApiException(message: e.message);
    } on FormatException catch (e) {
      throw ApiException(message: 'Invalid server response.', details: e);
    }
  }

  Future<http.Response> _send(
    String method,
    Uri uri, {
    required Map<String, String> headers,
    String? body,
  }) {
    switch (method) {
      case 'GET':
        return _client.get(uri, headers: headers);
      case 'POST':
        return _client.post(uri, headers: headers, body: body);
      case 'PUT':
        return _client.put(uri, headers: headers, body: body);
      case 'PATCH':
        return _client.patch(uri, headers: headers, body: body);
      case 'DELETE':
        return _client.delete(uri, headers: headers);
      default:
        throw ApiException(message: 'Unsupported HTTP method: $method');
    }
  }

  Future<Object?> _decodeResponse(
    http.Response response, {
    required bool authenticated,
  }) async {
    final statusCode = response.statusCode;
    final body = response.body.trim();
    final Object? decoded = body.isEmpty ? null : jsonDecode(body);

    if (statusCode >= 200 && statusCode < 300) {
      return _unwrapData(decoded);
    }

    if (statusCode == 401 && authenticated) {
      await onUnauthorized?.call();
    }

    throw ApiException(
      message: _errorMessage(decoded, statusCode),
      statusCode: statusCode,
      details: decoded,
    );
  }

  Uri _uri(String path, Map<String, String?>? queryParameters) {
    final base = apiBaseUrl.endsWith('/')
        ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
        : apiBaseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final query = <String, String>{};

    queryParameters?.forEach((key, value) {
      if (value != null && value.trim().isNotEmpty) {
        query[key] = value.trim();
      }
    });

    return Uri.parse('$base$normalizedPath').replace(
      queryParameters: query.isEmpty ? null : query,
    );
  }

  AuthSession _parseAuthSession(Object? data) {
    final map = _asMap(data);
    final token = (map['token'] ??
            map['accessToken'] ??
            map['access_token'] ??
            map['jwt'])
        ?.toString();
    final userData = map['user'] ?? map['account'] ?? map['profile'];

    if (token == null || token.isEmpty) {
      throw const ApiException(message: 'Authentication token missing.');
    }
    if (userData == null) {
      throw const ApiException(message: 'Authenticated user missing.');
    }

    return AuthSession(
      token: token,
      user: UserModel.fromJson(_asMap(userData)),
    );
  }

  Object? _unwrapData(Object? decoded) {
    if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      return decoded['data'];
    }
    return decoded;
  }

  List<Object?> _listFromData(Object? data, String key) {
    if (data is List) return data.cast<Object?>();
    final map = _asMap(data);
    final value = map[key] ??
        map['items'] ??
        map['results'] ??
        map['wishlist'] ??
        map['data'];
    if (value is List) return value.cast<Object?>();
    throw ApiException(message: 'Expected a list for "$key".');
  }

  Map<String, dynamic> _asMap(Object? data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const ApiException(message: 'Expected an object from server.');
  }

  String _errorMessage(Object? decoded, int statusCode) {
    if (decoded is Map) {
      final message = decoded['message'] ?? decoded['error'];
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
      final errors = decoded['errors'];
      if (errors != null && errors.toString().trim().isNotEmpty) {
        return errors.toString();
      }
    }
    return 'API request failed with status $statusCode.';
  }
}
