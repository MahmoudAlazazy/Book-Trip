import 'package:flutter/material.dart';

/// Shared breakpoints keep web layouts readable without changing the mobile UI.
class AppBreakpoints {
  static const tablet = 700.0;
  static const desktop = 1100.0;
}

class ResponsiveLayout {
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop;

  static int columns(double width, {int max = 4}) {
    if (width >= 1400) return max;
    if (width >= 1100) return max > 3 ? 3 : max;
    if (width >= 700) return 2;
    return 1;
  }
}

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    required this.child,
    this.maxWidth = 1200,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final wide = ResponsiveLayout.isTablet(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: wide ? 28 : 16),
          child: child,
        ),
      ),
    );
  }
}

class AppImage extends StatelessWidget {
  const AppImage({
    required this.asset,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.cacheWidth,
    this.cacheHeight,
    super.key,
  });

  final String asset;
  final BoxFit fit;
  final Alignment alignment;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: fit,
      alignment: alignment,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      errorBuilder: (context, error, stackTrace) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(child: Icon(Icons.image_not_supported_outlined)),
      ),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
          frame == null && !wasSynchronouslyLoaded
          ? const ColoredBox(
              color: Color(0xFFECEFED),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          : child,
    );
  }
}
