/// Home Screen - layout theo Figma
/// Tab Guides: header + search + 2-col guide grid
/// Tab Tours: header + search + danh sách tour dọc
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/guide_model.dart';
import '../../models/tour_model.dart';
import '../../providers/tour_provider.dart';
import '../../routes/app_router.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/app_image.dart';
import '../../widgets/common/header_with_image.dart';
import '../../widgets/common/placeholder_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TourProvider>().loadTours();
      context.read<TourProvider>().loadGuides();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildSearchBar(context),
            _buildTabBar(context),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _GuidesTab(),
                  _ToursTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ListenableBuilder(
      listenable: _tabController,
      builder: (_, __) {
        final isGuides = _tabController.index == 0;
        return HeaderWithImage(
          title: isGuides
              ? AppStrings.homeGuidesHeader
              : AppStrings.homeToursHeader,
          imageUrl: isGuides ? HeaderImageUrls.guides : HeaderImageUrls.tours,
          height: 140,
          onBack: null,
          trailing: IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () => context.push(AppRoutes.profile),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(AppRoutes.search),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600], size: 22),
                const SizedBox(width: 12),
                Text(
                  AppStrings.searchExploreHint,
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Hướng dẫn viên'),
          Tab(text: 'Tour'),
        ],
      ),
    );
  }
}

class _GuidesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TourProvider>(
      builder: (_, tourProvider, __) {
        if (tourProvider.isLoading && tourProvider.guides.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final guides = tourProvider.guides;
        if (guides.isEmpty) {
          return const Center(child: Text(AppStrings.chooseGuide));
        }
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _GuideCard(
                    guide: guides[i % guides.length],
                    onTap: () => context.push(AppRoutes.guideDetailPath(guides[i % guides.length].id)),
                  ),
                  childCount: guides.length * 2,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PageDot(isActive: true),
                      SizedBox(width: 6),
                      _PageDot(isActive: false),
                      SizedBox(width: 6),
                      _PageDot(isActive: false),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ToursTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TourProvider>(
      builder: (_, tourProvider, __) {
        if (tourProvider.isLoading && tourProvider.tours.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final tours = tourProvider.tours;
        if (tours.isEmpty) {
          return const Center(child: Text(AppStrings.noTours));
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          itemCount: tours.length,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _TourCard(
              tour: tours[i],
              onTap: () => context.push(AppRoutes.tourDetailPath(tours[i].id)),
            ),
          ),
        );
      },
    );
  }
}

/// Card hướng dẫn viên - ảnh vuông, rating overlay góc trái dưới
class _GuideCard extends StatelessWidget {
  final GuideModel guide;
  final VoidCallback onTap;

  const _GuideCard({required this.guide, required this.onTap});

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
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  guide.avatarUrl != null
                      ? AppImage(
                          imageUrl: guide.avatarUrl!,
                          fit: BoxFit.cover,
                          height: 120,
                        )
                      : const PlaceholderImage(height: 120),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(
                            5,
                            (_) => Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber[400],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${guide.reviewCount} ${AppStrings.reviews}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guide.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          guide.location ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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

/// Card tour - ảnh ngang, stars overlay, bookmark, calendar, clock, heart, price
class _TourCard extends StatelessWidget {
  final TourModel tour;
  final VoidCallback onTap;

  const _TourCard({required this.tour, required this.onTap});

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
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: tour.imageUrl != null
                      ? AppImage(
                          imageUrl: tour.imageUrl!,
                          fit: BoxFit.cover,
                          height: 180,
                        )
                      : const PlaceholderImage(height: 180),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(
                          5,
                          (_) => Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber[400],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${tour.reviewCount}${AppStrings.likes}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '30 Th1, 2020',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tour.duration,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${tour.price.toStringAsFixed(0)}.00',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
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

class _PageDot extends StatelessWidget {
  final bool isActive;

  const _PageDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primary : Colors.grey[400],
      ),
    );
  }
}
