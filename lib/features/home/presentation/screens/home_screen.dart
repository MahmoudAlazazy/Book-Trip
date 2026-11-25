import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../notifications/presentation/providers/notifications_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Set<String> _activeFilters = {};
  String? _activeCategory;
  int? _flippedDistrictIndex;
  final ScrollController _districtScrollController = ScrollController();
  

  @override
  void dispose() {
    _districtScrollController.dispose();
    super.dispose();
  }

  bool _visible(List<String> tags) =>
      (_activeFilters.isEmpty || _activeFilters.any(tags.contains)) &&
      (_activeCategory == null || tags.contains(_activeCategory));

  Future<Set<String>?> _showFilters(BuildContext context) {
    const filterGroups = <String, List<String>>{
      'Destination Type': [
        'Scenic Viewpoints',
        'Waterfalls',
        'Lakes',
        'Homestays',
        'Temples',
        'Trekking',
        'Adventure',
        'Apple orchards',
        'Mountains',
      ],
      'District': ['Giza', 'Luxor', 'Hurghada', 'Siwa', 'Dahab'],
      'Crowd Level': ['Quiet', 'Moderate', 'Busy'],
      'Travel Season': ['Monsoon', 'Winter', 'Summer'],
      'Road Condition': ['Easy Access', 'Moderate Road', 'Off-road'],
      'Weather Preferences': ['Sunny', 'Mild', 'Cool'],
    };
    var selectedCategory = 'Destination Type';
    final options = <String>{..._activeFilters};
    return showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final filterOptions = filterGroups[selectedCategory]!;
          return Container(
            height: MediaQuery.sizeOf(context).height * .72,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border.fromBorderSide(
                BorderSide(color: Color(0xFFD6D6D6)),
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      context.tr('Filters'),
                      style: TextStyle(
                        color: AppColors.darkTeal,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => setSheetState(options.clear),
                      child: Text(
                        context.tr('Reset'),
                        style: TextStyle(color: AppColors.teal),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 126,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  [
                                        'Destination Type',
                                        'District',
                                        'Crowd Level',
                                        'Travel Season',
                                        'Road Condition',
                                        'Weather Preferences',
                                      ]
                                      .map(
                                        (x) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 24,
                                          ),
                                          child: GestureDetector(
                                            onTap: () => setSheetState(
                                              () => selectedCategory = x,
                                            ),
                                            child: Text(
                                              context.tr(x),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight:
                                                    selectedCategory == x
                                                    ? FontWeight.w800
                                                    : FontWeight.w600,
                                                color: selectedCategory == x
                                                    ? AppColors.teal
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            children: ['Select All', ...filterOptions]
                                .map(
                                  (x) => CheckboxListTile(
                                    dense: true,
                                    visualDensity: VisualDensity.compact,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    title: Text(
                                      context.tr(x),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    value: x == 'Select All'
                                        ? options.length == filterOptions.length
                                        : options.contains(x),
                                    activeColor: AppColors.teal,
                                    onChanged: (value) => setSheetState(() {
                                      if (x == 'Select All') {
                                        if (value == true) {
                                          options.addAll(filterOptions);
                                        } else {
                                          options.clear();
                                        }
                                      } else if (value == true) {
                                        options.add(x);
                                      } else {
                                        options.remove(x);
                                      }
                                    }),
                                  ),
                                )
                                .map(
                                  (tile) => Material(
                                    color: Colors.transparent,
                                    child: tile,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.darkTeal,
                          side: const BorderSide(color: Color(0xFFD6D6D6)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(context.tr('Close')),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(sheetContext, options);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D493D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(context.tr('Apply Filters')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = dark ? Colors.white : const Color(0xFF17232A);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: dark ? const Color(0xFF101615) : Colors.white,
      body: AppNavigationBody(
        selectedIndex: 0,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
          ),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              children: [
                _hero(context),
                ResponsiveContent(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 2, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _search(context),
                        const SizedBox(height: 15),
                        Transform.translate(
                          offset: const Offset(0, -15),
                          child: SizedBox(
                            height: 34,
                            child: Row(
                              children:
                                  [
                                    'Mountains',
                                    'Homestays',
                                    'Trekking',
                                    'Camping',
                                    'Temples',
                                  ].map((x) {
                                    final selected = _activeCategory == x;
                                    return Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: x == 'Temples' ? 0 : 8,
                                        ),
                                        child: InkWell(
                                          onTap: () => setState(
                                            () => _activeCategory = selected
                                                ? null
                                                : x,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 8,
                                            ),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppColors.teal,
                                              border: Border.all(
                                                color: selected
                                                    ? Colors.white
                                                    : AppColors.darkTeal,
                                                width: selected ? 1.5 : 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: Text(
                                              context.tr(x),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                        Text(
                          context.tr('District Explorer'),
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: text,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _districts(context, text),
                        const SizedBox(height: 25),
                        Text(
                          context.tr('Trending Now'),
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: text,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _trending(context, text),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(selectedIndex: 0),
    );
  }

  Widget _hero(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = width >= AppBreakpoints.desktop
        ? 420.0
        : (width * .62).clamp(225.0, 340.0);
    final unreadCount = ref.watch(unreadNotificationsProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -108,
            right: 0,
            top: 0,
            bottom: 0,
            child: AppImage(
              asset: 'assets/images/Golden Sunset Over the Pyramids.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              cacheWidth: 1400,
            ),
          ),
          Positioned(
            left: -108,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xBB000000)],
                ),
              ),
            ),
          ),
          Positioned(
            top: 42,
            left: 18,
            child: Material(
              color: Colors.white.withValues(alpha: .92),
              shape: const CircleBorder(),
              elevation: 3,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    tooltip: 'Notifications',
                    onPressed: () => context.push(AppRoutes.notifications),
                    constraints: const BoxConstraints.tightFor(
                      width: 40,
                      height: 40,
                    ),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.darkTeal,
                      size: 21,
                    ),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      top: -4,
                      left: -4,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          border: Border.all(color: Colors.white, width: 1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          unreadCount > 99 ? '99+' : '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            left: isArabic ? null : 20,
            right: isArabic ? 20 : null,
            bottom: height * .23,
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Explore\nEgypt'),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: GoogleFonts.arefRuqaa(
                    color: Colors.white,
                    fontSize: MediaQuery.sizeOf(context).width >= 900 ? 38 : 30,
                    height: 1.12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  context.tr('243 Destinations await you'),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: GoogleFonts.arefRuqaa(
                    color: Colors.white,
                    fontSize: MediaQuery.sizeOf(context).width >= 900 ? 17 : 14,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _search(BuildContext context) => Transform.translate(
    offset: const Offset(0, -22),
    child: Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8)],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.tr('Search Destination Cafes, Stays...'),
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          IconButton(
            onPressed: () async {
              final result = await _showFilters(context);
              if (result != null) setState(() => _activeFilters = result);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.tune,
              size: 18,
              color: _activeFilters.isEmpty ? Colors.grey : AppColors.teal,
            ),
          ),
        ],
      ),
    ),
  );
  Widget _districts(BuildContext context, Color text) {
    final all = [
      (
        'assets/images/pyramids_2.jpg',
        'Pyramids District',
        'Giza',
        ['Scenic Viewpoints', 'Mountains'],
        'giza-pyramids',
      ),
      (
        'assets/images/onboarding_egypt_heritage.jpg',
        'Pharaohs Land',
        'Luxor',
        ['Temples', 'Homestays'],
        'luxor-history',
      ),
      (
        'assets/images/red_sea.jpg',
        'Red Sea Coast',
        'Hurghada',
        ['Lakes', 'Trekking'],
        'red-sea-getaway',
      ),
    ];
    final data = all.where((x) => _visible(x.$4)).toList();
    final isWebLayout = MediaQuery.sizeOf(context).width >= 900;
    final cardWidth = isWebLayout ? 210.0 : 143.0;
    if (data.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: isWebLayout ? 228 : 177,
      child: Column(
        children: [
          SizedBox(
            height: isWebLayout ? 205 : 154,
            child: AnimatedBuilder(
              animation: _districtScrollController,
              builder: (context, _) => ListView.separated(
                controller: _districtScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // Preserve the looping carousel without creating the old
                // oversized 20x render range.
                itemCount: data.length * 6,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (_, i) {
                  final item = data[i % data.length];
                  final cardCenter = 16 + i * (cardWidth + 16) + cardWidth / 2;
                  final viewportCenter = MediaQuery.sizeOf(context).width / 2;
                  final distance =
                      (cardCenter -
                              (_districtScrollController.positions.length == 1
                                  ? _districtScrollController.offset
                                  : 0) -
                              viewportCenter)
                          .abs();
                  final focus = (1 - distance / (viewportCenter + cardWidth))
                      .clamp(0.0, 1.0);
                  final isCentered = focus > .72;
                  final scale = isCentered ? 1.06 : 1.0;
                  final rotation =
                      ((cardCenter -
                                  (_districtScrollController.positions.length ==
                                          1
                                      ? _districtScrollController.offset
                                      : 0) -
                                  viewportCenter) /
                              (viewportCenter + cardWidth))
                          .clamp(-0.32, 0.32);
                  return MouseRegion(
                    child: SizedBox(
                      width: cardWidth,
                      child: Transform.translate(
                        offset: const Offset(0, 8),
                        child: Transform.scale(
                          scale: scale,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.0015)
                              ..rotateY(rotation),
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _flippedDistrictIndex =
                                    _flippedDistrictIndex == i ? null : i;
                              }),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (child, animation) {
                                  final rotate = Tween<double>(begin: 1, end: 0)
                                      .animate(
                                        CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeInOut,
                                        ),
                                      );
                                  return AnimatedBuilder(
                                    animation: rotate,
                                    child: child,
                                    builder: (context, child) => Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.0015)
                                        ..rotateY(rotate.value * 3.1416),
                                      child: child,
                                    ),
                                  );
                                },
                                child: _flippedDistrictIndex == i
                                    ? _districtBackCard(context, item, text)
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              9,
                                            ),
                                            child: Image.asset(
                                              item.$1,
                                              height: isWebLayout ? 118 : 80,
                                              width: cardWidth,
                                              fit: BoxFit.cover,
                                              cacheWidth: 640,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            context.tr(item.$3),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: text,
                                            ),
                                          ),
                                          Text(
                                            context.tr('25 Available Seats'),
                                            style: const TextStyle(fontSize: 9),
                                          ),
                                          const SizedBox(height: 4),
                                          SizedBox(
                                            height: 22,
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () => context.push(
                                                '/trip/${item.$5}',
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.teal,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              child: Text(
                                                context.tr('View Details'),
                                                style: TextStyle(fontSize: 9),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _districtScrollController,
            builder: (context, _) {
              final page =
                  (_districtScrollController.positions.length == 1
                      ? (_districtScrollController.offset / (cardWidth + 16))
                            .round()
                      : 0) %
                  data.length;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < data.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == page ? 18 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: i == page
                            ? AppColors.teal
                            : const Color(0xFFD6DCDD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _districtBackCard(
    BuildContext context,
    (String, String, String, List<String>, String) item,
    Color text,
  ) => Container(
    height: 132,
    width: 143,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.teal,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.tr(item.$2),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${context.tr(item.$3)} · ${context.tr('25 Available Seats')}',
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 8),
        Text(
          context.tr('Tap to explore'),
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    ),
  );

  Widget _trending(BuildContext context, Color text) {
    final all = [
      (
        'assets/images/onboarding_egypt_heritage.jpg',
        'Luxor Temple',
        ['Temples', 'Winter'],
        'luxor-history',
      ),
      (
        'assets/images/siwa.jpg',
        'Siwa Oasis',
        ['Adventure', 'Summer'],
        'siwa-oasis',
      ),
      (
        'assets/images/dahab.jpg',
        'Dahab Lagoon',
        ['Scenic Viewpoints', 'Lakes'],
        'dahab-adventure',
      ),
    ];
    final data = all.where((x) => _visible(x.$3)).toList();
    final isWebLayout = MediaQuery.sizeOf(context).width >= 900;
    final cardWidth = isWebLayout ? 270.0 : 215.0;
    if (isWebLayout) {
      return SizedBox(
        height: 235,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < data.length; i++) ...[
              if (i > 0) const SizedBox(width: 16),
              Expanded(
                child: _trendCard(context, text, data[i], double.infinity),
              ),
            ],
          ],
        ),
      );
    }
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: data.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _trendCard(context, text, data[i], cardWidth),
      ),
    );
  }

  Widget _trendCard(
    BuildContext context,
    Color text,
    (String, String, List<String>, String) item,
    double cardWidth,
  ) => InkWell(
    onTap: () => context.push('/trip/${item.$4}'),
    child: SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item.$1,
              height: cardWidth.isInfinite ? 140 : 110,
              width: cardWidth,
              fit: BoxFit.cover,
              cacheWidth: 640,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            context.tr(item.$2),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: text,
            ),
          ),
          const Text(
            '📍 Egypt',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                '★★★★',
                style: TextStyle(color: Color(0xFFE59B38), fontSize: 13),
              ),
              const Text(' 4.9', style: TextStyle(fontSize: 10)),
              const Spacer(),
              SizedBox(
                height: 25,
                child: ElevatedButton(
                  onPressed: () => context.push('/trip/${item.$4}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    context.tr('View Details'),
                    style: TextStyle(fontSize: 9),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
