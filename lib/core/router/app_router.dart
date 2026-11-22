import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/trips/presentation/screens/trip_details_screen.dart';
import '../../features/trips/presentation/screens/available_trips_screen.dart';
import '../../features/booking/presentation/screens/transport_screen.dart';
import '../../features/booking/presentation/screens/seat_selection_screen.dart';
import '../../features/booking/presentation/screens/booking_confirmed_screen.dart';
import '../../features/tracking/presentation/screens/track_trip_screen.dart';
import '../../features/my_trips/presentation/screens/my_trips_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/help_support_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/my_information_screen.dart';
import '../../features/profile/presentation/screens/privacy_security_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/verify_phone_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../theme/app_theme.dart';
import 'routes.dart';
import '../seo/seo_head.dart';
import '../../features/trips/data/trip_catalog.dart';

Widget _lightOnly(Widget child) => Theme(data: AppTheme.light, child: child);
Widget _seo(
  Widget child,
  String title,
  String description, {
  String jsonLdType = 'WebPage',
  Map<String, dynamic>? jsonLdData,
  bool indexable = true,
}) => Stack(
  children: [
    child,
    SeoHead(title: title, description: description, jsonLdType: jsonLdType, jsonLdData: jsonLdData, indexable: indexable),
  ],
);

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  redirect: (_, state) => state.uri.path == '/' ? AppRoutes.home : null,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (_, _) => _lightOnly(const SplashScreen()),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (_, _) => _seo(
        const HomeScreen(),
        'PharaTrip | Explore Egypt',
        'Discover memorable trips across Egypt with PharaTrip.',
        jsonLdType: 'Organization',
        jsonLdData: {
          'legalName': 'PharaTrip',
          'url': 'https://pharatrip.com/',
          'logo': 'https://pharatrip.com/icons/Icon-512.png',
        },
      ),
    ),
    GoRoute(
      path: '/trip/:id',
      builder: (_, state) {
        final id = state.pathParameters['id']!;
        final trip = TripCatalog.byId[id];
        final title = trip == null ? 'Egypt Trip | PharaTrip' : '${trip.title} in Egypt | PharaTrip';
        final description = trip == null
            ? 'Explore Egypt trips and plan your next adventure with PharaTrip.'
            : 'Book ${trip.title} in ${trip.location}. ${trip.duration} Egypt trip from ${trip.price} with PharaTrip.';
        return Stack(children: [
          TripDetailsScreen(id: id),
          SeoHead(
            title: title,
            description: description,
            image: trip?.image,
            jsonLdType: 'Product',
            jsonLdData: trip == null ? null : {
              'image': 'https://pharatrip.com/${trip.image.replaceFirst('assets/', '')}',
              'sku': id,
              'brand': {'@type': 'Brand', 'name': 'PharaTrip'},
              'category': 'Egypt travel tour',
              'offers': {
                '@type': 'Offer', 'priceCurrency': 'EGP',
                'price': trip.price.replaceAll(RegExp(r'[^0-9]'), ''),
                'availability': 'https://schema.org/InStock',
                'url': 'https://pharatrip.com/trip/$id',
              },
            },
          ),
        ]);
      },
    ),
    GoRoute(
      path: '/booking/transport',
      builder: (_, state) => TransportScreen(
        tripImage: state.extra is String ? state.extra as String : null,
      ),
    ),
    GoRoute(
      path: '/booking/seats',
      builder: (_, state) => SeatSelectionScreen(
        maxSeats:
            int.tryParse(state.uri.queryParameters['maxSeats'] ?? '') ?? 1,
        totalSeats: 45,
        pricePerSeat:
            int.tryParse(state.uri.queryParameters['price'] ?? '') ?? 750,
      ),
    ),
    GoRoute(
      path: '/booking/confirmed/:id',
      builder: (_, state) => BookingConfirmedScreen(
        id: state.pathParameters['id']!,
        seats: state.uri.queryParameters['seats'] ?? '',
      ),
    ),
    GoRoute(
      path: '/track/:bookingId',
      builder: (_, state) =>
          TrackTripScreen(bookingId: state.pathParameters['bookingId']!),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, _) => _lightOnly(const OnboardingScreen()),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (_, _) => _lightOnly(const LoginScreen()),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (_, _) => _lightOnly(const SignupScreen()),
    ),
    GoRoute(
      path: AppRoutes.verify,
      builder: (_, _) => _lightOnly(const VerifyPhoneScreen()),
    ),
    GoRoute(
      path: AppRoutes.reset,
      builder: (_, _) => _lightOnly(const ResetPasswordScreen()),
    ),
    GoRoute(path: AppRoutes.myTrips, builder: (_, _) => const MyTripsScreen()),
    GoRoute(
      path: AppRoutes.explore,
      builder: (_, _) => _seo(
        const AvailableTripsScreen(),
        'Explore Egypt Trips | PharaTrip',
        'Browse available tours and getaways across Egypt with PharaTrip.',
        jsonLdType: 'CollectionPage',
        jsonLdData: {
          'isPartOf': {'@type': 'WebSite', 'name': 'PharaTrip', 'url': 'https://pharatrip.com/'},
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.favorites,
      builder: (_, _) => const FavoritesScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (_, _) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.helpSupport,
      builder: (_, _) => const HelpSupportScreen(),
    ),
    GoRoute(
      path: AppRoutes.faq,
      builder: (_, _) => const FrequentlyAskedQuestionsScreen(),
    ),
    GoRoute(
      path: AppRoutes.supportChat,
      builder: (_, _) => const SupportChatScreen(),
    ),
    GoRoute(
      path: AppRoutes.contactSupport,
      builder: (_, _) => const ContactSupportScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (_, _) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.myInformation,
      builder: (_, _) => const MyInformationScreen(),
    ),
    GoRoute(
      path: AppRoutes.privacySecurity,
      builder: (_, _) => const PrivacySecurityScreen(),
    ),
    GoRoute(path: AppRoutes.profile, builder: (_, _) => const ProfileScreen()),
  ],
);

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text(title)));
}
