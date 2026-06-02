/// Trip model - represents a booked trip by user
library;

import 'guide_model.dart';
import 'tour_model.dart';

enum TripStatus { upcoming, ongoing, completed, cancelled }

int _intValue(Object? value, {int fallback = 0}) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

bool _boolValue(Object? value) {
  if (value is bool) return value;
  final normalized = value?.toString().toLowerCase();
  return normalized == 'true' || normalized == '1';
}

DateTime _dateValue(Object? value) {
  if (value is DateTime) return value;
  return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
}

class TripModel {
  final String id;
  final TourModel tour;
  final DateTime date;
  final int guests;
  final TripStatus status;
  final String? timeFrom;
  final String? timeTo;
  final bool guideRejected;
  final bool waitingForOffers;
  final int? pendingGuideCount;

  const TripModel({
    required this.id,
    required this.tour,
    required this.date,
    this.guests = 1,
    this.status = TripStatus.upcoming,
    this.timeFrom,
    this.timeTo,
    this.guideRejected = false,
    this.waitingForOffers = false,
    this.pendingGuideCount,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    final tourJson = json['tour'];
    return TripModel(
      id: json['id']?.toString() ?? '',
      tour: tourJson is Map
          ? TourModel.fromJson(Map<String, dynamic>.from(tourJson))
          : TourModel(
              id: json['tour_id']?.toString() ??
                  json['tourId']?.toString() ??
                  '',
              title: json['tour_title']?.toString() ??
                  json['tourTitle']?.toString() ??
                  '',
              description: '',
              guide: const GuideModel(id: '', name: ''),
              price: 0,
              duration: '',
              location: '',
            ),
      date: _dateValue(
          json['date'] ?? json['departure_date'] ?? json['departureDate']),
      guests: _intValue(json['guests'], fallback: 1),
      status: TripStatus.values.firstWhere(
        (e) => e.name == json['status']?.toString(),
        orElse: () => TripStatus.upcoming,
      ),
      timeFrom: (json['time_from'] ?? json['timeFrom'])?.toString(),
      timeTo: (json['time_to'] ?? json['timeTo'])?.toString(),
      guideRejected:
          _boolValue(json['guide_rejected'] ?? json['guideRejected']),
      waitingForOffers:
          _boolValue(json['waiting_for_offers'] ?? json['waitingForOffers']),
      pendingGuideCount: json['pending_guide_count'] == null &&
              json['pendingGuideCount'] == null
          ? null
          : _intValue(json['pending_guide_count'] ?? json['pendingGuideCount']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tour': tour.toJson(),
        'date': date.toIso8601String(),
        'guests': guests,
        'status': status.name,
        'time_from': timeFrom,
        'time_to': timeTo,
        'guide_rejected': guideRejected,
        'waiting_for_offers': waitingForOffers,
        'pending_guide_count': pendingGuideCount,
      };
}
