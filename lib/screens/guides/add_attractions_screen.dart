/// Add Attractions - tìm và thêm điểm đến mới
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/app_image.dart';

class AttractionItem {
  final String id;
  final String name;
  final String imageUrl;

  AttractionItem({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class AddAttractionsScreen extends StatefulWidget {
  const AddAttractionsScreen({super.key});

  @override
  State<AddAttractionsScreen> createState() => _AddAttractionsScreenState();
}

class _AddAttractionsScreenState extends State<AddAttractionsScreen> {
  final _searchController = TextEditingController();
  final List<AttractionItem> _selected = [];
  List<AttractionOption> _suggestions = [
    AttractionOption('1', 'Cong Coffee', AppImageUrls.attractionCongCafe, true),
    AttractionOption('2', 'Chợ Cộng Hòa', AppImageUrls.attractionCho, false),
    AttractionOption('3', 'Chợ Cộng', AppImageUrls.attractionChoCong, false),
    AttractionOption('4', 'Nhà thờ Cộng', AppImageUrls.attractionNhaTho, false),
  ];

  @override
  void dispose() {
    _searchController.dispose();
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
          AppStrings.newAttractions,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => context.pop(_selected),
            child: Text(
              AppStrings.done,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() {}),
              decoration: InputDecoration(
                hintText: AppStrings.typeAPlace,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (_selected.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selected.map((s) {
                  return Chip(
                    avatar: CircleAvatar(
                      backgroundImage: NetworkImage(s.imageUrl),
                    ),
                    label: Text(s.name),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _selected.remove(s);
                        for (final opt in _suggestions) {
                          if (opt.id == s.id) opt.isSelected = false;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _suggestions.length,
              itemBuilder: (_, i) {
                final opt = _suggestions[i];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: AppImage(
                        imageUrl: opt.imageUrl,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  title: Text(opt.name),
                  trailing: opt.isSelected
                      ? Icon(Icons.check_circle, color: AppColors.primary)
                      : const Icon(Icons.add_circle_outline,
                          color: Colors.grey),
                  onTap: () {
                    setState(() {
                      if (opt.isSelected) {
                        _selected.removeWhere((x) => x.id == opt.id);
                        opt.isSelected = false;
                      } else {
                        _selected.add(AttractionItem(
                          id: opt.id,
                          name: opt.name,
                          imageUrl: opt.imageUrl,
                        ));
                        opt.isSelected = true;
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AttractionOption {
  final String id;
  final String name;
  final String imageUrl;
  bool isSelected;

  AttractionOption(this.id, this.name, this.imageUrl, this.isSelected);
}
