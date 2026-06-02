/// Tour Provider - manages tours and guides state
library;

import 'package:flutter/foundation.dart';
import '../models/guide_model.dart';
import '../models/tour_model.dart';
import '../services/api_service.dart';

class TourProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<TourModel> _tours = [];
  List<GuideModel> _guides = [];
  bool _isLoading = false;
  String? _error;

  List<TourModel> get tours => List.unmodifiable(_tours);
  List<GuideModel> get guides => List.unmodifiable(_guides);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTours({String? search, String? location}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tours = await _api.getTours(search: search, location: location);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<TourModel?> getTourById(String id) async {
    try {
      return await _api.getTourById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> loadGuides() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _guides = await _api.getGuides();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
