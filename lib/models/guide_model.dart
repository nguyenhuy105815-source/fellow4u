/// Guide model - represents local guide offering tours
library;

double _doubleValue(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _intValue(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

class GuideModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final double rating;
  final int reviewCount;
  final List<String> languages;
  final String? bio;
  final String? location;

  const GuideModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.rating = 0,
    this.reviewCount = 0,
    this.languages = const [],
    this.bio,
    this.location,
  });

  factory GuideModel.fromJson(Map<String, dynamic> json) {
    return GuideModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ??
          json['display_name']?.toString() ??
          json['displayName']?.toString() ??
          '',
      avatarUrl: (json['avatar_url'] ?? json['avatarUrl'])?.toString(),
      rating: _doubleValue(json['rating']),
      reviewCount: _intValue(json['review_count'] ?? json['reviewCount']),
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      bio: json['bio']?.toString(),
      location: json['location']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar_url': avatarUrl,
        'rating': rating,
        'review_count': reviewCount,
        'languages': languages,
        'bio': bio,
        'location': location,
      };
}
