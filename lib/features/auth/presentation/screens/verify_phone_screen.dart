import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  Timer? _timer;
  final _pinController = TextEditingController();
  int _seconds = 45;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinTheme = PinTheme(
      width: 46,
      height: 52,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF10233F),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8FA8B8), width: 1.5),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/verify_phone_background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: IconButton(
                      onPressed: () => context.canPop()
                          ? context.pop()
                          : context.go(AppRoutes.login),
                      icon: const Icon(Icons.arrow_back_rounded, size: 28),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    context.tr('Verify Your Email'),
                    style: GoogleFonts.arefRuqaa(
                      color: Color(0xFF10233F),
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.tr(
                      'Enter the 6-digit code sent to\nexample@email.com',
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey.shade800,
                      fontSize: 15,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Pinput(
                    length: 6,
                    controller: _pinController,
                    defaultPinTheme: pinTheme,
                    focusedPinTheme: pinTheme.copyWith(
                      decoration: pinTheme.decoration!.copyWith(
                        border: Border.all(color: AppColors.teal, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _seconds == 0 ? _startTimer : null,
                    child: Text(
                      _seconds == 0
                          ? context.tr('Resend Code')
                          : '${context.tr('Resend Code')} (00:${_seconds.toString().padLeft(2, '0')})',
                    ),
                  ),
                  const SizedBox(height: 340),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: () async {
                        if (_pinController.text.length != 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.tr('Please enter the 6-digit code'),
                              ),
                            ),
                          );
                          return;
                        }
                        // This is only a UI demo. A production app must verify
                        // the code on the server before creating a session.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.tr(
                                'Verification is not connected to a server yet',
                              ),
                            ),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        context.tr('Verify'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
