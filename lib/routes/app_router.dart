/// App Router - centralized navigation using GoRouter
library;

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/guides/choose_guide_screen.dart';
import '../screens/guides/guide_detail_screen.dart';
import '../screens/guides/trip_information_screen.dart';
import '../screens/guides/add_attractions_screen.dart';
import '../screens/tour/tour_detail_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/trips/my_trips_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/profile_settings_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/change_password_screen.dart';
import '../screens/profile/languages_screen.dart';
import '../screens/profile/payment_screen.dart';
import '../screens/profile/privacy_policies_screen.dart';
import '../screens/profile/feedback_screen.dart';
import '../screens/profile/usage_screen.dart';
import '../screens/tours/see_more_tours_screen.dart';

/// Route names - use for navigation
class AppRoutes {
  static const splash = '/';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const home = '/home';
  static const explore = '/explore';
  static const search = '/search';
  static const chooseGuide = '/choose-guide';
  static const guideDetail = '/guide/:id';
  static const tripInformation = '/trip-info/:guideId';
  static const addAttractions = '/add-attractions';
  static const tourDetail = '/tour/:id';
  static const chat = '/chat/:guideId';
  static const myTrips = '/my-trips';
  static const profile = '/profile';
  static const profileSettings = '/profile/settings';
  static const editProfile = '/profile/edit';
  static const changePassword = '/profile/change-password';
  static const languages = '/profile/languages';
  static const payment = '/profile/payment';
  static const privacyPolicies = '/profile/privacy-policies';
  static const feedback = '/profile/feedback';
  static const usage = '/profile/usage';
  static const seeMoreTours = '/see-more-tours';

  static String tourDetailPath(String id) => '/tour/$id';
  static String guideDetailPath(String id) => '/guide/$id';
  static String tripInformationPath(String guideId) => '/trip-info/$guideId';
  static String chatPath(String guideId) => '/chat/$guideId';
}

class AppRouter {
  /// Creates router with refresh on auth changes
  static GoRouter createRouter(AuthProvider authProvider) => GoRouter(
        initialLocation: AppRoutes.splash,
        refreshListenable: authProvider,
        debugLogDiagnostics: true,
        redirect: (context, state) {
          final auth = context.read<AuthProvider>();
          final isAuthRoute = state.matchedLocation == AppRoutes.signIn ||
              state.matchedLocation == AppRoutes.signUp ||
              state.matchedLocation == AppRoutes.splash;

          if (auth.status == AuthStatus.initial ||
              auth.status == AuthStatus.loading) {
            return null; // Wait for auth check
          }
          if (!auth.isAuthenticated && !isAuthRoute) {
            return AppRoutes.signIn;
          }
          if (auth.isAuthenticated &&
              (state.matchedLocation == AppRoutes.signIn ||
                  state.matchedLocation == AppRoutes.signUp)) {
            return AppRoutes.home;
          }
          if (state.matchedLocation == AppRoutes.splash &&
              auth.isAuthenticated) {
            return AppRoutes.home;
          }
          if (state.matchedLocation == AppRoutes.splash &&
              !auth.isAuthenticated) {
            return AppRoutes.signIn;
          }
          return null;
        },
        routes: [
          GoRoute(
            path: AppRoutes.splash,
            builder: (_, __) => const SplashScreen(),
          ),
          GoRoute(
            path: AppRoutes.signIn,
            builder: (_, __) => const SignInScreen(),
          ),
          GoRoute(
            path: AppRoutes.signUp,
            builder: (_, __) => const SignUpScreen(),
          ),
          GoRoute(
            path: AppRoutes.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.explore,
            builder: (_, __) => const ExploreScreen(),
          ),
          GoRoute(
            path: AppRoutes.search,
            builder: (_, __) => const SearchScreen(),
          ),
          GoRoute(
            path: AppRoutes.chooseGuide,
            builder: (_, __) => const ChooseGuideScreen(),
          ),
          GoRoute(
            path: AppRoutes.guideDetail,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return GuideDetailScreen(guideId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.tripInformation,
            builder: (context, state) {
              final guideId = state.pathParameters['guideId'] ?? '';
              return TripInformationScreen(guideId: guideId);
            },
          ),
          GoRoute(
            path: AppRoutes.addAttractions,
            builder: (_, __) => const AddAttractionsScreen(),
          ),
          GoRoute(
            path: AppRoutes.tourDetail,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return TourDetailScreen(tourId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.chat,
            builder: (context, state) {
              final guideId = state.pathParameters['guideId'] ?? '';
              return ChatScreen(guideId: guideId);
            },
          ),
          GoRoute(
            path: AppRoutes.myTrips,
            builder: (_, __) => const MyTripsScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, __) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.profileSettings,
            builder: (_, __) => const ProfileSettingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.editProfile,
            builder: (_, __) => const EditProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.changePassword,
            builder: (_, __) => const ChangePasswordScreen(),
          ),
          GoRoute(
            path: AppRoutes.languages,
            builder: (_, __) => const LanguagesScreen(),
          ),
          GoRoute(
            path: AppRoutes.payment,
            builder: (_, __) => const PaymentScreen(),
          ),
          GoRoute(
            path: AppRoutes.privacyPolicies,
            builder: (_, __) => const PrivacyPoliciesScreen(),
          ),
          GoRoute(
            path: AppRoutes.feedback,
            builder: (_, __) => const FeedbackScreen(),
          ),
          GoRoute(
            path: AppRoutes.usage,
            builder: (_, __) => const UsageScreen(),
          ),
          GoRoute(
            path: AppRoutes.seeMoreTours,
            builder: (_, __) => const SeeMoreToursScreen(),
          ),
        ],
      );
}
