/// Chat Provider - manages chat messages with guides
library;

import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  final Map<String, List<MessageModel>> _messagesByGuide = {};
  bool _isLoading = false;
  String? _error;

  List<MessageModel> getMessages(String guideId) =>
      _messagesByGuide[guideId] ?? [];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMessages(String guideId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final messages = await _api.getMessages(guideId);
      _messagesByGuide[guideId] = messages;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(String guideId, String content) async {
    _error = null;
    notifyListeners();
    try {
      final msg = await _api.sendMessage(guideId, content);
      _messagesByGuide[guideId] = [...getMessages(guideId), msg];
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
