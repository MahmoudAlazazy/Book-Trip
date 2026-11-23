import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../router/app_router.dart';
import '../router/routes.dart';
import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({required this.selectedIndex, super.key});

  final int selectedIndex;

  static const _items = [
    (Icons.home_outlined, Icons.home, 'Home', AppRoutes.home),
    (Icons.explore_outlined, Icons.explore, 'Explore', AppRoutes.explore),
    (
      Icons.support_agent_outlined,
      Icons.support_agent,
      'Support',
      AppRoutes.supportChat,
    ),
    (Icons.bookmark_border, Icons.bookmark, 'Saved', AppRoutes.favorites),
    (Icons.person_outline, Icons.person, 'Profile', AppRoutes.profile),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = MediaQuery.sizeOf(context).width >= 900;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: wide
              ? const SizedBox.shrink(key: ValueKey('desktop-placeholder'))
              : _BottomBar(selectedIndex: selectedIndex),
        );
      },
    );
  }
}

class AppNavigationBody extends StatelessWidget {
  const AppNavigationBody({
    required this.selectedIndex,
    required this.child,
    this.backgroundImage,
    super.key,
  });
  final int selectedIndex;
  final Widget child;
  final String? backgroundImage;

  @override
  Widget build(BuildContext context) {
    final navigation = MediaQuery.sizeOf(context).width < 900
        ? child
        : Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 248,
                child: ClipRect(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    removeBottom: true,
                    child: _Sidebar(selectedIndex: selectedIndex),
                  ),
                ),
              ),
              Expanded(child: child),
            ],
          );
    if (backgroundImage == null) return navigation;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: dark ? Colors.black : Colors.transparent),
        if (!dark) Image.asset(backgroundImage!, fit: BoxFit.cover),
        navigation,
      ],
    );
  }
}

class AppWebNavigationShell extends StatelessWidget {
  const AppWebNavigationShell({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.selectedIndex});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final inactiveColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black87;
    return SafeArea(
      key: const ValueKey('bottom'),
      top: false,
      child: Container(
        height: 72,
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 5),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.grey.withValues(alpha: .45),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(AppBottomNavigationBar._items.length, (
            index,
          ) {
            final item = AppBottomNavigationBar._items[index];
            final selected = selectedIndex == index;
            return Expanded(
              child: InkWell(
                onTap: () => context.go(item.$4),
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      selected ? item.$2 : item.$1,
                      color: selected ? AppColors.teal : inactiveColor,
                      size: 21,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      context.tr(item.$3),
                      style: TextStyle(
                        color: selected ? AppColors.teal : inactiveColor,
                        fontSize: 9,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selectedIndex});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        key: const ValueKey('sidebar'),
        top: false,
        bottom: false,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 230,
            height: double.infinity,
            margin: const EdgeInsets.only(left: 18),
            decoration: BoxDecoration(
              // Keep the outer/content-facing edge straight.
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomLeft: Radius.circular(28),
              ),
              border: Border.all(
                color: dark
                    ? Colors.white.withValues(alpha: .32)
                    : AppColors.teal.withValues(alpha: .24),
                width: 1.2,
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomLeft: Radius.circular(28),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/منظر مصري حالِم_ الأهرامات وأبو الهول.webp',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      // Keep the full menu visible on shorter desktop windows.
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/شعار فرحتريب بطابع مصري.png',
                          width: 170,
                          height: 72,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 28),
                        for (final index in [0, 1, 3])
                          _SidebarItem(
                            index: index,
                            selectedIndex: selectedIndex,
                          ),
                        _SupportSidebarItem(
                          icon: Icons.luggage_outlined,
                          label: 'My Trips',
                          route: AppRoutes.myTrips,
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                          child: Divider(color: Colors.white24, height: 1),
                        ),
                        _SupportSidebarItem(
                          icon: Icons.auto_awesome,
                          label: 'FAQ',
                          route: AppRoutes.faq,
                        ),
                        _SupportSidebarItem(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: 'Chat with Support',
                          route: AppRoutes.supportChat,
                        ),
                        _SupportSidebarItem(
                          icon: Icons.mail_outline_rounded,
                          label: 'Contact Us',
                          route: AppRoutes.contactSupport,
                        ),
                        _SidebarItem(index: 4, selectedIndex: selectedIndex),
                        const Spacer(),
                        _LogoutItem(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SupportSidebarItem extends StatelessWidget {
  const _SupportSidebarItem({
    required this.icon,
    required this.label,
    required this.route,
  });
  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    final selected =
        appRouter.routerDelegate.currentConfiguration.uri.path == route;
    final color = Colors.black87;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.teal.withValues(alpha: .72)
                : Colors.transparent,
            border: Border.all(
              color: selected
                  ? Colors.white.withValues(alpha: .72)
                  : Colors.white24,
              width: selected ? 1.2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 21),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  context.tr(label),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const color = Colors.red;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => context.go(AppRoutes.login),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, color: color, size: 22),
              const SizedBox(width: 14),
              Text(
                context.tr('Log out'),
                style: const TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({required this.index, required this.selectedIndex});
  final int index;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final item = AppBottomNavigationBar._items[index];
    final selected = index == selectedIndex;
    const inactive = Colors.black87;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: selected ? 1 : 0),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutBack,
        builder: (context, value, child) =>
            Transform.translate(offset: Offset(value * 5, 0), child: child),
        child: InkWell(
          onTap: () => appRouter.go(item.$4),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.teal.withValues(alpha: .72)
                  : Colors.transparent,
              border: Border.all(
                color: selected
                    ? Colors.white.withValues(alpha: .72)
                    : Colors.white24,
                width: selected ? 1.2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  selected ? item.$2 : item.$1,
                  color: selected ? Colors.white : inactive,
                  size: 22,
                ),
                const SizedBox(width: 14),
                Text(
                  context.tr(item.$3),
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
