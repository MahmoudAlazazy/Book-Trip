import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/auth/auth_session.dart';
import '../../../../core/widgets/responsive_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirectAfterSplash();
  }

  Future<void> _redirectAfterSplash() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    final loggedIn = await AuthSession.isLoggedIn();
    if (!mounted) return;
    context.go(loggedIn ? AppRoutes.home : AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isTablet(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/phara_trip_splash.png',
          // This asset includes the full logo and boat composition; cover
          // crops those elements on the wide aspect ratio used by browsers.
          fit: isWeb ? BoxFit.contain : BoxFit.cover,
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
