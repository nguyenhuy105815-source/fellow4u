/// Tour model - represents a tour offered by a guide
library;

import 'guide_model.dart';

double _doubleValue(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _intValue(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

class TourModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final GuideModel guide;
  final double price;
  final String currency;
  final String duration; // e.g. "4 hours", "Full day"
  final double rating;
  final int reviewCount;
  final String location;

  const TourModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.guide,
    required this.price,
    this.currency = 'USD',
    required this.duration,
    this.rating = 0,
    this.reviewCount = 0,
    required this.location,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    final guideJson = json['guide'];
    return TourModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: (json['image_url'] ?? json['imageUrl'])?.toString(),
      guide: guideJson is Map
          ? GuideModel.fromJson(Map<String, dynamic>.from(guideJson))
          : GuideModel(
              id: json['guide_id']?.toString() ??
                  json['guideId']?.toString() ??
                  '',
              name: json['guide_name']?.toString() ??
                  json['guideName']?.toString() ??
                  '',
            ),
      price: _doubleValue(json['price']),
      currency: json['currency']?.toString() ?? 'USD',
      duration: json['duration']?.toString() ?? '',
      rating: _doubleValue(json['rating']),
      reviewCount: _intValue(json['review_count'] ?? json['reviewCount']),
      location: json['location']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'image_url': imageUrl,
        'guide': guide.toJson(),
        'price': price,
        'currency': currency,
        'duration': duration,
        'rating': rating,
        'review_count': reviewCount,
        'location': location,
      };
}
