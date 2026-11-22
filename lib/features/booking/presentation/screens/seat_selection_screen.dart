import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({
    required this.maxSeats,
    required this.pricePerSeat,
    this.totalSeats = 45,
    super.key,
  });
  final int maxSeats;
  final int pricePerSeat;
  final int totalSeats;

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final Set<int> _selectedSeats = {};
  final Set<int> _bookedSeats = {4, 9, 18, 27, 34};

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
          context.tr('Select Seats'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _Legend(color: AppColors.teal, label: 'Available'),
                  SizedBox(width: 10),
                  _Legend(color: Color(0xFF10233F), label: 'Selected'),
                  SizedBox(width: 10),
                  _Legend(color: Color(0xFFD8E0E8), label: 'Booked'),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(12, 18, 12, 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.totalSeats,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 0,
                          childAspectRatio:
                              MediaQuery.sizeOf(context).width >= 900
                              ? 4.2
                              : .78,
                        ),
                        itemBuilder: (context, index) => _ImageSeatButton(
                          number: index,
                          selected: _selectedSeats.contains(index),
                          booked: _bookedSeats.contains(index),
                          onTap: () {
                            setState(() {
                              if (_selectedSeats.contains(index)) {
                                _selectedSeats.remove(index);
                              } else if (!_bookedSeats.contains(index) &&
                                  _selectedSeats.length < widget.maxSeats) {
                                _selectedSeats.add(index);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected: ${_selectedSeats.length}/${widget.maxSeats}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'EGP ${_selectedSeats.length * widget.pricePerSeat}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'Seat numbers: ${_selectedSeats.map((seat) => seat + 1).toList()..sort()}',
                      style: const TextStyle(
                        color: AppColors.darkTeal,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _selectedSeats.length != widget.maxSeats
                      ? null
                      : () {
                          final seats =
                              (_selectedSeats.map((seat) => seat + 1).toList()
                                    ..sort())
                                  .join(',');
                          context.go(
                            '/booking/confirmed/booking-demo?seats=$seats',
                          );
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    disabledBackgroundColor: Colors.blueGrey.shade200,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    context.tr('Confirm Booking'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
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

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      border: Border.all(color: color.withValues(alpha: .5)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class _ImageSeatButton extends StatelessWidget {
  const _ImageSeatButton({
    required this.number,
    required this.selected,
    required this.booked,
    required this.onTap,
  });
  final int number;
  final bool selected;
  final bool booked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: booked ? null : onTap,
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      opacity: booked
          ? .35
          : selected
          ? 1
          : .82,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: selected ? AppColors.teal : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.darkTeal),
              ),
              child: Text(
                '${number + 1}',
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.darkTeal,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: MediaQuery.sizeOf(context).width >= 900 ? 76 : 48,
              height: MediaQuery.sizeOf(context).width >= 900 ? 80 : 50,
              child: Image.asset(
                'assets/images/Modern Airplane Seat Icon.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
