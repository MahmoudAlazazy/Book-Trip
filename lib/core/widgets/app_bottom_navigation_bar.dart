import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../router/app_router.dart';
import '../router/routes.dart';
import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

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

class AppNavigationBody extends StatefulWidget {
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
  State<AppNavigationBody> createState() => _AppNavigationBodyState();
}

class _AppNavigationBodyState extends State<AppNavigationBody> {
  static bool rememberedSidebarExpanded = false;
  bool sidebarExpanded = rememberedSidebarExpanded;

  @override
  Widget build(BuildContext context) {
    final navigation = MediaQuery.sizeOf(context).width < 900
        ? widget.child
        : Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 550),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.centerLeft,
                width: sidebarExpanded ? 280 : 108,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: _GlassTripSidebar(
                    selectedIndex: widget.selectedIndex,
                    onExpandedChanged: (value) => setState(() {
                      sidebarExpanded = value;
                      rememberedSidebarExpanded = value;
                    }),
                  ),
                ),
              ),
              Expanded(child: widget.child),
            ],
          );
    if (widget.backgroundImage == null) return navigation;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: dark ? Colors.black : Colors.transparent),
        if (!dark) Image.asset(widget.backgroundImage!, fit: BoxFit.cover),
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

// ===========================================================================
// BOTTOM NAVIGATION BAR (mobile) - neon LED capsule
// The LED line runs along the bottom edge and rises in a smooth hump around
// the selected item. The hump slides to the new item when the tab changes.
// ===========================================================================

const _neon = Color(0xff70f5d0);
const _neonLight = Color(0xff0fb58f);

/// LED accent: bright mint on the dark bar, deeper teal on the light bar.
Color _accentFor(bool dark) => dark ? _neon : _neonLight;

class _BottomBar extends StatefulWidget {
  const _BottomBar({required this.selectedIndex});
  final int selectedIndex;

  @override
  State<_BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<_BottomBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lightController;

  @override
  void initState() {
    super.initState();
    _lightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
  }

