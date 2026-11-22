import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/auth/auth_session.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    final dark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final languageCode = ref.watch(localeProvider).languageCode;
    final text = dark ? Colors.white : const Color(0xFF17232A);
    final muted = dark ? Colors.white70 : const Color(0xFF526067);
    return Scaffold(
      backgroundColor: dark ? const Color(0xFF101615) : Colors.white,
      body: AppNavigationBody(
        selectedIndex: 4,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
            children: [
              Center(child: _avatar()),
              const SizedBox(height: 10),
              Text(
                'Mahmoud Al AzaZy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: text,
                ),
              ),
              const SizedBox(height: 6),
              const SizedBox(height: 18),
              Text(
                context.tr('Explored 23 destinations across Egypt'),
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, fontSize: 13),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat('20', context.tr('Trips Completed'), text),
                  _stat('30', context.tr('Places visited'), text),
                  _stat('10', context.tr('Saved spots'), AppColors.teal),
                ],
              ),
              const SizedBox(height: 26),
              _sectionTitle(
                context.tr('My Trips'),
                text,
                onViewAll: () => context.go(AppRoutes.myTrips),
              ),
              const SizedBox(height: 10),
              _tripCard(
                context,
                'assets/images/dahab.jpg',
                'Upcoming',
                'Dahab & Red Sea',
                '15 Jul - 20 Jul · 5 Days',
                true,
                text,
              ),
              const SizedBox(height: 24),
              _sectionTitle(
                context.tr('Past Trips'),
                text,
                onViewAll: () => context.go(AppRoutes.myTrips),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _pastTrip(
                      'assets/images/onboarding_bg_temple.png',
                      'Luxor Valley',
                      'Upper Egypt',
                      text,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _pastTrip(
                      'assets/images/siwa.jpg',
                      'Siwa Oasis',
                      'Matrouh',
                      text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              _sectionTitle(context.tr('Setting'), text),
              const SizedBox(height: 8),
              _setting(
                context.tr('Edit Profile'),
                Icons.person_outline,
                text,
                onTap: () => context.push(AppRoutes.myInformation),
              ),
              _setting(
                context.tr('Notification'),
                Icons.notifications_none_rounded,
                text,
                trailing: Switch(
                  value: notifications,
                  activeThumbColor: AppColors.teal,
                  onChanged: (v) => setState(() => notifications = v),
                ),
              ),
              _setting(
                context.tr('Dark mode'),
                Icons.dark_mode_outlined,
                text,
                trailing: Switch(
                  value: dark,
                  activeThumbColor: AppColors.teal,
                  onChanged: (v) => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
                ),
              ),
              _setting(
                'Language',
                Icons.language,
                text,
                trailing: Text(
                  languageCode == 'ar'
                      ? context.tr('Arabic')
                      : context.tr('English'),
                  style: TextStyle(color: muted),
                ),
                onTap: () => showModalBottomSheet<void>(
                  context: context,
                  builder: (sheetContext) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(context.tr('English')),
                          trailing: languageCode == 'en'
                              ? const Icon(Icons.check)
                              : null,
                          onTap: () {
                            ref.read(localeProvider.notifier).setLanguage('en');
                            Navigator.pop(sheetContext);
                          },
                        ),
                        ListTile(
                          title: Text(context.tr('Arabic')),
                          trailing: languageCode == 'ar'
                              ? const Icon(Icons.check)
                              : null,
                          onTap: () {
                            ref.read(localeProvider.notifier).setLanguage('ar');
                            Navigator.pop(sheetContext);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _setting(
                'Privacy & Security',
                Icons.lock_outline,
                text,
                onTap: () => context.go(AppRoutes.privacySecurity),
              ),
              _setting(
                context.tr('Frequently Asked Questions'),
                Icons.quiz_outlined,
                text,
                onTap: () => context.go(AppRoutes.faq),
              ),
              _setting(
                context.tr('Contact Us'),
                Icons.mail_outline_rounded,
                text,
                onTap: () => context.go(AppRoutes.contactSupport),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  await AuthSession.clear();
                  if (context.mounted) context.go(AppRoutes.login);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkTeal,
                  side: const BorderSide(color: AppColors.teal),
                  shape: const StadiumBorder(),
                ),
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(selectedIndex: 4),
    );
  }

  Widget _avatar() => Container(
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0xFFE5A143), width: 2),
    ),
    child: const CircleAvatar(
      radius: 62,
      backgroundImage: AssetImage('assets/images/onboarding_egypt_culture.jpg'),
    ),
  );
  Widget _stat(String value, String label, Color color) => Column(
    children: [
      Text(
        value,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 10)),
    ],
  );
  Widget _sectionTitle(String title, Color color, {VoidCallback? onViewAll}) =>
      Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'View All',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      );
  Widget _tripCard(
    BuildContext context,
    String image,
    String tag,
    String title,
    String date,
    bool button,
    Color text,
  ) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      clipBehavior: Clip.none,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go(AppRoutes.myTrips),
        child: SizedBox(
          height: 172,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: ClipPath(
                  clipper: _ProfileTripImageClipper(),
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                left: MediaQuery.sizeOf(context).width * .55,
                right: 4,
                top: 12,
                bottom: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.05,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 32,
                      child: FilledButton(
                        onPressed: () => context.go(AppRoutes.myTrips),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: AppColors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Text(
                          context.tr('View itinerary'),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pastTrip(String image, String title, String place, Color text) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              height: 92,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w800, color: text),
          ),
          Text(place, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const Text(
            'January 2026 · 5 Days',
            style: TextStyle(fontSize: 11, color: AppColors.teal),
          ),
        ],
      );

  Widget _setting(
    String title,
    IconData icon,
    Color text, {
    Widget? trailing,
    VoidCallback? onTap,
  }) => InkWell(
    onTap: onTap,
    child: Container(
      height: 56,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE8ECEB))),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19, color: AppColors.darkTeal),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: text,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          trailing ?? const SizedBox(),
        ],
      ),
    ),
  );
}

class _ProfileTripImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..moveTo(0, 0)
    ..lineTo(size.width * .44, 0)
    ..cubicTo(
      size.width * .60,
      size.height * .18,
      size.width * .60,
      size.height * .78,
      size.width * .43,
      size.height,
    )
    ..lineTo(0, size.height)
    ..close();

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
