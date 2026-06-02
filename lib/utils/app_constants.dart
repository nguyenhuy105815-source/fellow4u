/// Application-wide constants
/// API URLs, asset paths, and config values.
library;

/// API base URL.
/// Override at runtime with:
/// --dart-define=API_BASE_URL=http://127.0.0.1:55124/v1
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.fellow4u.com/v1',
);

/// Ảnh local - lib/images/ (1.jpg - 29.jpg, thứ tự từ trên xuống)
class AppAssets {
  AppAssets._();

  static const _img = 'lib/images';

  // Header (1-2)
  static const String headerGuides = '$_img/1.jpg';
  static const String headerTours = '$_img/2.jpg';

  // Tours (3-13)
  static const String tourDaNang = '$_img/3.jpg';
  static const String tourThaiLan = '$_img/4.jpg';
  static const String tourBaNa = '$_img/5.jpg';
  static const String tourMelbourne = '$_img/6.jpg';
  static const String tourHalong = '$_img/7.jpg';
  static const String tourHoiAn = '$_img/8.jpg';
  static const String tourCauRong = '$_img/9.jpg';
  static const String tourMyKhe = '$_img/10.jpg';
  static const String tourPhocohoiAn = '$_img/11.jpg';
  static const String tourVanMieu = '$_img/12.jpg';
  static const String tourDinhDocLap = '$_img/13.jpg';

  // Guides avatar (14-17)
  static const String guide1 = '$_img/14.jpg';
  static const String guide2 = '$_img/15.jpg';
  static const String guide3 = '$_img/16.jpg';
  static const String guide4 = '$_img/17.jpg';

  // Travel news (18-20)
  static const String newsDaNang = '$_img/18.jpg';
  static const String newsMayBay = '$_img/19.jpg';
  static const String newsHanQuoc = '$_img/20.jpg';

  // Profile / My photos (21-23)
  static const String myPhoto1 = '$_img/21.jpg';
  static const String myPhoto2 = '$_img/22.jpg';
  static const String myPhoto3 = '$_img/23.jpg';

  // Attractions (24-27)
  static const String attractionCongCafe = '$_img/24.jpg';
  static const String attractionCho = '$_img/25.jpg';
  static const String attractionChoCong = '$_img/26.jpg';
  static const String attractionNhaTho = '$_img/27.jpg';

  // Khác (28-29)
  static const String guideDetailHero = '$_img/28.jpg';
  static const String defaultUserAvatar = '$_img/29.jpg';

  // Placeholder (assets/images)
  static const String placeholderAvatar =
      'assets/images/placeholder_avatar.png';
  static const String placeholderTour = 'assets/images/placeholder_tour.png';
  static const String placeholderBanner =
      'assets/images/placeholder_banner.png';
  static const String logo = 'assets/images/logo.png';
}

/// Giữ tên cũ AppImageUrls -> trỏ sang AppAssets
class AppImageUrls {
  AppImageUrls._();
  static String get guides => AppAssets.headerGuides;
  static String get tours => AppAssets.headerTours;
  static String get tourDaNang => AppAssets.tourDaNang;
  static String get tourThaiLan => AppAssets.tourThaiLan;
  static String get tourBaNa => AppAssets.tourBaNa;
  static String get tourMelbourne => AppAssets.tourMelbourne;
  static String get tourHalong => AppAssets.tourHalong;
  static String get tourHoiAn => AppAssets.tourHoiAn;
  static String get tourCauRong => AppAssets.tourCauRong;
  static String get tourMyKhe => AppAssets.tourMyKhe;
  static String get tourPhocohoiAn => AppAssets.tourPhocohoiAn;
  static String get tourVanMieu => AppAssets.tourVanMieu;
  static String get tourDinhDocLap => AppAssets.tourDinhDocLap;
  static String get guide1 => AppAssets.guide1;
  static String get guide2 => AppAssets.guide2;
  static String get guide3 => AppAssets.guide3;
  static String get guide4 => AppAssets.guide4;
  static String get newsDaNang => AppAssets.newsDaNang;
  static String get newsMayBay => AppAssets.newsMayBay;
  static String get newsHanQuoc => AppAssets.newsHanQuoc;
  static String get myPhoto1 => AppAssets.myPhoto1;
  static String get myPhoto2 => AppAssets.myPhoto2;
  static String get myPhoto3 => AppAssets.myPhoto3;
  static String get attractionCongCafe => AppAssets.attractionCongCafe;
  static String get attractionCho => AppAssets.attractionCho;
  static String get attractionChoCong => AppAssets.attractionChoCong;
  static String get attractionNhaTho => AppAssets.attractionNhaTho;
  static String get guideDetailHero => AppAssets.guideDetailHero;
  static String get defaultUserAvatar => AppAssets.defaultUserAvatar;
}

/// HeaderImageUrls - tương thích
class HeaderImageUrls {
  HeaderImageUrls._();
  static String get guides => AppAssets.headerGuides;
  static String get tours => AppAssets.headerTours;
}
