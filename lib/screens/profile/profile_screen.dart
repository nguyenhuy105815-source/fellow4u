/// Profile Screen - layout theo Figma
/// My Photos, My Journeys
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/app_image.dart';
import '../../widgets/common/placeholder_image.dart';

/// Dùng AppAssets (static const) thay vì AppImageUrls (getter) cho const list
const _myPhotos = [
  AppAssets.myPhoto1,
  AppAssets.myPhoto2,
  AppAssets.myPhoto3,
];

class _JourneyItem {
  final String id;
  final String title;
  final String location;
  final String date;
  final int likes;
  final List<String> imageUrls;

  const _JourneyItem({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.likes,
    required this.imageUrls,
  });
}

final _myJourneys = [
  _JourneyItem(
    id: 'j1',
    title: 'Kỷ niệm ở Đà Nẵng',
    location: 'Đà Nẵng, Việt Nam',
    date: '20 Th1, 2020',
    likes: 234,
    imageUrls: [AppImageUrls.tourHoiAn, AppImageUrls.tourCauRong],
  ),
  _JourneyItem(
    id: 'j2',
    title: 'Sapa mùa xuân',
    location: 'Sapa, Việt Nam',
    date: '20 Th1, 2020',
    likes: 234,
    imageUrls: [AppImageUrls.tourDinhDocLap, AppImageUrls.myPhoto3],
  ),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.textPrimary),
            onPressed: () => context.push(AppRoutes.profileSettings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                child: user?.avatarUrl != null
                    ? ClipOval(
                        child: AppImage(
                          imageUrl: user!.avatarUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const PlaceholderImage(width: 100, height: 100),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.fullName ?? user?.displayName ?? AppStrings.traveler,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            _SectionHeader(
              title: AppStrings.myPhotos,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            Row(
              children: _myPhotos.asMap().entries.map((e) {
                final i = e.key;
                final url = e.value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AppImage(imageUrl: url, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            _SectionHeader(
              title: AppStrings.myJourneys,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            ..._myJourneys.map(
              (j) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _JourneyCard(item: j),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                  icon: Icons.explore,
                  label: 'Khám phá',
                  onTap: () => context.go(AppRoutes.home)),
              _NavItem(
                  icon: Icons.location_on_outlined,
                  label: 'Bản đồ',
                  onTap: () => context.go(AppRoutes.explore)),
              _NavItem(
                icon: Icons.chat_bubble_outline,
                label: 'Tin nhắn',
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Tính năng Tin nhắn sắp ra mắt')),
                ),
              ),
              _NavItem(
                  icon: Icons.person_outline,
                  label: 'Cá nhân',
                  onTap: () => context.go(AppRoutes.myTrips)),
              _NavItem(
                  icon: Icons.person,
                  label: 'Hồ sơ',
                  active: true,
                  onTap: () => context.go(AppRoutes.profile)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SectionHeader({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  final _JourneyItem item;

  const _JourneyCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: item.imageUrls
                      .map(
                        (url) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AppImage(imageUrl: url, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                item.location,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                item.date,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const Spacer(),
              Icon(Icons.favorite, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                '${item.likes}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: active ? AppColors.primary : Colors.grey[600],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: active ? AppColors.primary : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
