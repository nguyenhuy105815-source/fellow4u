/// Usage Screen - how to use the app
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';

class UsageScreen extends StatelessWidget {
  const UsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.howToUse,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.usageIntro,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            _UsageCard(
              icon: Icons.search,
              title: 'Tìm kiếm tour và hướng dẫn viên',
              steps: [
                'Vào màn hình Tìm kiếm hoặc Khám phá',
                'Nhập điểm đến hoặc từ khóa',
                'Lọc theo ngày, ngôn ngữ, phí nếu cần',
              ],
            ),
            const SizedBox(height: 12),
            _UsageCard(
              icon: Icons.person,
              title: 'Đặt hướng dẫn viên',
              steps: [
                'Chọn hướng dẫn viên phù hợp',
                'Xem hồ sơ, đánh giá và giá',
                'Điền thông tin chuyến đi (ngày, giờ, số khách)',
                'Thêm điểm đến muốn tham quan',
              ],
            ),
            const SizedBox(height: 12),
            _UsageCard(
              icon: Icons.tour,
              title: 'Đặt tour',
              steps: [
                'Duyệt danh sách tour có sẵn',
                'Xem chi tiết lịch trình và giá',
                'Nhấn "Đặt tour này" để đặt',
              ],
            ),
            const SizedBox(height: 12),
            _UsageCard(
              icon: Icons.chat_bubble_outline,
              title: 'Nhắn tin với hướng dẫn viên',
              steps: [
                'Từ chuyến đi hoặc trang hướng dẫn viên',
                'Nhấn nút Nhắn tin để trò chuyện',
                'Trao đổi chi tiết về chuyến đi',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UsageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> steps;

  const _UsageCard({
    required this.icon,
    required this.title,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...steps.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${e.key + 1}. ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.value,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
