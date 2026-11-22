import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';

class ProfilePageScaffold extends StatelessWidget {
  const ProfilePageScaffold({
    required this.title,
    required this.child,
    this.selectedIndex,
    this.backgroundImage,
    this.showBottomNavigationBar = false,
    this.showSocialIcons = true,
    super.key,
  });
  final String title;
  final Widget child;
  final int? selectedIndex;
  final String? backgroundImage;
  final bool showBottomNavigationBar;
  final bool showSocialIcons;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MediaQuery.sizeOf(context).width < 900
          ? AppBar(
              title: Text(context.tr(title)),
              backgroundColor: colors.surface,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.profile);
                  }
                },
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            )
          : null,
      backgroundColor: colors.surface,
      body: AppNavigationBody(
        selectedIndex: selectedIndex ?? (title == 'Favorites' ? 3 : 4),
        backgroundImage: backgroundImage,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Material(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
                if (showSocialIcons) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _SocialIcon(
                          icon: Icons.facebook,
                          label: 'Facebook',
                        ),
                      ),
                      Expanded(
                        child: _SocialIcon(
                          icon: Icons.camera_alt_outlined,
                          label: 'Instagram',
                        ),
                      ),
                      Expanded(
                        child: _SocialIcon(
                          icon: Icons.alternate_email,
                          label: 'X',
                        ),
                      ),
                      Expanded(
                        child: _SocialIcon(
                          icon: Icons.play_circle_outline,
                          label: 'YouTube',
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: showBottomNavigationBar
          ? AppBottomNavigationBar(selectedIndex: title == 'Favorites' ? 3 : 4)
          : null,
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Tooltip(
      message: label,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: const Color(0xFFE8F1F0),
        child: Icon(icon, size: 27, color: AppColors.darkTeal),
      ),
    ),
  );
}
