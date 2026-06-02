/// Privacy & Policies Screen - terms and privacy policy
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';

class PrivacyPoliciesScreen extends StatelessWidget {
  const PrivacyPoliciesScreen({super.key});

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
          AppStrings.privacyPolicies,
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
            _Section(
              title: 'Điều khoản sử dụng',
              content: '''
Bằng việc sử dụng ứng dụng Fellow4U, bạn đồng ý với các điều khoản sau:

1. Sử dụng dịch vụ: Ứng dụng cung cấp nền tảng kết nối du khách với hướng dẫn viên địa phương. Bạn cam kết sử dụng dịch vụ một cách hợp pháp và tôn trọng.

2. Tài khoản: Bạn chịu trách nhiệm bảo mật thông tin đăng nhập và mọi hoạt động diễn ra dưới tài khoản của bạn.

3. Nội dung: Bạn không được đăng tải nội dung vi phạm pháp luật, xúc phạm hoặc gây hại đến người khác.
''',
            ),
            const SizedBox(height: 24),
            _Section(
              title: 'Chính sách bảo mật',
              content: '''
Chúng tôi cam kết bảo vệ quyền riêng tư của bạn:

1. Thu thập thông tin: Chúng tôi thu thập thông tin bạn cung cấp (tên, email, số điện thoại) và dữ liệu sử dụng ứng dụng để cải thiện trải nghiệm.

2. Sử dụng thông tin: Thông tin được sử dụng để cung cấp dịch vụ, xử lý đặt tour, liên hệ và cải thiện ứng dụng.

3. Bảo mật: Chúng tôi áp dụng các biện pháp bảo mật phù hợp để bảo vệ dữ liệu của bạn.

4. Chia sẻ: Chúng tôi không bán thông tin cá nhân của bạn cho bên thứ ba.
''',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content.trim(),
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
