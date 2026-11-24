import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 820;
        final content = desktop
            ? ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 980,
                  maxHeight: 650,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff102a3f),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.teal, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x55087F8C),
                        blurRadius: 32,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(42),
                          child: child,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(46),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff087f8c), Color(0xff075e67)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.travel_explore_rounded,
                                color: Colors.white,
                                size: 64,
                              ),
                              const SizedBox(height: 24),
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
                    ],
                  ),
                ),
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
    );
  }
}
