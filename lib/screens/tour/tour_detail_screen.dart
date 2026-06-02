/// Tour Detail Screen - full tour information per Figma design
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/tour_model.dart';
import '../../providers/tour_provider.dart';
import '../../routes/app_router.dart';
import '../../services/api_service.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/app_image.dart';

/// Schedule item for timeline
class _ScheduleItem {
  final String time;
  final String description;

  const _ScheduleItem(this.time, this.description);
}

class TourDetailScreen extends StatefulWidget {
  final String tourId;

  const TourDetailScreen({super.key, required this.tourId});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

/// Tour detail images - thứ tự từ trên xuống (dùng AppAssets để const)
const _tourDetailImages = [
  AppAssets.tourDaNang,
  AppAssets.tourBaNa,
  AppAssets.tourHalong,
];

class _TourDetailScreenState extends State<TourDetailScreen> {
  TourModel? _tour;
  bool _isLoading = true;
  bool _isFavorite = false;
  String? _error;
  int _selectedDay = 0;

  // Static schedule copy until the backend exposes tour itinerary details.
  static const _day1Schedule = [
    _ScheduleItem(
        '6:00AM', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
    _ScheduleItem('10:00AM',
        'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
    _ScheduleItem('1:00PM',
        'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.'),
    _ScheduleItem(
        '8:00PM', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
  ];
  static const _day2Schedule = [
    _ScheduleItem('7:00AM', 'Explore local markets and breakfast.'),
    _ScheduleItem('11:00AM', 'Visit historical landmarks.'),
    _ScheduleItem('3:00PM', 'Free time and optional activities.'),
    _ScheduleItem('7:00PM', 'Dinner and departure.'),
  ];

  List<_ScheduleItem> get _currentSchedule =>
      _selectedDay == 0 ? _day1Schedule : _day2Schedule;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTour());
  }

  Future<void> _loadTour() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final tour =
          await context.read<TourProvider>().getTourById(widget.tourId);
      if (mounted) {
        setState(() {
          _tour = tour;
          _error = tour == null
              ? context.read<TourProvider>().error ?? 'Tour not found.'
              : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final tour = _tour;
    if (tour == null) return;

    final previous = _isFavorite;
    setState(() => _isFavorite = !previous);
    try {
      if (_isFavorite) {
        await ApiService().addWishlistTour(tour.id);
      } else {
        await ApiService().removeWishlistTour(tour.id);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isFavorite = previous);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showBookingSheet() {
    final tour = _tour!;
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
    int adults = 1;
    int children = 0;
    final adultPrice = tour.price;
    final childPrice = tour.price * 0.8;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final total = adultPrice * adults + childPrice * children;
          final dateStr =
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.bookTour,
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.selectDate,
                    style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setModalState(() => selectedDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 20, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Text(dateStr,
                              style: Theme.of(ctx).textTheme.bodyLarge),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.grey[600]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.adults,
                    style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _GuestStepper(
                    count: adults,
                    price: adultPrice,
                    minCount: 1,
                    onChanged: (v) => setModalState(() => adults = v),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.children,
                    style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _GuestStepper(
                    count: children,
                    price: childPrice,
                    onChanged: (v) => setModalState(() => children = v),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.totalPrice,
                          style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        try {
                          final api = ApiService();
                          await api.bookTour(
                            tour: tour,
                            date: selectedDate,
                            adults: adults,
                            children: children,
                          );
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppStrings.bookingSuccess),
                              backgroundColor: Colors.green,
                            ),
                          );
                          context.go(AppRoutes.myTrips);
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đặt tour thất bại: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Text(
                        AppStrings.confirmBooking,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showShareModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.shareOn,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ShareIcon(
                      icon: Icons.facebook,
                      label: 'Facebook',
                      color: const Color(0xFF1877F2)),
                  _ShareIcon(
                      icon: Icons.g_mobiledata,
                      label: 'Google+',
                      color: const Color(0xFFDB4437)),
                  _ShareIcon(
                      icon: Icons.chat,
                      label: 'Zalo',
                      color: const Color(0xFF0068FF)),
                  _ShareIcon(
                      icon: Icons.chat_bubble,
                      label: 'WhatsApp',
                      color: const Color(0xFF25D366)),
                  _ShareIcon(
                      icon: Icons.alternate_email,
                      label: 'Twitter',
                      color: const Color(0xFF1DA1F2)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(AppStrings.cancel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null || _tour == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 56, color: Colors.red[300]),
                const SizedBox(height: 12),
                Text(
                  _error ?? 'Tour not found.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _loadTour,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final tour = _tour!;
    final adultPrice = tour.price;
    final childPrice = tour.price * 0.8;
    final departureDate = DateTime.now().add(const Duration(days: 30));
    final dateStr = '${_monthName(departureDate.month)} ${departureDate.day}';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero image với overlay app bar
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white, size: 20),
                ),
                onPressed: _showShareModal,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: AppImage(
                imageUrl: _tourDetailImages[0],
                fit: BoxFit.cover,
                height: 240,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tour Overview Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
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
                              child: Text(
                                tour.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            Text(
                              '\$${adultPrice.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ...List.generate(
                                5,
                                (i) => const Icon(Icons.star,
                                    color: Colors.amber, size: 18)),
                            const SizedBox(width: 4),
                            Text(
                              '${tour.reviewCount} ${AppStrings.reviews}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tour.guide.name,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Gallery - ảnh 2 và 3
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 180,
                          child: AppImage(
                            imageUrl: _tourDetailImages[1],
                            fit: BoxFit.cover,
                            height: 180,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 180,
                          child: AppImage(
                            imageUrl: _tourDetailImages[2],
                            fit: BoxFit.cover,
                            height: 180,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Summary
                  Text(
                    AppStrings.summary,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _SummaryRow(
                      label: AppStrings.itinerary, value: tour.location),
                  _SummaryRow(label: 'Thời lượng', value: tour.duration),
                  _SummaryRow(label: AppStrings.departureDate, value: dateStr),
                  _SummaryRow(
                      label: AppStrings.departurePlace,
                      value: 'TP. Hồ Chí Minh'),
                  const SizedBox(height: 24),

                  // Schedule
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.schedule,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _ScheduleTab(
                        label: 'Ngày 1',
                        subtitle: 'TP. HCM - ${tour.location.split(',').first}',
                        isSelected: _selectedDay == 0,
                        onTap: () => setState(() => _selectedDay = 0),
                      ),
                      const SizedBox(width: 12),
                      _ScheduleTab(
                        label: 'Ngày 2',
                        subtitle: tour.location,
                        isSelected: _selectedDay == 1,
                        onTap: () => setState(() => _selectedDay = 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...(_currentSchedule.asMap().entries.map((e) => _TimelineItem(
                        time: e.value.time,
                        description: e.value.description,
                        isLast: e.key == _currentSchedule.length - 1,
                      ))),
                  const SizedBox(height: 24),

                  // Price
                  Row(
                    children: [
                      Icon(Icons.attach_money,
                          size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.priceSection,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _PriceRow(
                            label: AppStrings.adultPrice,
                            value: '\$${adultPrice.toStringAsFixed(2)}'),
                        const Divider(height: 24),
                        _PriceRow(
                            label: AppStrings.childPrice,
                            value: '\$${childPrice.toStringAsFixed(2)}'),
                        const Divider(height: 24),
                        _PriceRow(
                            label: AppStrings.childFree,
                            value: AppStrings.free),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _showBookingSheet,
            child: Text(
              AppStrings.bookThisTour,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      'Thg 1',
      'Thg 2',
      'Thg 3',
      'Thg 4',
      'Thg 5',
      'Thg 6',
      'Thg 7',
      'Thg 8',
      'Thg 9',
      'Thg 10',
      'Thg 11',
      'Thg 12'
    ];
    return names[month - 1];
  }
}

class _GuestStepper extends StatelessWidget {
  final int count;
  final double price;
  final int minCount;
  final void Function(int) onChanged;

  const _GuestStepper({
    required this.count,
    required this.price,
    this.minCount = 0,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: count > minCount ? () => onChanged(count - 1) : null,
            icon: const Icon(Icons.remove_circle_outline),
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => onChanged(count + 1),
            icon: const Icon(Icons.add_circle_outline),
            color: AppColors.primary,
          ),
          const Spacer(),
          Text(
            '\$${(price * count).toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _ShareIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ShareIcon({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Chia sẻ qua $label - sắp ra mắt')),
            );
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          Expanded(
              child:
                  Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _ScheduleTab extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScheduleTab({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color:
                          isSelected ? Colors.white70 : AppColors.textSecondary,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String time;
  final String description;
  final bool isLast;

  const _TimelineItem({
    required this.time,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: AppColors.primary.withOpacity(0.5),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
