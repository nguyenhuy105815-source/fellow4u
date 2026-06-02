/// Guide Page - profile chi tiết hướng dẫn viên theo Figma
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/guide_detail_data.dart';
import '../../models/guide_model.dart';
import '../../providers/tour_provider.dart';
import '../../routes/app_router.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/app_image.dart';
import '../../widgets/common/placeholder_image.dart';

class GuideDetailScreen extends StatelessWidget {
  final String guideId;

  const GuideDetailScreen({super.key, required this.guideId});

  static List<GuideExperience> get _defaultExperiences => [
      GuideExperience(
        id: 'exp-1',
        title: 'Tour xe đạp 2 giờ khám phá Hội An',
        imageUrls: [
          AppImageUrls.tourHoiAn,
          AppImageUrls.tourCauRong,
          AppImageUrls.tourBaNa,
          AppImageUrls.tourMyKhe,
        ],
        location: 'Hội An, Việt Nam',
        date: '20 Th6, 2020',
        likes: 5243,
      ),
      GuideExperience(
        id: 'exp-2',
        title: 'Food tour Đà Nẵng',
        imageUrls: [
          AppImageUrls.tourDaNang,
          AppImageUrls.newsDaNang,
          AppImageUrls.attractionCongCafe,
          AppImageUrls.attractionCho,
        ],
        location: 'Đà Nẵng, Việt Nam',
        date: '20 Th7, 2020',
        likes: 236,
      ),
    ];

  static List<GuidePricing> get _defaultPricing => [
      const GuidePricing(range: '1-2 du khách', price: '\$10/giờ'),
      const GuidePricing(range: '4-6 du khách', price: '\$14/giờ'),
      const GuidePricing(range: '7-9 du khách', price: '\$17/giờ'),
    ];

  static List<GuideReview> get _defaultReviews => [
      GuideReview(
        id: 'r1',
        authorName: 'Pepa Valdez',
        avatarUrl: AppImageUrls.guide1,
        date: '23 Th1, 2020',
        rating: 5,
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      ),
      GuideReview(
        id: 'r2',
        authorName: 'Dashyun',
        avatarUrl: AppImageUrls.guide2,
        date: '22 Th1, 2020',
        rating: 5,
        content:
            'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      ),
      GuideReview(
        id: 'r3',
        authorName: 'Burma Marks',
        avatarUrl: AppImageUrls.guide3,
        date: '21 Th1, 2020',
        rating: 5,
        content:
            'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
      ),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<TourProvider>(
        builder: (_, tourProvider, __) {
          if (tourProvider.guides.isEmpty) {
            tourProvider.loadGuides();
            return const Center(child: CircularProgressIndicator());
          }
          GuideModel g;
          try {
            g = tourProvider.guides.firstWhere((x) => x.id == guideId);
          } catch (_) {
            g = tourProvider.guides.first;
          }
          return _buildContent(context, g);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, GuideModel guide) {
    final experiences = _defaultExperiences;
    final pricing = _defaultPricing;
    final reviews = _defaultReviews;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildHeader(context, guide),
        ),
        SliverToBoxAdapter(
          child: _buildProfileCard(context, guide, pricing),
        ),
        SliverToBoxAdapter(
          child: _buildExperiences(context, experiences),
        ),
        SliverToBoxAdapter(
          child: _buildReviews(context, reviews),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, GuideModel guide) {
    return Stack(
      children: [
        SizedBox(
          height: 220,
          width: double.infinity,
          child: AppImage(
            imageUrl: AppImageUrls.guideDetailHero,
            fit: BoxFit.cover,
            height: 220,
          ),
        ),
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          child: IconButton(
            onPressed: () => context.pop(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    GuideModel guide,
    List<GuidePricing> pricing,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Transform.translate(
            offset: const Offset(0, -80),
            child: Center(
              child: ClipOval(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: guide.avatarUrl != null
                      ? AppImage(
                          imageUrl: guide.avatarUrl!,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        )
                      : const PlaceholderImage(width: 100, height: 100),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -60),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guide.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (_) => Icon(Icons.star,
                                    size: 18, color: Colors.amber[700]),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${guide.reviewCount} ${AppStrings.reviews}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 160,
                      child: ElevatedButton(
                        onPressed: () => context.push(
                          AppRoutes.tripInformationPath(guide.id),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          AppStrings.chooseThisGuide,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  guide.languages.join(' '),
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      guide.location ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  guide.bio ??
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {},
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 160,
                          width: double.infinity,
                          child: guide.avatarUrl != null
                              ? AppImage(
                                  imageUrl: guide.avatarUrl!,
                                  fit: BoxFit.cover,
                                  height: 160,
                                )
                              : const PlaceholderImage(height: 160),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildPricingTable(pricing),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingTable(List<GuidePricing> pricing) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (var i = 0; i < pricing.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pricing[i].range,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    pricing[i].price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (i < pricing.length - 1)
              Divider(height: 1, color: AppColors.divider),
          ],
        ],
      ),
    );
  }

  Widget _buildExperiences(BuildContext context, List<GuideExperience> list) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.myExperiences,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, i) {
                final exp = list[i];
                return SizedBox(
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                            ),
                            itemCount: 4,
                            itemBuilder: (_, j) => AppImage(
                              imageUrl: exp.imageUrls[j % exp.imageUrls.length],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        exp.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              exp.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            exp.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.favorite,
                              size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            '${exp.likes}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews(BuildContext context, List<GuideReview> list) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Đánh giá',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  AppStrings.seeMoreReviews,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          ...list.take(3).map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: AppImage(
                          imageUrl: r.avatarUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  r.authorName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  r.date,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (_) => Icon(Icons.star,
                                    size: 14, color: Colors.amber[700]),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              r.content,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
