import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/trip_catalog.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({required this.id, super.key});
  final String id;

  @override
  Widget build(BuildContext context) {
    final trip =
        TripCatalog.detailsById[id] ??
        TripCatalog.detailsById['red-sea-getaway']!;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 290,
            pinned: true,
            backgroundColor: colors.surfaceContainerHighest,
            foregroundColor: colors.onSurface,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: .92),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: .92),
                  child: const _FavoriteAction(),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _TripGallery(images: trip.images),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 112),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr(trip.title),
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF4DD0C5)
                          : const Color(0xFF10233F),
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFF4B900),
                        size: 18,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${trip.rating} (${trip.reviews} ${context.tr('reviews')})',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${context.tr('Starts')} ${_detailsStartDate(trip.title)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoItem(
                        icon: Icons.calendar_month_outlined,
                        value: context.tr(trip.duration),
                      ),
                      _InfoItem(
                        icon: Icons.location_on_outlined,
                        value: context.tr(trip.from),
                      ),
                      _InfoItem(
                        icon: Icons.groups_outlined,
                        value: '${context.tr('Max')} ${trip.maxPeople}',
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  Text(
                    context.tr('About This Trip'),
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF4DD0C5)
                          : const Color(0xFF10233F),
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    context.tr(trip.description),
                    style: const TextStyle(fontSize: 13, height: 1.35),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    context.tr('Trip Highlights'),
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF4DD0C5)
                          : const Color(0xFF10233F),
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ...trip.highlights.map(
                    (highlight) => _Highlight(text: context.tr(highlight)),
                  ),
                  if (trip.hotelName != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      context.tr('Hotel Details'),
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF4DD0C5)
                            : const Color(0xFF10233F),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.hotel_outlined,
                          color: AppColors.teal,
                          size: 21,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${context.tr(trip.hotelName!)}\n${context.tr(trip.hotelDetails!)}',
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    '${trip.price} / ${context.tr('Person')}',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF4DD0C5)
                          : const Color(0xFF10233F),
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: FilledButton(
              onPressed: () =>
                  context.push('/booking/transport', extra: trip.images.first),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.teal,
                shape: const StadiumBorder(),
              ),
              child: Text(
                context.tr('Book Now'),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _detailsStartDate(String title) {
  final date = DateTime.now().add(
    Duration(days: (title.hashCode.abs() % 14) + 1),
  );
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _TripGallery extends StatefulWidget {
  const _TripGallery({required this.images});
  final List<String> images;

  @override
  State<_TripGallery> createState() => _TripGalleryState();
}

class _TripGalleryState extends State<_TripGallery> {
  int _index = 0;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      PageView.builder(
        itemCount: widget.images.length,
        onPageChanged: (index) => setState(() => _index = index),
        itemBuilder: (_, index) =>
            Image.asset(widget.images[index], fit: BoxFit.cover),
      ),
      Positioned(
        bottom: 12,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: index == _index ? 18 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: index == _index ? Colors.white : Colors.white54,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.icon, required this.value});
  final IconData icon;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, color: AppColors.teal, size: 22),
      const SizedBox(height: 3),
      Text(
        value,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ],
  );
}

class _Highlight extends StatelessWidget {
  const _Highlight({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 3),
    child: Row(
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF78B929), size: 18),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    ),
  );
}

class _FavoriteAction extends ConsumerWidget {
  const _FavoriteAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    const tripId = 'current-trip';
    final isFavorite = favorites.contains(tripId);
    return Container(
      width: 30,
      height: 28,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 30, height: 28),
        tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
        onPressed: () {
          final next = {...favorites};
          if (isFavorite) {
            next.remove(tripId);
          } else {
            next.add(tripId);
          }
          ref.read(favoritesProvider.notifier).state = next;
        },
        icon: Icon(
          isFavorite ? Icons.bookmark : Icons.bookmark_border_rounded,
          color: Theme.of(context).colorScheme.onSurface,
          size: 20,
        ),
      ),
    );
  }
}
