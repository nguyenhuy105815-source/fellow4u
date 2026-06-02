/// Static Explore-only presentation data.
/// Link ảnh lấy từ AppImageUrls (app_constants.dart)
library;

import '../../utils/app_constants.dart';

/// Journey - Top Journeys horizontal list
class JourneyItem {
  final String id;
  final String title;
  final String? imageUrl;
  final double rating;
  final String date;
  final String duration;
  final double price;
  final String location;

  const JourneyItem({
    required this.id,
    required this.title,
    this.imageUrl,
    this.rating = 5,
    required this.date,
    required this.duration,
    required this.price,
    required this.location,
  });
}

/// Explore guide - Best Guides grid
class ExploreGuide {
  final String id;
  final String name;
  final String? imageUrl;
  final String location;
  final double rating;
  final bool isTopGuide;

  const ExploreGuide({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.location,
    this.rating = 5,
    this.isTopGuide = false,
  });
}

/// Experience - Top Experiences horizontal list
class ExperienceItem {
  final String id;
  final String title;
  final String? imageUrl;
  final String guideName;
  final String? guideAvatarUrl;
  final String location;

  const ExperienceItem({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.guideName,
    this.guideAvatarUrl,
    required this.location,
  });
}

/// Featured tour - vertical list
class FeaturedTourItem {
  final String id;
  final String title;
  final String? imageUrl;
  final double rating;
  final String date;
  final String duration;
  final double price;

  const FeaturedTourItem({
    required this.id,
    required this.title,
    this.imageUrl,
    this.rating = 5,
    required this.date,
    required this.duration,
    required this.price,
  });
}

/// Travel news item
class TravelNewsItem {
  final String id;
  final String title;
  final String date;
  final String? imageUrl;

  const TravelNewsItem({
    required this.id,
    required this.title,
    required this.date,
    this.imageUrl,
  });
}

/// Static sections that do not have API endpoints in the v1 contract yet.
class ExploreData {
  static final List<JourneyItem> journeys = [
    JourneyItem(
      id: 'tour-1',
      title: 'Đà Nẵng - Đà Lạt - Hội An',
      imageUrl: AppImageUrls.tourDaNang,
      date: '20 Th1, 2020',
      duration: '3 ngày',
      price: 800,
      location: 'Việt Nam',
    ),
    JourneyItem(
      id: 'tour-2',
      title: 'Thái Lan',
      imageUrl: AppImageUrls.tourThaiLan,
      date: '20 Th1, 2020',
      duration: '3 ngày',
      price: 800,
      location: 'Thái Lan',
    ),
  ];

  static final List<ExploreGuide> guides = [
    ExploreGuide(
      id: 'guide-1',
      name: 'Tuấn Trần',
      imageUrl: AppImageUrls.guide1,
      location: 'Đà Nẵng, Việt Nam',
      isTopGuide: true,
    ),
    ExploreGuide(
      id: 'guide-2',
      name: 'Emmy',
      imageUrl: AppImageUrls.guide2,
      location: 'Hà Nội, Việt Nam',
    ),
    ExploreGuide(
      id: 'guide-3',
      name: 'Linh Hama',
      imageUrl: AppImageUrls.guide3,
      location: 'Đà Nẵng, Việt Nam',
    ),
    ExploreGuide(
      id: 'guide-4',
      name: 'Jonh',
      imageUrl: AppImageUrls.guide4,
      location: 'TP.HCM, Việt Nam',
    ),
  ];

  static final List<ExperienceItem> experiences = [
    ExperienceItem(
      id: 'e1',
      title: 'Tour xe đạp 2 giờ khám phá Hội An',
      imageUrl: AppImageUrls.tourHoiAn,
      guideName: 'Tuấn Trần',
      guideAvatarUrl: AppImageUrls.guide1,
      location: 'Hội An, Việt Nam',
    ),
    ExperienceItem(
      id: 'e2',
      title: '1 ngày tại Bà Nà Hills',
      imageUrl: AppImageUrls.tourBaNa,
      guideName: 'Linh Hama',
      guideAvatarUrl: AppImageUrls.guide3,
      location: 'Đà Nẵng, Việt Nam',
    ),
  ];

  static final List<FeaturedTourItem> featuredTours = [
    FeaturedTourItem(
      id: 'tour-1',
      title: 'Đà Nẵng - Đà Lạt - Hội An',
      imageUrl: AppImageUrls.tourBaNa,
      date: '20 Th1, 2020',
      duration: '3 ngày',
      price: 800,
    ),
    FeaturedTourItem(
      id: 'tour-2',
      title: 'Melbourne - Sydney',
      imageUrl: AppImageUrls.tourMelbourne,
      date: '20 Th1, 2020',
      duration: '3 ngày',
      price: 800,
    ),
    FeaturedTourItem(
      id: 'tour-3',
      title: 'Hà Nội - Vịnh Hạ Long',
      imageUrl: AppImageUrls.tourHalong,
      date: '20 Th1, 2020',
      duration: '3 ngày',
      price: 280,
    ),
  ];

  static final List<TravelNewsItem> travelNews = [
    TravelNewsItem(
      id: 'n1',
      title: 'Điểm đến mới tại Đà Nẵng',
      date: '5 Th2, 2020',
      imageUrl: AppImageUrls.newsDaNang,
    ),
    TravelNewsItem(
      id: 'n2',
      title: 'Chuyến bay 3D',
      date: '5 Th2, 2020',
      imageUrl: AppImageUrls.newsMayBay,
    ),
    TravelNewsItem(
      id: 'n3',
      title: 'Khám phá Hàn Quốc dịp Tết',
      date: '20 Th1, 2020',
      imageUrl: AppImageUrls.newsHanQuoc,
    ),
  ];
}
