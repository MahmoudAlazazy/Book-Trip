import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../data/trip_catalog.dart';
import '../../domain/entities/trip.dart';

class AvailableTripsScreen extends StatelessWidget {
  const AvailableTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: AppNavigationBody(
        selectedIndex: 1,
        child: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight),
          child: ResponsiveContent(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final count = ResponsiveLayout.columns(
                  constraints.maxWidth,
                  max: 3,
                );
                return ListView(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 24),
                  children: [
                    Text(
                      context.tr('Available Trips'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.tr('Choose your next Egyptian adventure'),
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (count == 1)
                      ...TripCatalog.all.map(
                        (trip) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _AvailableTripCard(trip: trip),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: TripCatalog.all.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: count,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          mainAxisExtent: 250,
                        ),
                        itemBuilder: (context, index) =>
                            _AvailableTripCard(trip: TripCatalog.all[index]),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(selectedIndex: 1),
    );
  }
}

class _AvailableTripCard extends StatelessWidget {
  const _AvailableTripCard({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: .10),
      clipBehavior: Clip.none,
      child: InkWell(
        onTap: () => context.push('/trip/${trip.id}'),
        child: SizedBox(
          height: isWide
              ? 250
              : (ResponsiveLayout.isTablet(context) ? 220 : 172),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: ClipPath(
                  clipper: _TripImageClipper(),
                  child: AppImage(asset: trip.image),
                ),
              ),
              Positioned(
                left: 0,
                top: -2,
                child: Container(
                  width: 30,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: .92),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border_rounded),
                    color: colors.onSurface,
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 30,
                      height: 28,
                    ),
                    tooltip: 'Save',
                  ),
                ),
              ),
              Positioned(
                left: isWide
                    ? 230
                    : (ResponsiveLayout.isTablet(context)
                          ? 190
                          : MediaQuery.sizeOf(context).width * .55),
                right: isWide ? 20 : 4,
                top: isWide ? 18 : 8,
                bottom: isWide ? 12 : 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(trip.title),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 21,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${context.tr('From Cairo')}  |  ${context.tr(trip.duration)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${context.tr('Starts')} ${_tripStartDate(trip.id)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${trip.price} / ${context.tr('Person')}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF4DD0C5)
                            : colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Spacer(),
                        FilledButton(
                          onPressed: () => context.push('/trip/${trip.id}'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: AppColors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                          ),
                          child: Text(
                            context.tr('View Details'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _tripStartDate(String id) {
  final date = DateTime.now().add(Duration(days: (id.hashCode.abs() % 14) + 1));
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _TripImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..moveTo(0, 0)
    ..lineTo(size.width * .44, 0)
    ..cubicTo(
      size.width * .60,
      size.height * .18,
      size.width * .60,
      size.height * .78,
      size.width * .43,
      size.height,
    )
    ..lineTo(0, size.height)
    ..close();

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
