import 'dart:convert';
import 'dart:io';

final _usersByToken = <String, Map<String, dynamic>>{};
final _trips = <Map<String, dynamic>>[];
final _wishlistTourIds = <String>{'tour-2'};
final _settings = <String, dynamic>{
  'language': 'vi',
  'notificationsEnabled': true,
};
final _messagesByGuide = <String, List<Map<String, dynamic>>>{};

final _guides = [
  {
    'id': 'guide-1',
    'name': 'Tuan Tran',
    'avatar_url': 'lib/images/14.jpg',
    'rating': 5,
    'review_count': 107,
    'languages': ['Tieng Viet', 'English'],
    'bio': 'Huong dan vien tai Da Nang',
    'location': 'Da Nang, Viet Nam',
  },
  {
    'id': 'guide-2',
    'name': 'Emmy',
    'avatar_url': 'lib/images/15.jpg',
    'rating': 4.9,
    'review_count': 98,
    'languages': ['Tieng Viet', 'English'],
    'bio': 'Huong dan vien tai Ha Noi',
    'location': 'Ha Noi, Viet Nam',
  },
  {
    'id': 'guide-3',
    'name': 'Linh Hana',
    'avatar_url': 'lib/images/16.jpg',
    'rating': 4.8,
    'review_count': 88,
    'languages': ['Tieng Viet'],
    'bio': 'Huong dan vien tai Da Nang',
    'location': 'Da Nang, Viet Nam',
  },
  {
    'id': 'guide-4',
    'name': 'Khai Ho',
    'avatar_url': 'lib/images/17.jpg',
    'rating': 4.7,
    'review_count': 76,
    'languages': ['Tieng Viet', 'English'],
    'bio': 'Huong dan vien tai TP.HCM',
    'location': 'TP.HCM, Viet Nam',
  },
];

final _tours = [
  {
    'id': 'tour-1',
    'title': 'Da Nang - Ba Na - Hoi An',
    'description': 'Kham pha Da Nang, Ba Na Hills va pho co Hoi An.',
    'image_url': 'lib/images/3.jpg',
    'guide': _guides[0],
    'price': 400,
    'currency': 'USD',
    'duration': '3 ngay',
    'rating': 5,
    'review_count': 1247,
    'location': 'Da Nang, Viet Nam',
  },
  {
    'id': 'tour-2',
    'title': 'Melbourne - Sydney',
    'description': 'Hanh trinh kham pha hai thanh pho noi tieng nuoc Uc.',
    'image_url': 'lib/images/6.jpg',
    'guide': _guides[1],
    'price': 600,
    'currency': 'USD',
    'duration': '3 ngay',
    'rating': 4.9,
    'review_count': 932,
    'location': 'Australia',
  },
  {
    'id': 'tour-3',
    'title': 'Ha Noi - Vinh Ha Long',
    'description': 'Kham pha Ha Noi va vinh Ha Long di san the gioi.',
    'image_url': 'lib/images/7.jpg',
    'guide': _guides[2],
    'price': 300,
    'currency': 'USD',
    'duration': '3 ngay',
    'rating': 4.8,
    'review_count': 840,
    'location': 'Ha Noi, Viet Nam',
  },
];

Future<void> main(List<String> args) async {
  final port = _readPort(args);
  _seedTrips();
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  stdout.writeln('Dev API server listening at http://127.0.0.1:$port/v1');

  await for (final request in server) {
    await _handle(request);
  }
}

int _readPort(List<String> args) {
  final index = args.indexOf('--port');
  if (index >= 0 && index + 1 < args.length) {
    return int.tryParse(args[index + 1]) ?? 55124;
  }
  return 55124;
}

