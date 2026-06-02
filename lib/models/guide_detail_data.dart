/// Guide detail - experiences, pricing, reviews
library;

class GuideExperience {
  final String id;
  final String title;
  final List<String> imageUrls;
  final String location;
  final String date;
  final int likes;

  const GuideExperience({
    required this.id,
    required this.title,
    required this.imageUrls,
    required this.location,
    required this.date,
    required this.likes,
  });
}

class GuidePricing {
  final String range;
  final String price;

  const GuidePricing({required this.range, required this.price});
}

class GuideReview {
  final String id;
  final String authorName;
  final String avatarUrl;
  final String date;
  final int rating;
  final String content;

  const GuideReview({
    required this.id,
    required this.authorName,
    required this.avatarUrl,
    required this.date,
    required this.rating,
    required this.content,
  });
}
