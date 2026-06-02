/// My Trips Screen - layout theo Figma
/// Tabs: Current, Next, Past, Wish List
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/tour_model.dart';
import '../../models/trip_model.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';
import '../../services/api_service.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/app_image.dart';
import '../../widgets/common/placeholder_image.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TripModel> _current = [];
  List<TripModel> _next = [];
  List<TripModel> _past = [];
  List<TourModel> _wishlist = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final userId = context.read<AuthProvider>().user?.id ?? '';
    final api = ApiService();
    try {
      final results = await Future.wait<Object>([
        api.getCurrentTrips(userId),
        api.getNextTrips(userId),
        api.getPastTrips(userId),
        api.getWishlistTours(userId),
      ]);
      if (mounted) {
        setState(() {
          _current = results[0] as List<TripModel>;
          _next = results[1] as List<TripModel>;
          _past = results[2] as List<TripModel>;
          _wishlist = results[3] as List<TourModel>;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppStrings.myTrips,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.search),
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _error != null
                ? _ErrorState(message: _error!, onRetry: _loadAll)
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _TripsList(
                        trips: _current,
                        type: _TripType.current,
                        onDetail: _onDetail,
                        onChat: _onChat,
                        onPay: _onPay,
                        onMarkFinished: _onMarkFinished,
                        onChooseGuide: _onChooseGuide,
                        loading: _loading,
                      ),
                      _TripsList(
                        trips: _next,
                        type: _TripType.next,
                        onDetail: _onDetail,
                        onChat: _onChat,
                        onPay: _onPay,
                        onMarkFinished: _onMarkFinished,
                        onChooseGuide: _onChooseGuide,
                        loading: _loading,
                      ),
                      _TripsList(
                        trips: _past,
                        type: _TripType.past,
                        onDetail: _onDetail,
                        onChat: _onChat,
                        onPay: _onPay,
                        onMarkFinished: _onMarkFinished,
                        onChooseGuide: _onChooseGuide,
                        loading: _loading,
                      ),
                      _WishlistList(
                        tours: _wishlist,
                        onTap: (t) =>
                            context.push(AppRoutes.tourDetailPath(t.id)),
                        loading: _loading,
                      ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.home),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Hiện tại'),
          Tab(text: 'Sắp tới'),
          Tab(text: 'Đã qua'),
          Tab(text: 'Yêu thích'),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
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
                  label: 'Chuyến đi',
                  active: true,
                  onTap: () => context.go(AppRoutes.myTrips)),
              _NavItem(
                icon: Icons.chat_bubble_outline,
                label: 'Tin nhắn',
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Tính năng Tin nhắn sắp ra mắt')),
                ),
              ),
              _NavItem(
                icon: Icons.location_on_outlined,
                label: 'Bản đồ',
                onTap: () => context.go(AppRoutes.explore),
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Cá nhân',
                onTap: () => context.go(AppRoutes.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDetail(TripModel trip) =>
      context.push(AppRoutes.tourDetailPath(trip.tour.id));
  void _onChat(TripModel trip) =>
      context.push(AppRoutes.chatPath(trip.tour.guide.id));
  void _onPay(TripModel trip) {}
  Future<void> _onMarkFinished(TripModel trip) async {
    try {
      await ApiService().updateTripStatus(trip.id, TripStatus.completed);
      await _loadAll();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _onChooseGuide(TripModel trip) =>
      context.push(AppRoutes.guideDetailPath(trip.tour.guide.id));
}

enum _TripType { current, next, past }

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: Colors.red[300]),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripsList extends StatelessWidget {
  final List<TripModel> trips;
  final _TripType type;
  final void Function(TripModel) onDetail;
  final void Function(TripModel) onChat;
  final void Function(TripModel) onPay;
  final void Function(TripModel) onMarkFinished;
  final void Function(TripModel) onChooseGuide;
  final bool loading;

  const _TripsList({
    required this.trips,
    required this.type,
    required this.onDetail,
    required this.onChat,
    required this.onPay,
    required this.onMarkFinished,
    required this.onChooseGuide,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppStrings.noTrips,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _TripCard(
          trip: trips[i],
          type: type,
          onDetail: () => onDetail(trips[i]),
          onChat: () => onChat(trips[i]),
          onPay: () => onPay(trips[i]),
          onMarkFinished: () => onMarkFinished(trips[i]),
          onChooseGuide: () => onChooseGuide(trips[i]),
        ),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final TripModel trip;
  final _TripType type;
  final VoidCallback onDetail;
  final VoidCallback onChat;
  final VoidCallback onPay;
  final VoidCallback onMarkFinished;
  final VoidCallback onChooseGuide;

  const _TripCard({
    required this.trip,
    required this.type,
    required this.onDetail,
    required this.onChat,
    required this.onPay,
    required this.onMarkFinished,
    required this.onChooseGuide,
  });

  @override
  Widget build(BuildContext context) {
    final tour = trip.tour;
    return Container(
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
                height: 160,
                width: double.infinity,
                child: tour.imageUrl != null
                    ? AppImage(
                        imageUrl: tour.imageUrl!,
                        fit: BoxFit.cover,
                        height: 160,
                      )
                    : const PlaceholderImage(height: 160),
              ),
              if (type == _TripType.current)
                Positioned(
                  top: 12,
                  left: 12,
                  child: _Badge(
                    text: AppStrings.markFinished,
                    color: AppColors.primary,
                  ),
                )
              else if (type == _TripType.next && !trip.waitingForOffers)
                Positioned(
                  top: 12,
                  left: 12,
                  child: _Badge(text: 'Đang chờ', color: Colors.orange),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      tour.location,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  tour.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(trip.date),
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    if (trip.timeFrom != null) ...[
                      const SizedBox(width: 16),
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        '${trip.timeFrom}-${trip.timeTo}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
                if (!trip.waitingForOffers && !trip.guideRejected) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: tour.guide.avatarUrl != null
                              ? AppImage(
                                  imageUrl: tour.guide.avatarUrl!,
                                  fit: BoxFit.cover,
                                  width: 36,
                                  height: 36,
                                )
                              : const PlaceholderImage(width: 36, height: 36),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        tour.guide.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (trip.pendingGuideCount != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '+${trip.pendingGuideCount}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
                if (trip.waitingForOffers)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      AppStrings.waitingForOffers,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                if (trip.guideRejected)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(Icons.person_off,
                            size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.chooseAnotherGuide,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TextButton(
                      onPressed: onDetail,
                      child: Text(AppStrings.detail),
                    ),
                    if (type != _TripType.past) ...[
                      TextButton(
                        onPressed: onChat,
                        child: Text(AppStrings.chat),
                      ),
                      if (type == _TripType.next && !trip.guideRejected)
                        TextButton(
                          onPressed: onPay,
                          child: Text(AppStrings.pay),
                        ),
                    ],
                    if (trip.guideRejected)
                      ElevatedButton(
                        onPressed: onChooseGuide,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text(AppStrings.chooseAnotherGuide),
                      ),
                    if (type == _TripType.current)
                      ElevatedButton(
                        onPressed: onMarkFinished,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text(AppStrings.markFinished),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} Th${d.month}, ${d.year}';
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _WishlistList extends StatelessWidget {
  final List<TourModel> tours;
  final void Function(TourModel) onTap;
  final bool loading;

  const _WishlistList({
    required this.tours,
    required this.onTap,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tours.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Chưa có tour yêu thích',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tours.length,
      itemBuilder: (_, i) {
        final tour = tours[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _WishlistCard(tour: tour, onTap: () => onTap(tour)),
        );
      },
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final TourModel tour;
  final VoidCallback onTap;

  const _WishlistCard({required this.tour, required this.onTap});

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
                  height: 160,
                  width: double.infinity,
                  child: tour.imageUrl != null
                      ? AppImage(
                          imageUrl: tour.imageUrl!,
                          fit: BoxFit.cover,
                          height: 160,
                        )
                      : const PlaceholderImage(height: 160),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child:
                      Icon(Icons.favorite, color: AppColors.primary, size: 28),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Row(
                    children: [
                      ...List.generate(
                        4,
                        (_) => Icon(Icons.star,
                            size: 16, color: Colors.amber[700]),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${tour.reviewCount}${AppStrings.likes}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tour.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tour.duration,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${tour.price.toStringAsFixed(0)}.00',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