  @override
  void dispose() {
    _lightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final count = AppBottomNavigationBar._items.length;
    final target = widget.selectedIndex.clamp(0, count - 1).toDouble();

    return SafeArea(
      key: const ValueKey('bottom'),
      top: false,
      child: SizedBox(
        height: 82,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(end: target),
            duration: const Duration(milliseconds: 520),
            curve: Curves.easeOutCubic,
            builder: (context, position, _) {
              return AnimatedBuilder(
                animation: _lightController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _MobileNavPainter(
                      dark: dark,
                      lightProgress: _lightController.value,
                      activePosition: position,
                      itemCount: count,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(count, (index) {
                        final item = AppBottomNavigationBar._items[index];
                        final selected = widget.selectedIndex == index;
                        return Expanded(
                          child: _NavItem(
                            icon: selected ? item.$2 : item.$1,
                            label: context.tr(item.$3),
                            selected: selected,
                            dark: dark,
                            onTap: () => context.go(item.$4),
                          ),
                        );
                      }),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.dark,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inactiveColor = dark ? Colors.white70 : const Color(0xff4b5557);
    final accent = _accentFor(dark);
    final color = selected ? accent : inactiveColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      splashColor: AppColors.teal.withValues(alpha: .12),
      highlightColor: AppColors.teal.withValues(alpha: .06),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
        offset: Offset(0, selected ? -0.05 : 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Icon(
                icon,
                key: ValueKey('$label-$selected'),
                color: color,
                size: 24,
                shadows: selected
                    ? [
                        Shadow(
                          color: accent.withValues(alpha: .65),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 3),
            // Small LED dot under the icon, only for the active item.
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? accent : Colors.transparent,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: accent.withValues(alpha: .9),
                          blurRadius: 6,
                        ),
                      ]
                    : const [],
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                color: selected
                    ? (dark ? Colors.white : Colors.black87)
                    : inactiveColor,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileNavPainter extends CustomPainter {
  const _MobileNavPainter({
    required this.dark,
    required this.lightProgress,
    required this.activePosition,
    required this.itemCount,
  });

  final bool dark;
  final double lightProgress;

  /// Fractional index of the active item (animated).
  final double activePosition;
  final int itemCount;

  Shader _fadeShader(Size size, double alpha) {
    return LinearGradient(
      colors: [
        _accentFor(dark).withValues(alpha: 0),
        _accentFor(dark).withValues(alpha: alpha),
        _accentFor(dark).withValues(alpha: alpha),
        _accentFor(dark).withValues(alpha: 0),
      ],
      stops: const [0, .10, .90, 1],
    ).createShader(Offset.zero & size);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(h / 2),
    );

    // Soft drop shadow under the capsule.
    canvas.drawShadow(
      Path()..addRRect(rrect),
      dark ? Colors.black : Colors.black.withValues(alpha: .45),
      10,
      true,
    );

    // Capsule body: dark glass gradient.
    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [Color(0xff3a3536), Color(0xff1d1a1b)]
              : const [Color(0xffffffff), Color(0xffe4eaec)],
        ).createShader(Offset.zero & size),
    );

    canvas.save();
    canvas.clipRRect(rrect);

    // Neon path: flat along the bottom, with a circular dome over the active
    // item. The dome is a true circle arc (radius R) joined to the flat line by
    // two small concave fillets (radius f), so there are no sharp corners.
    const peak = 7.0; // y of the dome top
    const R = 30.0; // dome radius
    const f = 10.0; // fillet radius
    final by = h - 3.0; // y of the bottom line
    final cx = ((activePosition + .5) * w / itemCount)
        .clamp(R + 6, w - R - 6)
        .toDouble();

    final ccy = peak + R; // dome circle center y
    final fcy = by - f; // fillet circle center y
    final dy = ccy - fcy;
    final dx = math.sqrt((R + f) * (R + f) - dy * dy);
    final t = R / (R + f);
    final pL = Offset(cx - dx * t, ccy + (fcy - ccy) * t);
    final pR = Offset(cx + dx * t, pL.dy);

    Path dome(Path p) => p
      ..lineTo(cx - dx, by)
      ..arcToPoint(pL, radius: const Radius.circular(f), clockwise: false)
      ..arcToPoint(
        pR,
        radius: const Radius.circular(R),
        clockwise: true,
        largeArc: true,
      )
      ..arcToPoint(
        Offset(cx + dx, by),
        radius: const Radius.circular(f),
        clockwise: false,
      );

    final path = dome(Path()..moveTo(0, by))..lineTo(w, by);

    // Faint glow filling the inside of the dome.
    final humpArea = dome(Path()..moveTo(cx - dx, by))..close();
    canvas.drawPath(
      humpArea,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _accentFor(dark).withValues(alpha: .20),
            _accentFor(dark).withValues(alpha: .04),
          ],
        ).createShader(Rect.fromLTWH(cx - R, peak, R * 2, by - peak)),
    );

    // Wide soft glow.
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..shader = _fadeShader(size, .40)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Tighter glow.
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..shader = _fadeShader(size, .65)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Crisp neon line.
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..shader = _fadeShader(size, .95),
    );

    // A light pulse travelling along the neon tube.
    final metrics = path.computeMetrics().toList();
    if (metrics.isNotEmpty) {
      final metric = metrics.first;
      final segmentLength = metric.length * .12;
      final start = metric.length * lightProgress;
      final end = start + segmentLength;
      final movingPath = Path();

      if (end <= metric.length) {
        movingPath.addPath(metric.extractPath(start, end), Offset.zero);
      } else {
        movingPath.addPath(
          metric.extractPath(start, metric.length),
          Offset.zero,
        );
        movingPath.addPath(
          metric.extractPath(0, end - metric.length),
          Offset.zero,
        );
      }

      final pulseColor = dark ? Colors.white : const Color(0xff0a7a64);
      final pulse = .5 + (.3 * math.sin(lightProgress * math.pi * 2));
      canvas.drawPath(
        movingPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.2
          ..strokeCap = StrokeCap.round
          ..color = pulseColor.withValues(
            alpha: pulse.clamp(.15, .85).toDouble(),
          )
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawPath(
        movingPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.3
          ..strokeCap = StrokeCap.round
          ..color = pulseColor.withValues(alpha: .7),
      );
    }

    canvas.restore();

    // Thin glass outline of the capsule.
    canvas.drawRRect(
      rrect.deflate(.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = (dark ? Colors.white : Colors.black).withValues(alpha: .10),
    );
  }

  @override
  bool shouldRepaint(covariant _MobileNavPainter oldDelegate) {
    return oldDelegate.dark != dark ||
        oldDelegate.lightProgress != lightProgress ||
        oldDelegate.activePosition != activePosition ||
        oldDelegate.itemCount != itemCount;
  }
}

// ===========================================================================
// SIDEBAR (desktop) - unchanged
// ===========================================================================

class _GlassTripSidebar extends ConsumerStatefulWidget {
  const _GlassTripSidebar({
    required this.selectedIndex,
    this.onExpandedChanged,
  });
  final int selectedIndex;
  final ValueChanged<bool>? onExpandedChanged;

  @override
  ConsumerState<_GlassTripSidebar> createState() => _GlassTripSidebarState();
}

class _GlassTripSidebarState extends ConsumerState<_GlassTripSidebar> {
  static bool rememberedExpanded = false;
  bool expanded = rememberedExpanded;

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
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
        width: width,
        height: double.infinity,
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
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  if (darkMode) ...[
                    const Color(0xff6b6b6b).withValues(alpha: .92),
                    const Color(0xff292929).withValues(alpha: .96),
                    Colors.black.withValues(alpha: .99),
                  ] else ...[
                    const Color(0xffd9e6ee).withValues(alpha: .94),
                    const Color(0xff6f9ebd).withValues(alpha: .90),
                    const Color(0xff123d59).withValues(alpha: .98),
                  ],
                ],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: .28)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canShowExpanded = expanded && constraints.maxWidth >= 180;
                return canShowExpanded
                    ? _expanded(context)
                    : _collapsed(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _brand({required bool small}) => GestureDetector(
    onTap: () {
      setState(() => expanded = !expanded);
      rememberedExpanded = expanded;
      widget.onExpandedChanged?.call(expanded);
    },
    child: Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: .14),
        border: Border.all(color: Colors.white38),
      ),
      child: Image.asset(
        'assets/images/pharatrip_egyptian_logo.png',
        fit: BoxFit.contain,
      ),
    ),
  );