Future<void> _handle(HttpRequest request) async {
  _addCors(request.response);
  if (request.method == 'OPTIONS') {
    request.response.statusCode = HttpStatus.noContent;
    await request.response.close();
    return;
  }

  try {
    final path = request.uri.path;
    if (!path.startsWith('/v1')) {
      return _json(request, HttpStatus.notFound, {'message': 'Not found'});
    }

    final route = path.substring(3).isEmpty ? '/' : path.substring(3);
    final body = await _readJson(request);

    if (request.method == 'POST' && route == '/auth/signup') {
      final user = {
        'id': 'user-${DateTime.now().millisecondsSinceEpoch}',
        'email': body['email']?.toString() ?? '',
        'display_name': body['displayName']?.toString() ?? '',
        'first_name': _firstName(body['displayName']?.toString() ?? ''),
        'last_name': _lastName(body['displayName']?.toString() ?? ''),
        'avatar_url': 'lib/images/29.jpg',
      };
      final token = 'dev-token-${user['id']}';
      _usersByToken[token] = user;
      return _json(request, HttpStatus.ok, {'token': token, 'user': user});
    }

    if (request.method == 'POST' && route == '/auth/signin') {
      final email = body['email']?.toString() ?? 'demo@fellow4u.local';
      final user = {
        'id': 'user-1',
        'email': email,
        'display_name': 'Demo User',
        'first_name': 'Demo',
        'last_name': 'User',
        'avatar_url': 'lib/images/29.jpg',
      };
      const token = 'dev-token-user-1';
      _usersByToken[token] = user;
      return _json(request, HttpStatus.ok, {'token': token, 'user': user});
    }

    if (route == '/auth/me') {
      return _json(request, HttpStatus.ok, {'user': _currentUser(request)});
    }

    if (route == '/users/me' && request.method == 'PUT') {
      final user = _currentUser(request);
      user.addAll(body);
      return _json(request, HttpStatus.ok, {'user': user});
    }

    if (route == '/tours' && request.method == 'GET') {
      return _json(request, HttpStatus.ok, {'tours': _filterTours(request)});
    }

    final tourMatch = RegExp(r'^/tours/([^/]+)$').firstMatch(route);
    if (tourMatch != null && request.method == 'GET') {
      final id = Uri.decodeComponent(tourMatch.group(1)!);
      final tour = _tours.firstWhere(
        (item) => item['id'] == id,
        orElse: () => {},
      );
      if (tour.isEmpty) {
        return _json(
            request, HttpStatus.notFound, {'message': 'Tour not found'});
      }
      return _json(request, HttpStatus.ok, {'tour': tour});
    }

    if (route == '/guides' && request.method == 'GET') {
      return _json(request, HttpStatus.ok, {'guides': _guides});
    }

    final guideMatch = RegExp(r'^/guides/([^/]+)$').firstMatch(route);
    if (guideMatch != null && request.method == 'GET') {
      final id = Uri.decodeComponent(guideMatch.group(1)!);
      final guide = _guides.firstWhere(
        (item) => item['id'] == id,
        orElse: () => {},
      );
      if (guide.isEmpty) {
        return _json(
          request,
          HttpStatus.notFound,
          {'message': 'Guide not found'},
        );
      }
      return _json(request, HttpStatus.ok, {'guide': guide});
    }

    if (route == '/users/me/trips' && request.method == 'GET') {
      final status = request.uri.queryParameters['status'];
      final trips = status == null
          ? _trips
          : _trips.where((trip) => trip['group'] == status).toList();
      return _json(request, HttpStatus.ok, {'trips': trips});
    }

    if (route == '/bookings' && request.method == 'POST') {
      final tourId = body['tourId']?.toString() ?? '';
      final tour = _tours.firstWhere(
        (item) => item['id'] == tourId,
        orElse: () => _tours.first,
      );
      final adults =
          body['adults'] is num ? (body['adults'] as num).toInt() : 1;
      final children =
          body['children'] is num ? (body['children'] as num).toInt() : 0;
      final trip = {
        'id': 'trip-${DateTime.now().millisecondsSinceEpoch}',
        'tour': tour,
        'date': body['date']?.toString() ?? DateTime.now().toIso8601String(),
        'guests': adults + children,
        'status': 'upcoming',
        'group': 'next',
        'time_from': '08:00',
        'time_to': '17:00',
      };
      _trips.insert(0, trip);
      return _json(request, HttpStatus.ok, {'trip': trip});
    }

    final tripStatusMatch =
        RegExp(r'^/trips/([^/]+)/status$').firstMatch(route);
    if (tripStatusMatch != null && request.method == 'PATCH') {
      final id = Uri.decodeComponent(tripStatusMatch.group(1)!);
      final trip =
          _trips.firstWhere((item) => item['id'] == id, orElse: () => {});
      if (trip.isEmpty) {
        return _json(
            request, HttpStatus.notFound, {'message': 'Trip not found'});
      }
      trip['status'] = body['status']?.toString() ?? trip['status'];
      trip['group'] = trip['status'] == 'completed' ? 'past' : trip['group'];
      return _json(request, HttpStatus.ok, {'trip': trip});
    }

    if (route == '/users/me/wishlist' && request.method == 'GET') {
      final tours = _tours
          .where((tour) => _wishlistTourIds.contains(tour['id']))
          .toList();
      return _json(request, HttpStatus.ok, {'tours': tours});
    }

    final wishlistMatch =
        RegExp(r'^/users/me/wishlist/([^/]+)$').firstMatch(route);
    if (wishlistMatch != null) {
      final tourId = Uri.decodeComponent(wishlistMatch.group(1)!);
      if (request.method == 'POST') _wishlistTourIds.add(tourId);
      if (request.method == 'DELETE') _wishlistTourIds.remove(tourId);
      return _json(request, HttpStatus.ok, {'ok': true});
    }

    final messagesMatch =
        RegExp(r'^/guides/([^/]+)/messages$').firstMatch(route);
    if (messagesMatch != null) {
      final guideId = Uri.decodeComponent(messagesMatch.group(1)!);
      final messages = _messagesByGuide.putIfAbsent(
        guideId,
        () => [
          {
            'id': 'm1',
            'content': 'Chao ban, minh co the ho tro gi cho chuyen di?',
            'sender': 'guide',
            'timestamp': DateTime.now().toIso8601String(),
          },
        ],
      );
      if (request.method == 'GET') {
        return _json(request, HttpStatus.ok, {'messages': messages});
      }
      if (request.method == 'POST') {
        final message = {
          'id': 'msg-${DateTime.now().millisecondsSinceEpoch}',
          'content': body['content']?.toString() ?? '',
          'sender': 'user',
          'timestamp': DateTime.now().toIso8601String(),
        };
        messages.add(message);
        return _json(request, HttpStatus.ok, {'message': message});
      }
    }

    if (route == '/feedback' && request.method == 'POST') {
      return _json(request, HttpStatus.ok, {'ok': true});
    }

    if (route == '/users/me/settings') {
      if (request.method == 'PUT') _settings.addAll(body);
      return _json(request, HttpStatus.ok, {'settings': _settings});
    }

    return _json(request, HttpStatus.notFound, {'message': 'Not found'});
  } catch (error) {
    return _json(
      request,
      error is StateError
          ? HttpStatus.unauthorized
          : HttpStatus.internalServerError,
      {'message': error.toString()},
    );
  }
}

