/// Profile Settings Screen - layout theo Figma
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';
import '../../services/api_service.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/app_image.dart';
import '../../widgets/common/placeholder_image.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _settingsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _settingsLoading = true);
    try {
      final settings = await ApiService().getSettings();
      final saved =
          settings['notificationsEnabled'] ?? settings['notifications_enabled'];
      if (!mounted) return;
      setState(() {
        if (saved is bool) _notificationsEnabled = saved;
        _settingsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _settingsLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _setNotifications(bool value) async {
    final previous = _notificationsEnabled;
    setState(() => _notificationsEnabled = value);
    try {
      await ApiService().updateSettings(notificationsEnabled: value);
    } catch (e) {
      if (!mounted) return;
      setState(() => _notificationsEnabled = previous);
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
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.settings,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                child: user?.avatarUrl != null
                    ? ClipOval(
                        child: AppImage(
                          imageUrl: user!.avatarUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const PlaceholderImage(width: 80, height: 80),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.fullName ?? user?.displayName ?? '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.traveler,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push(AppRoutes.editProfile),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppStrings.editProfile.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _SettingItem(
              icon: Icons.notifications_outlined,
              title: AppStrings.notifications,
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: _settingsLoading ? null : _setNotifications,
                activeTrackColor: AppColors.primary,
              ),
            ),
            _SettingItem(
              icon: Icons.language,
              title: AppStrings.languages,
              onTap: () => context.push(AppRoutes.languages),
            ),
            _SettingItem(
              icon: Icons.credit_card,
              title: AppStrings.payment,
              onTap: () => context.push(AppRoutes.payment),
            ),
            _SettingItem(
              icon: Icons.privacy_tip_outlined,
              title: AppStrings.privacyPolicies,
              onTap: () => context.push(AppRoutes.privacyPolicies),
            ),
            _SettingItem(
              icon: Icons.feedback_outlined,
              title: AppStrings.feedback,
              onTap: () => context.push(AppRoutes.feedback),
            ),
            _SettingItem(
              icon: Icons.menu_book_outlined,
              title: AppStrings.usage,
              onTap: () => context.push(AppRoutes.usage),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () async {
                await context.read<AuthProvider>().signOut();
                if (context.mounted) {
                  context.go(AppRoutes.signIn);
                }
              },
              child: Text(
                AppStrings.signOut,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.arrow_forward_ios, size: 14)
              : null),
      onTap: onTap,
    );
  }
}
