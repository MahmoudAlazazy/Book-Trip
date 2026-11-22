import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../trips/data/trip_catalog.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  int _selectedTab = 0;
  final ScrollController _tripsScrollController = ScrollController();

  @override
  void dispose() {
    _tripsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: AppNavigationBody(
        selectedIndex: -1,
        child: SafeArea(
          top: false,
          child: ResponsiveContent(
            child: ListView(
              controller: _tripsScrollController,
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 20),
              children: [
                Text(
                  context.tr('My Egyptian Trips'),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.arefRuqaa(
                    color: AppColors.darkTeal,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.tr(
                    'Follow your upcoming adventures and get ready to discover Egypt',
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: List.generate(3, (index) {
                    final labels = ['Upcoming', 'Past', 'Canceled'];
                    final selected = _selectedTab == index;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index == 2 ? 0 : 8),
                        child: ChoiceChip(
                          label: Center(
                            child: Text(
                              context.tr(labels[index]),
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : colors.onSurface,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _selectedTab = index),
                          selectedColor: AppColors.teal,
                          backgroundColor: colors.surfaceContainerHighest,
                          side: BorderSide(
                            color: selected ? AppColors.teal : colors.outline,
                          ),
                          shape: const StadiumBorder(),
                          showCheckmark: false,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                if (_selectedTab == 0)
                  AnimatedBuilder(
                    animation: _tripsScrollController,
                    builder: (context, _) => Column(
                      children: TripCatalog.all.asMap().entries.map((entry) {
                        final trip = entry.value;
                        final startDate = DateTime.now().add(
                          Duration(days: entry.key == 0 ? -1 : entry.key * 7),
                        );
                        final cardCenter = entry.key * 170.0 + 82;
                        final viewportCenter =
                            MediaQuery.sizeOf(context).height / 2;
                        final distance =
                            (cardCenter -
                                    _tripsScrollController.offset -
                                    viewportCenter)
                                .abs();
                        final focus = (1 - distance / viewportCenter).clamp(
                          0.0,
                          1.0,
                        );
                        final isCentered = focus > .72;
                        return Transform.scale(
                          scale: isCentered ? 1.04 : 1.0,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _UpcomingTripCard(
                              id: trip.id,
                              title: trip.title,
                              date: '${trip.duration} · ${trip.location}',
                              image: trip.image,
                              startDate: startDate,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                else
                  _EmptyTrips(
                    label: _selectedTab == 1
                        ? context.tr('No past trips yet')
                        : context.tr('No canceled trips'),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(selectedIndex: 1),
    );
  }
}

class _UpcomingTripCard extends StatelessWidget {
  const _UpcomingTripCard({
    this.id = 'giza-pyramids',
    this.startDate,
    this.title = 'Giza Pyramids Tour',
    this.date = 'Sat, Nov 15, 2025',
    this.image = 'assets/images/pyramids.jpg',
  });
  final String title;
  final String id;
  final DateTime? startDate;
  final String date;
  final String image;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      clipBehavior: Clip.none,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/trip/$id'),
        child: SizedBox(
          height: 170,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: ClipPath(
                  clipper: _MyTripImageClipper(),
                  child: AppImage(asset: image),
                ),
              ),
              Positioned(
                left: MediaQuery.sizeOf(context).width >= 900
                    ? MediaQuery.sizeOf(context).width * .42
                    : (ResponsiveLayout.isTablet(context)
                          ? 190
                          : MediaQuery.sizeOf(context).width * .55),
                right: MediaQuery.sizeOf(context).width >= 900 ? 28 : 4,
                top: 18,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(title),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).width >= 900
                            ? 26
                            : 20,
                        height: 1.05,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _formattedStartDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      date
                          .replaceAll('1 Day', context.tr('1 Day'))
                          .replaceAll('2 Days', context.tr('2 Days'))
                          .replaceAll('3 Days', context.tr('3 Days'))
                          .replaceAll('4 Days', context.tr('4 Days'))
                          .replaceAll('Giza', context.tr('Giza'))
                          .replaceAll('Dahab', context.tr('Dahab'))
                          .replaceAll('Siwa', context.tr('Siwa'))
                          .replaceAll('Luxor', context.tr('Luxor'))
                          .replaceAll('Hurghada', context.tr('Hurghada')),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 30,
                      child: FilledButton(
                        onPressed: () => _canTrack
                            ? context.push('/track/booking-demo')
                            : context.push('/trip/$id'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: AppColors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Text(
                          context.tr(
                            _canTrack ? 'Track Trip' : 'View itinerary',
                          ),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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

  bool get _canTrack =>
      startDate != null && !DateTime.now().isBefore(startDate!);

  String get _formattedStartDate {
    if (startDate == null) return date;
    return '${startDate!.day.toString().padLeft(2, '0')}/${startDate!.month.toString().padLeft(2, '0')}/${startDate!.year}';
  }
}

class _MyTripImageClipper extends CustomClipper<Path> {
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

class _EmptyTrips extends StatelessWidget {
  const _EmptyTrips({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 300,
    child: Center(
      child: Text(
        label,
        style: TextStyle(
          color: Colors.blueGrey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
