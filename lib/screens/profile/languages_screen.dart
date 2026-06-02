/// Languages Screen - select app language
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  String _selected = 'vi';
  bool _loading = false;

  static const _languages = [
    ('vi', 'Tiếng Việt'),
    ('en', 'English'),
    ('ja', '日本語'),
    ('ko', '한국어'),
  ];

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    setState(() => _loading = true);
    try {
      final settings = await ApiService().getSettings();
      final saved = settings['language']?.toString();
      if (!mounted) return;
      setState(() {
        if (saved != null && saved.isNotEmpty) _selected = saved;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _select(String code) async {
    final previous = _selected;
    setState(() => _selected = code);
    try {
      await ApiService().updateSettings(language: code);
    } catch (e) {
      if (!mounted) return;
      setState(() => _selected = previous);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.selectLanguage,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _languages.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final (code, name) = _languages[i];
          final isSelected = _selected == code;
          return ListTile(
            title: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            trailing: isSelected
                ? _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.check_circle,
                        color: AppColors.primary, size: 24)
                : null,
            onTap: _loading ? null : () => _select(code),
          );
        },
      ),
    );
  }
}
