/// Trip Information - form nhập thông tin chuyến đi theo Figma
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_constants.dart';
import '../../routes/app_router.dart';
import '../../widgets/common/app_image.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';
import 'add_attractions_screen.dart';

class TripInformationScreen extends StatefulWidget {
  final String guideId;

  const TripInformationScreen({super.key, required this.guideId});

  @override
  State<TripInformationScreen> createState() => _TripInformationScreenState();
}

class _TripInformationScreenState extends State<TripInformationScreen> {
  int _travelers = 1;
  final _dateController = TextEditingController(text: 'dd/mm/yy');
  final _timeFromController = TextEditingController(text: 'Từ');
  final _timeToController = TextEditingController(text: 'Đến');
  final _cityController = TextEditingController(text: 'Đà Nẵng');
  final List<AttractionItem> _attractions = [
    AttractionItem(id: '1', name: 'Cầu Rồng', imageUrl: AppImageUrls.tourCauRong),
    AttractionItem(id: '2', name: 'Bãi biển Mỹ Khê', imageUrl: AppImageUrls.tourMyKhe),
    AttractionItem(id: '3', name: 'Phố cổ Hội An', imageUrl: AppImageUrls.tourPhocohoiAn),
  ];

  @override
  void dispose() {
    _dateController.dispose();
    _timeFromController.dispose();
    _timeToController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
        ),
        title: Text(
          AppStrings.tripInformation,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onDone,
            child: Text(
              AppStrings.done,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField(
              label: AppStrings.date,
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: 'dd/mm/yy',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today, size: 20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildField(
              label: AppStrings.time,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _timeFromController,
                      decoration: InputDecoration(
                        hintText: 'Từ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _timeToController,
                      decoration: InputDecoration(
                        hintText: 'Đến',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.access_time, size: 22),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildField(
              label: AppStrings.city,
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  hintText: 'Đà Nẵng',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Icon(Icons.location_on,
                      size: 22, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildField(
              label: AppStrings.numberOfTravelers,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (_travelers > 1) {
                        setState(() => _travelers--);
                      }
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.remove, size: 20),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    '$_travelers',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    onPressed: () => setState(() => _travelers++),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.attractions,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final result = await context.push<List<AttractionItem>>(
                      AppRoutes.addAttractions,
                    );
                    if (result != null && result.isNotEmpty) {
                      setState(() => _attractions.addAll(result));
                    }
                  },
                  icon:
                      const Icon(Icons.add, size: 20, color: AppColors.primary),
                  label: Text(
                    AppStrings.addNew,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: _attractions
                  .map(
                    (a) => _AttractionChip(
                      item: a,
                      onRemove: () {
                        setState(() => _attractions.remove(a));
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: _onDone,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'XONG',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  void _onDone() {
    context.pushReplacement(AppRoutes.chatPath(widget.guideId));
  }
}

class _AttractionChip extends StatelessWidget {
  final AttractionItem item;
  final VoidCallback onRemove;

  const _AttractionChip({
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 100,
                height: 80,
                child: AppImage(
                  imageUrl: item.imageUrl,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 80,
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 100,
          child: Text(
            item.name,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
