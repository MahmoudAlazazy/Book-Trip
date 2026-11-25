import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({
    required this.child,
    required this.title,
    required this.message,
    super.key,
  });

  final Widget child;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // The reference theme is intentionally web-only. Native layouts keep
          // the existing PharaTrip shell and spacing.
          final desktop = kIsWeb && constraints.maxWidth >= 820;
          final content = desktop
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Login|Signup Animation',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontSize: 34,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 34),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 750,
                        maxHeight: 450,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff102a3f),
                          border: Border.all(color: AppColors.teal, width: 2),
                          boxShadow: const [
                            BoxShadow(color: Color(0x99087f8c), blurRadius: 28),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                color: const Color(0xff25252b),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    28,
                                    18,
                                    28,
                                    18,
                                  ),
                                  child: child,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: ClipPath(
                                clipper: _SlantedPanelClipper(),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    70,
                                    40,
                                    40,
                                    40,
                                  ),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff087f8c),
                                        Color(0xff075e67),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        title.toUpperCase(),
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                          height: 1.15,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        message,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: child,
                );

          return Container(
            color: desktop ? const Color(0xff071923) : Colors.white,
            alignment: Alignment.center,
            child: SafeArea(
              child: desktop ? content : SingleChildScrollView(child: content),
            ),
          );
        },
      ),
    );
  }
}

class _SlantedPanelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..moveTo(0, 0)
    ..lineTo(size.width, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(size.width * .66, size.height)
    ..close();

  @override
  bool shouldReclip(covariant _SlantedPanelClipper oldClipper) => false;
}
