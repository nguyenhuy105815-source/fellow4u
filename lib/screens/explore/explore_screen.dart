/// Explore Screen - Match Figma design 02 | Explore
/// Top Journeys, Best Guides, Top Experiences, Featured Tours, Travel News
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/guide_model.dart';
import '../../models/tour_model.dart';
import '../../providers/tour_provider.dart';
import '../../routes/app_router.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_strings.dart';
import '../../widgets/common/app_image.dart';
import '../../widgets/common/placeholder_image.dart';
import 'explore_data.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TourProvider>();
      if (provider.tours.isEmpty) provider.loadTours();
      if (provider.guides.isEmpty) provider.loadGuides();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tourProvider = context.watch<TourProvider>();
    final journeys = tourProvider.tours.take(4).map(_journeyFromTour).toList();
    final guides = tourProvider.guides.map(_guideFromModel).toList();
    final featuredTours =
        tourProvider.tours.map(_featuredTourFromModel).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context),
            const SizedBox(height: 24),
            if (tourProvider.error != null &&
                tourProvider.tours.isEmpty &&
                tourProvider.guides.isEmpty)
              _buildErrorBanner(context, tourProvider.error!)
            else if (tourProvider.isLoading &&
                tourProvider.tours.isEmpty &&
                tourProvider.guides.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              ),
            _buildTopJourneys(context, journeys),
            const SizedBox(height: 28),
            _buildSectionHeader(
              context,
              AppStrings.bestGuides,
              AppStrings.seeMore,
              () => context.push(AppRoutes.chooseGuide),
            ),
            const SizedBox(height: 16),
            _buildBestGuides(context, guides),
            const SizedBox(height: 28),
            _buildTopExperiences(context),
            const SizedBox(height: 28),
            _buildSectionHeader(
              context,
              AppStrings.featuredTours,
              AppStrings.seeMore,
              () => context.push(AppRoutes.seeMoreTours),
            ),
            const SizedBox(height: 16),
            _buildFeaturedTours(context, featuredTours),
            const SizedBox(height: 28),
            _buildSectionHeader(
              context,
              AppStrings.travelNews,
              AppStrings.seeMore,
              () {},
            ),
            const SizedBox(height: 16),
            _buildTravelNews(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  JourneyItem _journeyFromTour(TourModel tour) {
    return JourneyItem(
      id: tour.id,
      title: tour.title,
      imageUrl: tour.imageUrl,
      rating: tour.rating,
      date: '',
      duration: tour.duration,
      price: tour.price,
      location: tour.location,
    );
  }

  ExploreGuide _guideFromModel(GuideModel guide) {
    return ExploreGuide(
      id: guide.id,
      name: guide.name,
      imageUrl: guide.avatarUrl,
      location: guide.location ?? '',
      rating: guide.rating,
      isTopGuide: guide.rating >= 4.8,
    );
  }

  FeaturedTourItem _featuredTourFromModel(TourModel tour) {
    return FeaturedTourItem(
      id: tour.id,
      title: tour.title,
      imageUrl: tour.imageUrl,
      rating: tour.rating,
      date: '',
      duration: tour.duration,
      price: tour.price,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        AppStrings.explore,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            children: [
              Icon(Icons.wb_sunny_outlined, color: Colors.amber[700], size: 22),
              const SizedBox(width: 4),
              const Text(
                '26°C',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFE3F2FD),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(AppRoutes.search),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600], size: 22),
                const SizedBox(width: 12),
                Text(
                  AppStrings.exploreSearchHint,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
            TextButton(
              onPressed: () {
                final provider = context.read<TourProvider>();
                provider.loadTours();
                provider.loadGuides();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String seeMore,
    VoidCallback onSeeMore,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: onSeeMore,
            child: Text(
              seeMore,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopJourneys(BuildContext context, List<JourneyItem> journeys) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppStrings.topJourneys,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: journeys.isEmpty
              ? Center(child: Text(AppStrings.noTours))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: journeys.length,
                  itemBuilder: (_, i) {
                    final item = journeys[i];
                    return _JourneyCard(
                      item: item,
                      isFirst: i == 0,
                      onTap: () =>
                          context.push(AppRoutes.tourDetailPath(item.id)),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildBestGuides(BuildContext context, List<ExploreGuide> guides) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: guides.isEmpty
          ? Center(child: Text(AppStrings.chooseGuide))
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.82,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: guides.length,
              itemBuilder: (_, i) {
                final guide = guides[i];
                return _GuideCard(
                  guide: guide,
                  onTap: () =>
                      context.push(AppRoutes.guideDetailPath(guide.id)),
                );
              },
            ),
    );
  }

  Widget _buildTopExperiences(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppStrings.topExperiences,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: ExploreData.experiences.length,
            itemBuilder: (_, i) {
              final item = ExploreData.experiences[i];
              return _ExperienceCard(
                item: item,
                onTap: () => context.push(AppRoutes.seeMoreTours),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedTours(
    BuildContext context,
    List<FeaturedTourItem> featuredTours,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: featuredTours.map((tour) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _FeaturedTourCard(
              item: tour,
              onTap: () => context.push(AppRoutes.tourDetailPath(tour.id)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTravelNews(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: ExploreData.travelNews.map((news) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _NewsCard(item: news),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                  icon: Icons.explore,
                  label: AppStrings.explore,
                  isActive: true),
              _NavItem(
                  icon: Icons.location_on_outlined,
                  label: 'Địa điểm',
                  onTap: () => context.push(AppRoutes.search)),
              _NavItem(
                  icon: Icons.chat_bubble_outline, label: 'Chat', onTap: () {}),
              _NavItem(
                  icon: Icons.notifications_outlined,
                  label: 'Thông báo',
                  onTap: () {}),
              _NavItem(
                  icon: Icons.person_outline,
                  label: AppStrings.profile,
                  onTap: () => context.push(AppRoutes.profile)),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  final JourneyItem item;
  final bool isFirst;
  final VoidCallback onTap;

  const _JourneyCard({
    required this.item,
    required this.isFirst,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              isFirst ? Border.all(color: AppColors.primary, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 88,
              width: double.infinity,
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? AppImage(
                      imageUrl: item.imageUrl!, fit: BoxFit.cover, height: 88)
                  : const PlaceholderImage(height: 88),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ...List.generate(
                          5,
                          (_) => Icon(Icons.star,
                              size: 10, color: Colors.amber[700])),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.date.isEmpty
                        ? item.duration
                        : '${item.date} • ${item.duration}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${item.price.toStringAsFixed(0)}.00',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final ExploreGuide guide;
  final VoidCallback onTap;

  const _GuideCard({required this.guide, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: guide.imageUrl != null && guide.imageUrl!.isNotEmpty
                        ? AppImage(
                            imageUrl: guide.imageUrl!,
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          )
                        : const PlaceholderImage(width: 70, height: 70),
                  ),
                ),
                if (guide.isTopGuide)
                  Positioned(
                    bottom: -4,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber[700],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        AppStrings.topGuide,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              guide.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 12, color: AppColors.primary),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    guide.location,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5,
                  (_) => Icon(Icons.star, size: 12, color: Colors.amber[700])),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final ExperienceItem item;
  final VoidCallback onTap;

  const _ExperienceCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? AppImage(
                      imageUrl: item.imageUrl!, fit: BoxFit.cover, height: 200)
                  : const PlaceholderImage(height: 200),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: ClipOval(
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: item.guideAvatarUrl != null &&
                                      item.guideAvatarUrl!.isNotEmpty
                                  ? AppImage(
                                      imageUrl: item.guideAvatarUrl!,
                                      fit: BoxFit.cover,
                                      width: 32,
                                      height: 32,
                                    )
                                  : const PlaceholderImage(
                                      width: 32, height: 32),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.guideName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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
                        Text(
                          item.location,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[300]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedTourCard extends StatelessWidget {
  final FeaturedTourItem item;
  final VoidCallback onTap;

  const _FeaturedTourCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? AppImage(
                      imageUrl: item.imageUrl!,
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    )
                  : const PlaceholderImage(width: 120, height: 120),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ...List.generate(
                            5,
                            (_) => Icon(Icons.star,
                                size: 14, color: Colors.amber[700])),
                        const Spacer(),
                        Icon(Icons.favorite_border,
                            size: 20, color: Colors.grey[600]),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.date.isEmpty
                          ? item.duration
                          : '${item.date} • ${item.duration}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${item.price.toStringAsFixed(0)}.00',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final TravelNewsItem item;

  const _NewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 80,
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? AppImage(
                    imageUrl: item.imageUrl!,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 80,
                  )
                : const PlaceholderImage(width: 100, height: 80),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.date,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isActive ? AppColors.primary : Colors.grey[600],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? AppColors.primary : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
