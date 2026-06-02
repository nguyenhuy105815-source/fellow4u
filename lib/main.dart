/// Fellow4U - Travel App
/// Main entry point for the application.
/// Helps travelers find local guides and book trips.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/tour_provider.dart';
import 'routes/app_router.dart';
import 'utils/app_strings.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  runApp(Fellow4UApp(authProvider: authProvider));
}

/// Root widget of Fellow4U app.
/// Wraps the app with Provider for state management.
class Fellow4UApp extends StatelessWidget {
  final AuthProvider authProvider;

  const Fellow4UApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => TourProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.createRouter(authProvider),
      ),
    );
  }
}
