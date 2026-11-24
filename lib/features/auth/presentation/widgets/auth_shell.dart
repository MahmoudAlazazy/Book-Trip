import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
                      color: Colors.white,
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
                        color: const Color(0xff25252b),
                        border: Border.all(
                          color: const Color(0xffe46033),
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(color: Color(0x99e46033), blurRadius: 28),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        children: [
                          Expanded(
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
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(40),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xffe46033),
                                    Color(0xff8b3825),
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
          color: desktop ? const Color(0xff1f1f29) : Colors.white,
          alignment: Alignment.center,
          child: SafeArea(
            child: desktop ? content : SingleChildScrollView(child: content),
          ),
        );
      },
    );
  }
}