  Widget _collapsed(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Column(
      children: [
        _brand(small: true),
        const SizedBox(height: 18),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < _menu.length; i++) _iconItem(context, i),
              _collapsedAction(context, Icons.auto_awesome, AppRoutes.faq),
              _collapsedAction(
                context,
                Icons.chat_bubble_outline,
                AppRoutes.supportChat,
              ),
              _collapsedAction(
                context,
                Icons.mail_outline,
                AppRoutes.contactSupport,
              ),
              _collapsedAction(context, Icons.logout_rounded, AppRoutes.login),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _themeButton(compact: true),
        const SizedBox(height: 8),
        _avatar(),
      ],
    ),
  );

  Widget _iconItem(BuildContext context, int i) {
    final selected =
        appRouter.routerDelegate.currentConfiguration.uri.path == _menu[i].$3;
    return GestureDetector(
      onTap: () => appRouter.go(_menu[i].$3),
      child: Padding(
        padding: EdgeInsets.zero,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 380),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: .10),
            border: Border.all(color: Colors.white.withValues(alpha: .16)),
          ),
          child: Icon(
            _menu[i].$1,
            size: 16,
            color: selected ? const Color(0xff14204a) : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _collapsedAction(BuildContext context, IconData icon, String route) {
    return GestureDetector(
      onTap: () => appRouter.go(route),
      child: Padding(
        padding: EdgeInsets.zero,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: .10),
            border: Border.all(color: Colors.white.withValues(alpha: .16)),
          ),
          child: Icon(icon, size: 16, color: Colors.white70),
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
        _themeButton(compact: false),
        const SizedBox(height: 8),
        _support(context, Icons.logout_rounded, 'Log out', AppRoutes.login),
        const SizedBox(height: 8),
        Row(
          children: [
            _avatar(),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mahmoud Al AzaZy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Traveler',
                  style: TextStyle(color: Colors.white54, fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  Widget _row(BuildContext context, int i) {
    final selected =
        appRouter.routerDelegate.currentConfiguration.uri.path == _menu[i].$3;
    return GestureDetector(
      onTap: () => appRouter.go(_menu[i].$3),
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
            Expanded(
              child: Text(
                context.tr(label),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _themeButton({required bool compact}) {
    final dark = ref.watch(themeModeProvider) == ThemeMode.dark;
    return GestureDetector(
      onTap: () => ref
          .read(themeModeProvider.notifier)
          .setThemeMode(dark ? ThemeMode.light : ThemeMode.dark),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutBack,
        width: compact ? 38 : double.infinity,
        height: compact ? 38 : 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: dark
              ? const Color(0xffffc857).withValues(alpha: .18)
              : Colors.white.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(compact ? 20 : 14),
          border: Border.all(color: Colors.white.withValues(alpha: .20)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => RotationTransition(
            turns: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: Icon(
            dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey(dark),
            color: dark ? const Color(0xffffc857) : Colors.white70,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _avatar() => const CircleAvatar(
    radius: 17,
    backgroundImage: AssetImage('assets/images/onboarding_egypt_culture.jpg'),
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
                  const SizedBox.expand(),
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
                          width: 150,
                          height: 58,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 6),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
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