import 'dart:ui';

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
                width: 280,
                child: ClipRect(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    removeBottom: true,
                    child: _GlassTripSidebar(selectedIndex: selectedIndex),
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

class _GlassTripSidebar extends StatefulWidget {
  const _GlassTripSidebar({required this.selectedIndex});
  final int selectedIndex;

  @override
  State<_GlassTripSidebar> createState() => _GlassTripSidebarState();
}

class _GlassTripSidebarState extends State<_GlassTripSidebar> {
  bool expanded = true;

  static const _menu = [
    (Icons.home_outlined, 'Home', AppRoutes.home),
    (Icons.explore_outlined, 'Explore', AppRoutes.explore),
    (Icons.bookmark_border, 'Saved', AppRoutes.favorites),
    (Icons.luggage_outlined, 'My Trips', AppRoutes.myTrips),
    (Icons.person_outline, 'Profile', AppRoutes.profile),
  ];

  @override
  Widget build(BuildContext context) {
    final width = expanded ? 252.0 : 68.0;
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
        width: width,
        height: expanded ? 640 : 580,
        margin: const EdgeInsets.only(left: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(
              color: Color(0x77000000),
              blurRadius: 40,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: .22),
                    const Color(0xff2a4a9a).withValues(alpha: .45),
                    const Color(0xff0b1a4a).withValues(alpha: .88),
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: .28)),
              ),
              child: expanded ? _expanded(context) : _collapsed(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _brand({required bool small}) => GestureDetector(
    onTap: () => setState(() => expanded = !expanded),
    child: Container(
      width: small ? 38 : 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: .14),
        border: Border.all(color: Colors.white38),
      ),
      child: const Icon(Icons.travel_explore, color: Colors.white, size: 18),
    ),
  );

  Widget _collapsed(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Column(
      children: [
        _brand(small: true),
        const SizedBox(height: 12),
        const Icon(Icons.search, color: Colors.white70, size: 20),
        const SizedBox(height: 14),
        for (var i = 0; i < _menu.length; i++) _iconItem(context, i),
        const Spacer(),
        _avatar(),
      ],
    ),
  );

  Widget _iconItem(BuildContext context, int i) {
    final selected = widget.selectedIndex == i;
    return GestureDetector(
      onTap: () => context.go(_menu[i].$3),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 380),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: .10),
            border: Border.all(color: Colors.white.withValues(alpha: .16)),
          ),
          child: Icon(
            _menu[i].$1,
            size: 19,
            color: selected ? const Color(0xff14204a) : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _expanded(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(10, 12, 8, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _brand(small: false),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PharaTrip',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Explore Egypt',
                    style: TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => expanded = false),
              child: const Icon(Icons.chevron_left, color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white24),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, size: 16, color: Colors.white54),
              SizedBox(width: 8),
              Text(
                'Search trips...',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        for (var i = 0; i < _menu.length; i++) _row(context, i),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(color: Colors.white24),
        ),
        _support(context, Icons.auto_awesome, 'FAQ', AppRoutes.faq),
        _support(
          context,
          Icons.chat_bubble_outline,
          'Chat with Support',
          AppRoutes.supportChat,
        ),
        _support(
          context,
          Icons.mail_outline,
          'Contact Us',
          AppRoutes.contactSupport,
        ),
        const Spacer(),
        _support(context, Icons.logout_rounded, 'Log out', AppRoutes.login),
      ],
    ),
  );

  Widget _row(BuildContext context, int i) {
    final selected = widget.selectedIndex == i;
    return GestureDetector(
      onTap: () => context.go(_menu[i].$3),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 380),
        height: 40,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : Colors.white24,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _menu[i].$1,
              size: 17,
              color: selected ? const Color(0xff14204a) : Colors.white70,
            ),
            const SizedBox(width: 10),
            Text(
              context.tr(_menu[i].$2),
              style: TextStyle(
                color: selected ? const Color(0xff14204a) : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _support(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: .18)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 21, color: Colors.white),
            const SizedBox(width: 14),
            Text(context.tr(label), style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    ),
  );

  Widget _avatar() => Container(
    width: 34,
    height: 34,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(colors: [Color(0xffffb38a), Color(0xffff7a59)]),
    ),
    child: const Text(
      'A',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    ),
  );
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selectedIndex});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        key: const ValueKey('sidebar'),
        top: false,
        bottom: false,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 252,
            height: double.infinity,
            margin: const EdgeInsets.only(left: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xff173d70).withValues(alpha: .92),
                  const Color(0xff123b72).withValues(alpha: .78),
                  const Color(0xff07152f).withValues(alpha: .96),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: .25),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55000000),
                  blurRadius: 28,
                  offset: Offset(8, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: const SizedBox.expand(),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: .08),
                          Colors.transparent,
                          Colors.black.withValues(alpha: .22),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/منظر مصري حالِم_ الأهرامات وأبو الهول.webp',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xee123c59), Color(0xf5071923)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
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
                          'assets/images/pharatrip_egyptian_logo.png',
                          width: 170,
                          height: 72,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 36,
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: .16),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.search,
                                size: 16,
                                color: Colors.white60,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Search trips...',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
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
    const color = Colors.white;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: .08),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: .16),
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
                    color: selected ? const Color(0xff14204a) : color,
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
    const inactive = Colors.white70;
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
                  ? Colors.white
                  : Colors.white.withValues(alpha: .08),
              border: Border.all(
                color: selected
                    ? Colors.transparent
                    : Colors.white.withValues(alpha: .16),
                width: selected ? 1.2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  selected ? item.$2 : item.$1,
                  color: selected ? const Color(0xff14204a) : inactive,
                  size: 22,
                ),
                const SizedBox(width: 14),
                Text(
                  context.tr(item.$3),
                  style: TextStyle(
                    color: selected ? const Color(0xff10233f) : inactive,
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
