/// Search Screen - layout theo Figma
/// 1. Input + Popular destinations
/// 2. Results: Guides + Tours
/// 3. Filter modal
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/guide_model.dart';
import '../../models/tour_model.dart';
import '../../providers/tour_provider.dart';
import '../../routes/app_router.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/app_image.dart';
import '../../widgets/common/placeholder_image.dart';

const _popularDestinations = [
  'Đà Nẵng, Việt Nam',
  'TP.HCM, Việt Nam',
  'Venice, Italy',
];

const _languages = ['Tiếng Việt', 'English', 'Korean', 'Spanish', 'French'];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _showResults = false;
  bool _filterGuides = true;
  final Set<String> _selectedLanguages = {'Tiếng Việt'};
  bool _filterFree = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TourProvider>().loadTours();
      context.read<TourProvider>().loadGuides();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheetContent(
        filterGuides: _filterGuides,
        selectedLanguages: _selectedLanguages,
        filterFree: _filterFree,
        onFilterGuidesChanged: (v) => setState(() => _filterGuides = v),
        onLanguagesChanged: (v) => setState(() {
          _selectedLanguages.clear();
          _selectedLanguages.addAll(v);
        }),
        onFilterFreeChanged: (v) => setState(() => _filterFree = v),
        onApply: () => Navigator.pop(context),
      ),
    );
  }

  void _onSearch(String query) {
    setState(() {
      _query = query;
      _showResults = query.isNotEmpty;
    });
    if (query.isNotEmpty) {
      context.read<TourProvider>().loadTours(location: query);
      context.read<TourProvider>().loadGuides();
    }
  }

  List<GuideModel> _filteredGuides() {
    final guides = context.read<TourProvider>().guides;
    if (_query.isEmpty) return guides;
    return guides
        .where((g) =>
            (g.location?.toLowerCase().contains(_query.toLowerCase()) ?? false) ||
            g.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  List<TourModel> _filteredTours() {
    final tours = context.read<TourProvider>().tours;
    if (_query.isEmpty) return tours;
    final q = _query.toLowerCase();
    return tours
        .where((t) =>
            t.location.toLowerCase().contains(q) ||
            t.title.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: _showResults
            ? _buildSearchBarWithQuery()
            : TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: _onSearch,
              ),
        actions: _showResults
            ? [
                if (_query.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[600], size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _query = '';
                        _showResults = false;
                      });
                    },
                  ),
                IconButton(
                  icon: Icon(Icons.tune, color: AppColors.textPrimary),
                  onPressed: _showFilterModal,
                ),
              ]
            : null,
      ),
      body: _showResults ? _buildResults() : _buildInitialState(),
    );
  }

  Widget _buildSearchBarWithQuery() {
    return GestureDetector(
      onTap: () => setState(() => _showResults = false),
      child: Row(
        children: [
          Icon(Icons.search, size: 22, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _query,
              style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            AppStrings.popularDestinations,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ..._popularDestinations.map(
            (dest) => _PopularItem(
              text: dest,
              onTap: () {
                _searchController.text = dest;
                _onSearch(dest);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Consumer<TourProvider>(
      builder: (_, tourProvider, __) {
        if (tourProvider.isLoading && tourProvider.tours.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final guides = _filteredGuides();
        final tours = _filteredTours();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                '${AppStrings.guidesIn.replaceAll('%s', _query)}',
                () => context.push(AppRoutes.chooseGuide),
              ),
              const SizedBox(height: 12),
              guides.isEmpty
                  ? const SizedBox(height: 120)
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: guides.length > 6 ? 6 : guides.length,
                      itemBuilder: (_, i) => _GuideCard(
                        guide: guides[i],
                        onTap: () =>
                            context.push(AppRoutes.guideDetailPath(guides[i].id)),
                      ),
                    ),
              const SizedBox(height: 24),
              _buildSectionHeader(
                '${AppStrings.toursIn.replaceAll('%s', _query)}',
                () => context.push(AppRoutes.seeMoreTours),
              ),
              const SizedBox(height: 12),
              ...tours.take(4).map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _TourCard(
                        tour: t,
                        onTap: () =>
                            context.push(AppRoutes.tourDetailPath(t.id)),
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeMore) {
    return Row(
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
        TextButton(
          onPressed: onSeeMore,
          child: Text(
            AppStrings.seeMore,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterSheetContent extends StatefulWidget {
  final bool filterGuides;
  final Set<String> selectedLanguages;
  final bool filterFree;
  final ValueChanged<bool> onFilterGuidesChanged;
  final ValueChanged<Set<String>> onLanguagesChanged;
  final ValueChanged<bool> onFilterFreeChanged;
  final VoidCallback onApply;

  const _FilterSheetContent({
    required this.filterGuides,
    required this.selectedLanguages,
    required this.filterFree,
    required this.onFilterGuidesChanged,
    required this.onLanguagesChanged,
    required this.onFilterFreeChanged,
    required this.onApply,
  });

  @override
  State<_FilterSheetContent> createState() => _FilterSheetContentState();
}

class _FilterSheetContentState extends State<_FilterSheetContent> {
  late bool _filterGuides;
  late Set<String> _selectedLanguages;
  late bool _filterFree;

  @override
  void initState() {
    super.initState();
    _filterGuides = widget.filterGuides;
    _selectedLanguages = Set.from(widget.selectedLanguages);
    _filterFree = widget.filterFree;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.filters,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _FilterChip(
                label: AppStrings.guidesFilter,
                selected: _filterGuides,
                onTap: () => setState(() => _filterGuides = true),
              ),
              const SizedBox(width: 12),
              _FilterChip(
                label: AppStrings.toursFilter,
                selected: !_filterGuides,
                onTap: () => setState(() => _filterGuides = false),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.date,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'dd/mm/yy',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.guideLanguage,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _languages.map((lang) {
              final selected = _selectedLanguages.contains(lang);
              return FilterChip(
                label: Text(lang),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    if (selected) {
                      _selectedLanguages.remove(lang);
                    } else {
                      _selectedLanguages.add(lang);
                    }
                  });
                },
                selectedColor: AppColors.primary.withOpacity(0.3),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.feeFilter,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: _filterFree,
                onChanged: (v) => setState(() => _filterFree = v ?? false),
                activeColor: AppColors.primary,
              ),
              Text(AppStrings.free),
              const SizedBox(width: 24),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: AppStrings.feePerHour,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              widget.onFilterGuidesChanged(_filterGuides);
              widget.onLanguagesChanged(_selectedLanguages);
              widget.onFilterFreeChanged(_filterFree);
              widget.onApply();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppStrings.applyFilters,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PopularItem({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final GuideModel guide;
  final VoidCallback onTap;

  const _GuideCard({required this.guide, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipOval(
            child: SizedBox(
              width: 64,
              height: 64,
              child: guide.avatarUrl != null
                  ? AppImage(
                      imageUrl: guide.avatarUrl!,
                      fit: BoxFit.cover,
                      width: 64,
                      height: 64,
                    )
                  : const PlaceholderImage(width: 64, height: 64),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            guide.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, size: 14, color: Colors.amber[700]),
              const SizedBox(width: 2),
              Text(
                '${guide.rating}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 12, color: AppColors.primary),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  guide.location ?? '',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
                  height: 140,
                  width: double.infinity,
                  child: tour.imageUrl != null
                      ? AppImage(
                          imageUrl: tour.imageUrl!,
                          fit: BoxFit.cover,
                          height: 140,
                        )
                      : const PlaceholderImage(height: 140),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(Icons.favorite_border,
                      color: Colors.white, size: 24),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: [
                      ...List.generate(
                        5,
                        (_) => Icon(Icons.star,
                            size: 14, color: Colors.amber[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '30 Th1, 2020',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        tour.duration,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      Icon(Icons.favorite_border,
                          size: 20, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        '\$${tour.price.toStringAsFixed(0)}.00',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
