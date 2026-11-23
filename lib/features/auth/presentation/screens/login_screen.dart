import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/auth/auth_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/login_background_islamic.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomInset),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 44,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _BrandHeader(),
                      const SizedBox(height: 28),
                      Text(
                        context.tr('Welcome Back!'),
                        style: GoogleFonts.arefRuqaa(
                          color: Color(0xFF10233F),
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.tr('Sign in to continue'),
                        style: TextStyle(
                          color: Colors.blueGrey.shade700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 22),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        decoration: InputDecoration(
                          hintText: context.tr('Email Address'),
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        autofillHints: const [AutofillHints.password],
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: context.tr('Password'),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () => context.go(AppRoutes.reset),
                          child: Text(
                            context.tr('Forgot Password?'),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton(
                          onPressed: () async {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text;
                            final emailIsValid = RegExp(
                              r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                            ).hasMatch(email);
                            if (!emailIsValid || password.length < 8) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    context.tr(
                                      'Please enter your email and password',
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }
                            final router = GoRouter.of(context);
                            await AuthSession.markLoggedIn();
                            if (mounted) router.go(AppRoutes.home);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            context.tr('Sign In'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _OrDivider(),
                      const SizedBox(height: 14),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialButton(asset: 'assets/images/google_logo.svg'),
                          SizedBox(width: 12),
                          _SocialButton(asset: 'assets/images/apple_logo.svg'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            context.tr("Don't have an account? "),
                            style: TextStyle(color: Colors.blueGrey.shade700),
                          ),
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.signup),
                            child: Text(
                              context.tr('Sign Up'),
                              style: const TextStyle(
                                color: AppColors.darkTeal,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Image.asset(
        'assets/images/pharatrip_egyptian_logo.png',
        width: 220,
        height: 100,
        fit: BoxFit.contain,
      ),
      const SizedBox(height: 2),
      Text(
        context.tr('Travel Within Egypt'),
        style: const TextStyle(
          color: Color(0xFF10233F),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider()),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          context.tr('or continue with'),
          style: TextStyle(color: Colors.blueGrey),
        ),
      ),
      const Expanded(child: Divider()),
    ],
  );
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.asset});
  final String asset;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 74,
    height: 46,
    child: OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
      child: SvgPicture.asset(asset, width: 22, height: 22),
    ),
  );
}
