/// Sign Up Screen - Matches Fellow4U Figma design
/// Fields: First Name, Last Name, Country, Email, Password, Confirm Password
/// User type: Traveler / Guide. Terms & Conditions. Solid teal button.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/underline_text_field.dart';

enum UserType { traveler, guide }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserType _userType = UserType.traveler;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    context.read<AuthProvider>().clearError();
    if (!_formKey.currentState!.validate()) return;

    final displayName =
        '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';

    final success = await context.read<AuthProvider>().signUp(
          _emailController.text.trim(),
          _passwordController.text,
          displayName,
          _userType.name,
        );

    if (success && context.mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            AuthHeader(onBack: () => context.pop()),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        AppStrings.signUp,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 20),
                      _buildUserTypeSelector(),
                      const SizedBox(height: 24),
                      UnderlineTextField(
                        controller: _firstNameController,
                        label: AppStrings.firstName,
                        hint: AppStrings.hintFirstName,
                        validator: firstNameValidator(),
                      ),
                      const SizedBox(height: 20),
                      UnderlineTextField(
                        controller: _lastNameController,
                        label: AppStrings.lastName,
                        hint: AppStrings.hintLastName,
                        validator: lastNameValidator(),
                      ),
                      const SizedBox(height: 20),
                      UnderlineTextField(
                        controller: _countryController,
                        label: AppStrings.country,
                        hint: AppStrings.hintCountry,
                        validator: countryValidator(),
                      ),
                      const SizedBox(height: 20),
                      UnderlineTextField(
                        controller: _emailController,
                        label: AppStrings.email,
                        hint: AppStrings.hintEmail,
                        keyboardType: TextInputType.emailAddress,
                        validator: emailValidator(),
                      ),
                      const SizedBox(height: 20),
                      UnderlineTextField(
                        controller: _passwordController,
                        label: AppStrings.password,
                        hint: AppStrings.hintPassword,
                        obscureText: true,
                        helperText: AppStrings.passwordHint,
                        validator: passwordValidator(),
                      ),
                      const SizedBox(height: 20),
                      UnderlineTextField(
                        controller: _confirmPasswordController,
                        label: AppStrings.confirmPassword,
                        hint: AppStrings.hintPassword,
                        obscureText: true,
                        validator: confirmPasswordValidator(
                            () => _passwordController.text),
                      ),
                      const SizedBox(height: 16),
                      _buildErrorMessage(context),
                      const SizedBox(height: 16),
                      _buildTermsLink(context),
                      const SizedBox(height: 24),
                      _buildSignUpButton(context),
                      const SizedBox(height: 24),
                      _buildSignInLink(context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _UserTypeOption(
            label: AppStrings.traveler,
            selected: _userType == UserType.traveler,
            onTap: () => setState(() => _userType = UserType.traveler),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _UserTypeOption(
            label: AppStrings.guide,
            selected: _userType == UserType.guide,
            onTap: () => setState(() => _userType = UserType.guide),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) {
        if (auth.errorMessage == null || auth.errorMessage!.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            auth.errorMessage!,
            style: const TextStyle(color: AppColors.error, fontSize: 14),
          ),
        );
      },
    );
  }

  Widget _buildTermsLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.termsLink)),
        );
      },
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
          children: [
            TextSpan(text: AppStrings.termsText),
            TextSpan(
              text: AppStrings.termsLink,
              style: const TextStyle(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: auth.status == AuthStatus.loading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: auth.status == AuthStatus.loading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    AppStrings.signUp.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        GestureDetector(
          onTap: () => context.go(AppRoutes.signIn),
          child: const Text(
            AppStrings.signIn,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class _UserTypeOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _UserTypeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.divider,
                width: 2,
              ),
              color: selected ? AppColors.primary : Colors.transparent,
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
