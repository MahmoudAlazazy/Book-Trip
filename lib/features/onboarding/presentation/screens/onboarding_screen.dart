import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pages = [
    (
      'assets/images/onboarding_bg_egypt.png',
      'Explore Egypt\nLike Never Before',
      'Discover amazing trips and\ncreate unforgettable memories',
    ),
    (
      'assets/images/onboarding_bg_dahab.png',
      'Discover Dahab\nYour Way',
      'Relax by the sea and\nexperience unforgettable adventures',
    ),
    (
      'assets/images/onboarding_bg_temple.png',
      'Live Egypt\nLike Never Before',
      'Explore unique places and\ncreate memories that last forever',
    ),
  ];
  int _currentPage = 0;

  void _next() {
    if (_currentPage == _pages.length - 1) {
      context.go(AppRoutes.login);
    } else {
      setState(() => _currentPage++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(page.$1, fit: BoxFit.cover),
          Positioned(
            top: 48,
            right: 12,
            child: TextButton(
              onPressed: () => context.go(AppRoutes.login),
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFF10233F), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(
                context.tr('Skip'),
                style: const TextStyle(
                  color: Color(0xFF10233F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: 28,
            right: 28,
            bottom: 52,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(0, -28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr(page.$2),
                        style: GoogleFonts.arefRuqaa(
                          color: const Color(0xFF10233F),
                          fontSize: 23,
                          height: 1.1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        context.tr(page.$3),
                        style: TextStyle(
                          color: Colors.blueGrey.shade800,
                          fontSize: 14,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 7,
                      width: index == _currentPage ? 22 : 7,
                      decoration: BoxDecoration(
                        color: index == _currentPage
                            ? AppColors.teal
                            : const Color(0xFFD2E1E7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? context.tr('Get Started')
                          : '${context.tr('Next')}  →',
                      style: const TextStyle(
                        fontSize: 15,
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
    );
  }
}