List<Map<String, dynamic>> _filterTours(HttpRequest request) {
  final search = request.uri.queryParameters['search']?.toLowerCase();
  final location = request.uri.queryParameters['location']?.toLowerCase();
  return _tours.where((tour) {
    final text = '${tour['title']} ${tour['description']} ${tour['location']}'
        .toLowerCase();
    return (search == null || text.contains(search)) &&
        (location == null || text.contains(location));
  }).toList();
}

Map<String, dynamic> _currentUser(HttpRequest request) {
  final header = request.headers.value(HttpHeaders.authorizationHeader);
  final token = header?.replaceFirst('Bearer ', '');
  final user = _usersByToken[token];
  if (user == null) throw StateError('Unauthorized');
  return user;
}

void _seedTrips() {
  if (_trips.isNotEmpty) return;
  _trips.addAll([
    {
      'id': 'trip-current-1',
      'tour': _tours[0],
      'date': DateTime.now().toIso8601String(),
      'guests': 2,
      'status': 'ongoing',
      'group': 'current',
      'time_from': '13:00',
      'time_to': '15:00',
    },
    {
      'id': 'trip-next-1',
      'tour': _tours[2],
      'date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      'guests': 1,
      'status': 'upcoming',
      'group': 'next',
      'time_from': '09:00',
      'time_to': '11:00',
    },
    {
      'id': 'trip-past-1',
      'tour': _tours[1],
      'date':
          DateTime.now().subtract(const Duration(days: 14)).toIso8601String(),
      'guests': 1,
      'status': 'completed',
      'group': 'past',
    },
  ]);
}

Future<Map<String, dynamic>> _readJson(HttpRequest request) async {
  if (request.method == 'GET' || request.method == 'DELETE') return {};
  final raw = await utf8.decoder.bind(request).join();
  if (raw.trim().isEmpty) return {};
  final decoded = jsonDecode(raw);
  if (decoded is Map<String, dynamic>) return decoded;
  if (decoded is Map) return Map<String, dynamic>.from(decoded);
  return {};
}

Future<void> _json(
  HttpRequest request,
  int statusCode,
  Map<String, dynamic> body,
) async {
  request.response
    ..statusCode = statusCode
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(body));
  await request.response.close();
}

void _addCors(HttpResponse response) {
  response.headers
    ..set('Access-Control-Allow-Origin', '*')
    ..set('Access-Control-Allow-Methods', 'GET,POST,PUT,PATCH,DELETE,OPTIONS')
    ..set('Access-Control-Allow-Headers', 'Content-Type,Authorization');
}

String _firstName(String displayName) {
  final parts = displayName.trim().split(RegExp(r'\s+'));
  return parts.isEmpty ? '' : parts.first;
}

String _lastName(String displayName) {
  final parts = displayName.trim().split(RegExp(r'\s+'));
  return parts.length <= 1 ? '' : parts.skip(1).join(' ');
}
