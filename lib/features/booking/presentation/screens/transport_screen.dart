import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({this.tripImage, super.key});

  final String? tripImage;

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  int _selectedTransport = 0;
  int _seats = 1;

  static const _options = [
    _TransportOption(
      'Bus',
      'Luxury Bus',
      '45 Seats',
      750,
      Icons.directions_bus_rounded,
      'assets/images/onboarding_egypt_collage.png',
    ),
    _TransportOption(
      'Minibus',
      'Mini Bus',
      '25 Seats',
      600,
      Icons.airport_shuttle_rounded,
      'assets/images/onboarding_egypt_heritage.jpg',
    ),
    _TransportOption(
      'Van',
      'Van',
      '14 Seats',
      400,
      Icons.local_shipping_rounded,
      'assets/images/onboarding_egypt_culture.jpg',
    ),
  ];

  _TransportOption get _selected => _options[_selectedTransport];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          context.tr('Book Your Transport'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          children: [
            Row(
              children: List.generate(_options.length, (index) {
                final option = _options[index];
                final selected = index == _selectedTransport;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == _options.length - 1 ? 0 : 8,
                    ),
                    child: InkWell(
                      onTap: () => setState(() => _selectedTransport = index),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 68,
                        decoration: BoxDecoration(
                          color: selected ? AppColors.teal : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? AppColors.teal
                                : const Color(0xFFE0E8EF),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              option.icon,
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF10233F),
                              size: 23,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              option.shortName,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF10233F),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 145,
                width: double.infinity,
                child: Image.asset(
                  _selected.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...List.generate(
              _options.length,
              (index) => _TransportRow(
                option: _options[index],
                selected: index == _selectedTransport,
                onTap: () => setState(() => _selectedTransport = index),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('Number of People'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    _CounterButton(
                      icon: Icons.remove,
                      onTap: _seats > 1 ? () => setState(() => _seats--) : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Text(
                        '$_seats',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    _CounterButton(
                      icon: Icons.add,
                      onTap: () => setState(() => _seats++),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: () => context.push(
                  '/booking/seats?maxSeats=$_seats&price=${_selected.price}',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  context.tr('Choose Seats'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransportOption {
  const _TransportOption(
    this.shortName,
    this.name,
    this.capacity,
    this.price,
    this.icon,
    this.image,
  );
  final String shortName, name, capacity, image;
  final int price;
  final IconData icon;
}

class _TransportRow extends StatelessWidget {
  const _TransportRow({
    required this.option,
    required this.selected,
    required this.onTap,
  });
  final _TransportOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: selected ? AppColors.teal : const Color(0xFF8293A5),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  option.capacity,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'EGP ${option.price}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    ),
  );
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: CircleAvatar(
      radius: 16,
      backgroundColor: const Color(0xFFE9EEF3),
      child: Icon(icon, size: 18, color: const Color(0xFF10233F)),
    ),
  );
}
