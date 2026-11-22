import 'package:flutter/widgets.dart';

/// Small, dependency-free translation catalogue for the application UI.
/// Keep the English text as the key so existing screens can be migrated
/// incrementally without scattered language conditionals.
class AppLocalizations {
  const AppLocalizations._(this.locale);

  final Locale locale;

  static final Map<String, Map<String, String>> _runtimeTranslations = {};

  /// Every key in the built-in catalogue is also sent to ML Kit. This keeps
  /// the same source of truth for all screens and avoids missing new labels.
  static List<String> get translationKeys => {
    ..._arabic.keys,
    'PharaTrip',
    'Unable to open the photo gallery. Please try again.',
    'Booking number copied',
    'Arriving',
  }.toList();

  static void setTranslations(String languageCode, Map<String, String> values) {
    _runtimeTranslations[languageCode] = values;
  }

  static AppLocalizations of(BuildContext context) =>
      AppLocalizations._(Localizations.localeOf(context));

  String translate(String value) {
    final runtime = _runtimeTranslations[locale.languageCode]?[value];
    if (runtime != null && runtime.isNotEmpty) return runtime;
    if (locale.languageCode != 'ar') return value;
    return _arabic[value] ?? value;
  }

  static const Map<String, String> _arabic = {
    // Trips
    'Available Trips': 'Available Trips',
    'Choose your next Egyptian adventure':
        'Choose your next Egyptian adventure',
    'Starts': 'Starts',
    'From Cairo': 'From Cairo',
    'From Luxor': 'From Luxor',
    'From Hurghada': 'From Hurghada',
    'View Details': 'View Details',
    'Person': 'Person',
    'Max': 'Max',
    'reviews': 'reviews',
    'About This Trip': 'About This Trip',
    'Trip Highlights': 'Trip Highlights',
    'Hotel Details': 'Hotel Details',
    'Book Now': 'Book Now',
    'Search trips...': 'Search trips...',
    'All': 'All',
    'Day Trips': 'Day Trips',
    'Multi-Day': 'Multi-Day',
    'Nature': 'Nature',
    '1 Day': '1 Day',
    '2 Days': '2 Days',
    '3 Days': '3 Days',
    '4 Days': '4 Days',

    // Support
    'Help & Support': 'Help & Support',
    'How can we help?': 'How can we help?',
    'Our travel concierge is ready whenever you need us.':
        '???? ????? ??????? ???? ????????.',
    'Frequently Asked Questions': 'Frequently Asked Questions',
    'Find quick answers to common questions':
        '???? ??? ?????? ????? ??????? ???????',
    'Chat with Support': 'Chat with Support',
    'Talk to our team in real time': 'Talk to our team in real time',
    'Contact Us': 'Contact Us',
    'Reach us by email or phone': 'Reach us by email or phone',
    'TRAVEL GUIDE': 'TRAVEL GUIDE',
    'Answers, made simple.': 'Answers, made simple.',
    'CONCIERGE DESK': 'CONCIERGE DESK',
    'We are here for you.': 'We are here for you.',
    'PERSONAL ASSISTANCE': 'PERSONAL ASSISTANCE',
    'Let�s plan something unforgettable.':
        'Let�s plan something unforgettable.',
    'Call our concierge': 'Call our concierge',
    'Send us an email': 'Send us an email',
    'Visit our office': 'Visit our office',
    'Hello Ahmed, how can we make your next trip special?':
        '?????? ????? ??? ???? ????? ??????? ??????',
    'How do I book a trip?': 'How do I book a trip?',
    'Choose a trip, select your transport and seats, then confirm your booking.':
        '???? ??????? ?? ??? ????? ????? ????????? ???? ????.',
    'Can I cancel my booking?': 'Can I cancel my booking?',
    'Cancellation depends on the trip policy. Contact our concierge for help.':
        '????? ??????? ??? ????? ??????. ????? ?? ???? ??????? ????????.',
    'How can I track my trip?': 'How can I track my trip?',
    'Open My Trips and tap Track Trip on your upcoming booking.':
        '???? ?????? ????? ??? ???? ?????? ?? ???? ??????.',
    'What payment methods are available?':
        'What payment methods are available?',
    'We currently support the payment methods shown at checkout.':
        '???? ?????? ??? ????? ??????? ??? ????? ?????.',
    'Write your message...': 'Write your message...',
    'Cairo, Egypt � Open daily 9 AM � 9 PM':
        '???????? ??? � ????? ?????? ?? 9 ? ??? 9 ?',
    'We usually reply within a few minutes.':
        'We usually reply within a few minutes.',

    // Trip names
    'Giza Pyramids Tour': 'Giza Pyramids Tour',
    'Dahab Adventure': 'Dahab Adventure',
    'Siwa Oasis Escape': 'Siwa Oasis Escape',
    'Luxor History Tour': 'Luxor History Tour',
    'Red Sea Getaway': 'Red Sea Getaway',

    // Places
    'Cairo': 'Cairo',
    'Luxor': 'Luxor',
    'Hurghada': 'Hurghada',
    'Giza': 'Giza',
    'Dahab': 'Dahab',
    'Siwa': 'Siwa',
    'Pyramids of Giza': 'Pyramids of Giza',
    'Sphinx': 'Sphinx',
    'Panoramic Views': 'Panoramic Views',
    'Blue Hole': 'Blue Hole',
    'Desert Safari': 'Desert Safari',
    'Laguna Beach': 'Laguna Beach',
    'Salt Lakes': 'Salt Lakes',
    'Shali Fortress': 'Shali Fortress',
    'Desert Sunset': 'Desert Sunset',
    'Karnak Temple': 'Karnak Temple',
    'Valley of the Kings': 'Valley of the Kings',
    'Nile Cruise': 'Nile Cruise',
    'Snorkeling': 'Snorkeling',
    'Beach Day': 'Beach Day',
    'Boat Trip': 'Boat Trip',

    // Trip descriptions
    'Explore the Great Pyramids of Giza and experience the history of Egypt.':
        '?????? ??????? ?????? ??????? ????? ??? ????? ???.',
    'Enjoy the Red Sea, desert adventures, and the relaxed spirit of Dahab.':
        '?????? ?????? ?????? ???????? ??????? ?????? ??? ???????.',
    "Discover Siwa's salt lakes, palm groves, and peaceful desert landscapes.":
        '????? ?????? ???? ??????? ??????? ?????? ?????? ??????? ???????.',
    'Walk through ancient temples and discover the stories of the pharaohs in Luxor.':
        '???? ??? ??????? ??????? ?????? ??? ???????? ?? ??????.',
    'Relax on clear Red Sea beaches and explore colorful coral reefs.': '?????? ??? ????? ????? ?????? ??????? ??????? ?????? ????????? ???????.',

    // Hotels
    'Pyramids View Inn': 'Pyramids View Inn',
    'Dahab Lagoon Hotel': 'Dahab Lagoon Hotel',
    'Siwa Eco Lodge': 'Siwa Eco Lodge',
    'Nile View Hotel': 'Nile View Hotel',
    'Hurghada Beach Resort': 'Hurghada Beach Resort',
    'Comfortable stay with a panoramic view of the pyramids.':
        '????? ????? ?? ?????? ????????? ??? ???????.',
    'Comfortable rooms near the beach with easy access to Dahab attractions.':
        '??? ????? ????? ?????? ?? ????? ?????? ??? ????? ???.',
    'A peaceful eco-friendly stay surrounded by palms.':
        '????? ????? ????? ?????? ????? ?????? ??????.',
    'Comfortable accommodation beside the Nile.':
        'Comfortable accommodation beside the Nile.',
    'A beachfront resort with direct sea access.':
        '????? ??? ?????? ?? ???? ????? ?????.',

    // My Trips
    'Upcoming': 'Upcoming',
    'Past': 'Past',
    'Canceled': 'Canceled',
    'My Trips': 'My Trips',
    'My Egyptian Trips': 'رحلاتك المصرية',
    'Follow your upcoming adventures and get ready to discover Egypt':
        'تابع مغامراتك القادمة واستعد لاكتشاف مصر',
    'No past trips yet': 'No past trips yet',
    'No canceled trips': 'No canceled trips',
    'Track Trip': 'Track Trip',
    'View itinerary': 'View itinerary',

    // Saved places
    'My Saved Places': 'أماكني المحفوظة',
    'Your favorite destinations and travel plans':
        'وجهاتك المفضلة وخططك السياحية',
    'Saved Destinations': 'Saved Destinations',
    'Completed Trips': 'Completed Trips',
    'Planned Trips': 'Planned Trips',
    'Places Visited': 'Places Visited',
    'My Collections': 'My Collections',
    'New Collection': 'New Collection',
    'Collection name': 'Collection name',
    'Recently Viewed': 'Recently Viewed',
    'All Saved': 'All Saved',
    'Cancel': 'Cancel',
    'Create': 'Create',
    'Places': 'Places',
    'View Places': 'View Places',
    'Dream Destinations': 'Dream Destinations',
    'Hidden Gems': 'Hidden Gems',
    'Weekend Getaways': 'Weekend Getaways',
    'Trekking Bucket List': 'Trekking Bucket List',
    'Luxor Valley': 'Luxor Valley',
    'Kullu District': 'Kullu District',

    // Explore & filters
    'Filters': 'Filters',
    'Reset': 'Reset',
    'Close': 'Close',
    'Apply Filters': 'Apply Filters',
    'District Explorer': 'District Explorer',
    'Trending Now': 'Trending Now',
    'Explore\nEgypt': 'Explore\nEgypt',
    '243 Destinations await you': '243 Destinations await you',
    'Search Destination Cafes, Stays...': 'Search Destination Cafes, Stays...',
    'Pyramids District': 'Pyramids District',
    'Pharaohs Land': 'Pharaohs Land',
    'Red Sea Coast': 'Red Sea Coast',
    'Luxor Temple': 'Luxor Temple',
    'Dahab Lagoon': 'Dahab Lagoon',
    '25 Available Seats': '25 Available Seats',
    '?? Egypt': '?? Egypt',
    'Destination Type': 'Destination Type',
    'District': 'District',
    'Crowd Level': 'Crowd Level',
    'Travel Season': 'Travel Season',
    'Road Condition': 'Road Condition',
    'Weather Preferences': 'Weather Preferences',
    'Select All': 'Select All',
    'Mountains': 'Mountains',
    'Homestays': 'Homestays',
    'Trekking': 'Trekking',
    'Camping': 'Camping',
    'Temples': 'Temples',
    'Scenic Viewpoints': 'Scenic Viewpoints',
    'Waterfalls': 'Waterfalls',
    'Lakes': 'Lakes',
    'Adventure': 'Adventure',

    // Notifications
    'Notifications': 'Notifications',
    'No notifications yet': 'No notifications yet',
    'Booking confirmed': 'Booking confirmed',
    'Trip update': 'Trip update',
    'Your Giza Pyramids Tour is confirmed.':
        '?? ????? ????? ??? ??????? ??????.',
    'Your bus is on the way. Track your trip now.':
        '??????? ?? ??????. ???? ????? ????.',
    'Today': 'Today',
    'Yesterday': 'Yesterday',

    // Profile & settings
    'Explored 23 destinations across Egypt':
        'Explored 23 destinations across Egypt',
    'Trips Completed': 'Trips Completed',
    'Places visited': 'Places visited',
    'Saved spots': 'Saved spots',
    'Past Trips': 'Past Trips',
    'Setting': 'Setting',
    'Edit Profile': 'Edit Profile',
    'Notification': 'Notification',
    'Dark mode': 'Dark mode',
    'Home': 'Home',
    'Favorites': 'Favorites',
    'Profile': 'Profile',
    'Settings': 'Settings',
    'Explore': 'Explore',
    'Support': 'Support',
    'Saved': 'Saved',
    'Location Services': 'Location Services',
    'Language': 'Language',
    'English': 'English',
    'Arabic': 'Arabic',
    'App Version': 'App Version',
    'Select language': 'Select language',
    'My Information': 'My Information',
    'Log Out': 'Log Out',
    'Full Name': 'Full Name',
    'Phone Number': 'Phone Number',
    'Save Changes': 'Save Changes',
    'Change profile photo': 'Change profile photo',
    'Information saved successfully': 'Information saved successfully',
    'Search country': 'Search country',

    // Booking
    'Book Your Transport': 'Book Your Transport',
    'Number of People': 'Number of People',
    'Choose Seats': 'Choose Seats',
    'Select Seats': 'Select Seats',
    'Confirm Booking': 'Confirm Booking',
    'Booking Confirmed!': 'Booking Confirmed!',
    'Your trip has been booked successfully.':
        'Your trip has been booked successfully.',
    'Booking ID': 'Booking ID',
    'View My Trip': 'View My Trip',
    'Back to Home': 'Back to Home',
    'Booking number copied': 'Booking number copied',
    'Unable to open the photo gallery. Please try again.':
        '???? ??? ???? ?????. ???? ??? ????.',
    'Arriving': 'Arriving',

    // Auth
    'Welcome Back!': 'Welcome Back!',
    'Sign in to continue': 'Sign in to continue',
    'Email Address': 'Email Address',
    'Password': 'Password',
    'Forgot Password?': 'Forgot Password?',
    'Sign In': 'Sign In',
    "Don't have an account? ": '??? ???? ????? ',
    'Sign Up': 'Sign Up',
    'Travel Within Egypt': 'Travel Within Egypt',
    'or continue with': 'or continue with',
    'Reset Password': 'Reset Password',
    'Enter your email address\nto receive a reset link':
        '???? ????? ??????????\n?????? ???? ????? ????? ???? ??????',
    'Please enter your email and password':
        '???? ????? ?????? ?????????? ????? ??????',
    'Send Link': 'Send Link',
    'Please enter a valid email': 'Please enter a valid email',
    'Reset link sent to your email':
        '?? ????? ???? ????? ????? ???? ?????? ??? ?????',
    'Create Account': 'Create Account',
    'Join PharaTrip today': 'Join PharaTrip today',
    'Already have an account? ': 'Already have an account? ',
    'or sign up with': 'or sign up with',
    'Verify Your Email': 'Verify Your Email',
    'Enter the 6-digit code sent to\nexample@email.com':
        '???? ????? ??????? ?? 6 ????? ?????? ???\nexample@email.com',
    'Resend Code': 'Resend Code',
    'Verify': 'Verify',

    // Onboarding
    'Skip': 'Skip',
    'Get Started': 'Get Started',
    'Next': 'Next',
    'Explore Egypt\nLike Never Before': 'Explore Egypt\nLike Never Before',
    'Discover amazing trips and\ncreate unforgettable memories':
        '????? ????? ?????\n????? ?????? ?? ????',
    'Discover Dahab\nYour Way': 'Discover Dahab\nYour Way',
    'Relax by the sea and\nexperience unforgettable adventures':
        '?????? ????? ?????\n??? ??????? ?? ????',
    'Live Egypt\nLike Never Before': 'Live Egypt\nLike Never Before',
    'Explore unique places and\ncreate memories that last forever':
        '?????? ????? ?????\n????? ?????? ???? ?????',
  };
}

extension LocalizationExtension on BuildContext {
  String tr(String value) => AppLocalizations.of(this).translate(value);
}
