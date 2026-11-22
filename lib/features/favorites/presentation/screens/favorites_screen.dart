import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../trips/data/trip_catalog.dart';
import '../../../trips/domain/entities/trip.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<({String name, List<String> trips})> _customCollections = [];
  final ScrollController _recentlyViewedController = ScrollController();
  final ScrollController _allSavedController = ScrollController();

  @override
  void dispose() {
    _recentlyViewedController.dispose();
    _allSavedController.dispose();
    super.dispose();
  }

  Future<void> _createCollection() async {
    var collectionName = '';
    final selected = <String>{};
    final result = await showDialog<({String name, List<String> trips})>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.tr('New Collection')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) => collectionName = value,
                  decoration: InputDecoration(
                    labelText: context.tr('Collection name'),
                  ),
                ),
                ...TripCatalog.all.map((trip) {
                  final isSelected = selected.contains(trip.id);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: isSelected ? 3 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? AppColors.teal : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => setDialogState(
                        () => isSelected
                            ? selected.remove(trip.id)
                            : selected.add(trip.id),
                      ),
                      child: SizedBox(
                        height: 92,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              height: double.infinity,
                              child: Image.asset(trip.image, fit: BoxFit.cover),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trip.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${trip.location}  •  ${trip.duration}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      trip.price,
                                      style: const TextStyle(
                                        color: AppColors.teal,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Checkbox(
                              value: isSelected,
                              onChanged: (value) => setDialogState(
                                () => value == true
                                    ? selected.add(trip.id)
                                    : selected.remove(trip.id),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.tr('Cancel')),
            ),
            FilledButton(
              onPressed: () {
                if (collectionName.trim().isNotEmpty && selected.isNotEmpty) {
                  Navigator.pop(context, (
                    name: collectionName.trim(),
                    trips: selected.toList(),
                  ));
                }
              },
              child: Text(context.tr('Create')),
            ),
          ],
        ),
      ),
    );
    if (result != null) setState(() => _customCollections.add(result));
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = dark ? Colors.white : const Color(0xFF17232A);
    return Scaffold(
      backgroundColor: dark ? const Color(0xFF101615) : Colors.white,
      body: AppNavigationBody(
        selectedIndex: 3,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
            children: [
              Text(
                context.tr('My Saved Places'),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.arefRuqaa(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkTeal,
                ),
              ),
              Text(
                context.tr('Your favorite destinations and travel plans'),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 14,
                  color: dark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 25),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.55,
                children: [
                  _stat('10', context.tr('Saved Destinations'), text),
                  _stat('20', context.tr('Completed Trips'), AppColors.teal),
                  _stat(
                    '2',
                    context.tr('Planned Trips'),
                    const Color(0xFFE3A34E),
                  ),
                  _stat('30', context.tr('Places Visited'), text),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('My Collections'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: text,
                    ),
                  ),
                  GestureDetector(
                    onTap: _createCollection,
                    child: Text(
                      '+ ${context.tr('New Collection')}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.teal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...[
                (
                  'assets/images/onboarding_bg_dahab.png',
                  'Dream Destinations',
                  '5 Places',
                ),
                ('assets/images/pyramids_2.jpg', 'Hidden Gems', '7 Places'),
                ('assets/images/red_sea.jpg', 'Weekend Getaways', '10 Places'),
                (
                  'assets/images/onboarding_bg_temple.png',
                  'Trekking Bucket List',
                  '6 Places',
                ),
              ].map(
                (item) => _collection(context, item.$1, item.$2, item.$3, text),
              ),
              ..._customCollections.map((collection) {
                final trip = TripCatalog.all.firstWhere(
                  (item) => item.id == collection.trips.first,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _collection(
                      context,
                      trip.image,
                      collection.name,
                      '${collection.trips.length} Places',
                      text,
                    ),
                    ...collection.trips.map((id) {
                      final selectedTrip = TripCatalog.all.firstWhere(
                        (item) => item.id == id,
                      );
                      return _savedTripCard(context, selectedTrip, text);
                    }),
                    const SizedBox(height: 8),
                  ],
                );
              }),
              const SizedBox(height: 20),
              Text(
                context.tr('Recently Viewed'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: text,
                ),
              ),
              const SizedBox(height: 10),
              _horizontalCards(context, text, _recentlyViewedController, [
                ('assets/images/onboarding_egypt_heritage.jpg', 'Luxor Valley'),
                ('assets/images/siwa.jpg', 'Siwa Oasis'),
              ]),
              const SizedBox(height: 22),
              Text(
                context.tr('All Saved'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: text,
                ),
              ),
              const SizedBox(height: 10),
              _horizontalCards(context, text, _allSavedController, [
                ('assets/images/red_sea.jpg', 'Red Sea Getaway'),
                ('assets/images/onboarding_bg_temple.png', 'Luxor Valley'),
              ]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(selectedIndex: 3),
    );
  }

  Widget _stat(String value, String label, Color color) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        value,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
    ],
  );
  Widget _collection(
    BuildContext context,
    String image,
    String title,
    String places,
    Color text,
  ) => Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.sizeOf(context).width >= 800 ? 20 : 14,
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Image.asset(
            image,
            width: MediaQuery.sizeOf(context).width >= 800 ? 210 : 138,
            height: MediaQuery.sizeOf(context).width >= 800 ? 120 : 88,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: MediaQuery.sizeOf(context).width >= 800 ? 18 : 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr(title),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: MediaQuery.sizeOf(context).width >= 800 ? 20 : null,
                  color: text,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                places.replaceAll('Places', context.tr('Places')),
                style: const TextStyle(fontSize: 10),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).width >= 800 ? 12 : 9,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).width >= 800 ? 36 : 29,
                width: MediaQuery.sizeOf(context).width >= 800 ? 123 : 98,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    context.tr('View Places'),
                    style: TextStyle(
                      fontSize: MediaQuery.sizeOf(context).width >= 800
                          ? 12
                          : 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _savedTripCard(BuildContext context, Trip trip, Color text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: () => context.push('/trip/${trip.id}'),
        child: SizedBox(
          height: 112,
          child: Row(
            children: [
              SizedBox(
                width: 120,
                height: double.infinity,
                child: Image.asset(trip.image, fit: BoxFit.cover),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr(trip.title),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${trip.location}  •  ${trip.duration}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: SizedBox(
                          height: 27,
                          child: FilledButton(
                            onPressed: () => context.push('/trip/${trip.id}'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              context.tr('View Details'),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
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
    ),
  );
  Widget _horizontalCards(
    BuildContext context,
    Color text,
    ScrollController controller,
    List<(String, String)> cards,
  ) => SizedBox(
    height: MediaQuery.sizeOf(context).width >= 800 ? 270 : 216,
    child: AnimatedBuilder(
      animation: controller,
      builder: (context, _) => ListView.separated(
        controller: controller,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        itemCount: cards.length,
        separatorBuilder: (_, _) => const SizedBox(width: 24),
        itemBuilder: (_, i) {
          final isWeb = MediaQuery.sizeOf(context).width >= 800;
          final cardWidth = isWeb ? 270.0 : 215.0;
          final cardCenter = 4 + i * (cardWidth + 24) + cardWidth / 2;
          final viewportCenter = MediaQuery.sizeOf(context).width / 2;
          final distance = (cardCenter - controller.offset - viewportCenter)
              .abs();
          final focus = (1 - distance / (viewportCenter + cardWidth)).clamp(
            0.0,
            1.0,
          );
          final isCentered = focus > .72;
          final scale = isCentered ? 1.06 : 1.0;
          return SizedBox(
            width: cardWidth,
            child: Transform.scale(
              scale: scale,
              child: Transform.translate(
                offset: Offset.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        cards[i].$1,
                        width: cardWidth,
                        height: isWeb ? 140 : 112,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      context.tr(cards[i].$2),
                      style: TextStyle(
                        fontSize: isWeb ? 20 : 16,
                        fontWeight: FontWeight.w800,
                        color: text,
                      ),
                    ),
                    const Text(
                      'ðŸ“ Kullu District',
                      style: TextStyle(fontSize: 10, color: Colors.transparent),
                    ),
                    Text(
                      context.tr('Kullu District'),
                      style: TextStyle(
                        fontSize: isWeb ? 12 : 10,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '\u2605\u2605\u2605\u2605',
                          style: TextStyle(
                            color: Color(0xFFE59B38),
                            fontSize: isWeb ? 16 : 13,
                          ),
                        ),
                        Text(
                          ' 4.9',
                          style: TextStyle(fontSize: isWeb ? 12 : 10),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: isWeb ? 32 : 25,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: isWeb ? 16 : 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              context.tr('View Details'),
                              style: TextStyle(fontSize: isWeb ? 11 : 9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
