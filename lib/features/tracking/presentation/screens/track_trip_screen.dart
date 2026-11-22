import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';

class TrackTripScreen extends StatelessWidget {
  const TrackTripScreen({required this.bookingId, super.key});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final mapHeight = (MediaQuery.sizeOf(context).height * .28).clamp(
      220.0,
      330.0,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Track Your Trip',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
          children: [
            SizedBox(
              height: mapHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    FlutterMap(
                      options: const MapOptions(
                        initialCenter: LatLng(29.95, 31.15),
                        initialZoom: 8.4,
                        interactionOptions: InteractionOptions(
                          flags: InteractiveFlag.all,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.bookhotel',
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: const [
                                LatLng(30.0444, 31.2357),
                                LatLng(29.9, 31.1),
                                LatLng(29.75, 30.9),
                              ],
                              color: const Color(0xFF1685E5),
                              strokeWidth: 5,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: const [
                            Marker(
                              point: LatLng(30.0444, 31.2357),
                              width: 36,
                              height: 36,
                              child: _MapMarker(color: Colors.red),
                            ),
                            Marker(
                              point: LatLng(29.75, 30.9),
                              width: 36,
                              height: 36,
                              child: _MapMarker(color: Colors.red),
                            ),
                            Marker(
                              point: LatLng(29.9, 31.1),
                              width: 54,
                              height: 54,
                              child: _BusMarker(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(top: 16, right: 14, child: _EtaCard()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: Color(0x10000000), blurRadius: 7),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0F4),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.asset(
                        'assets/images/حافلة سياحية فاخرة على الطريق.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Bus',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Plate No. 7423',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            const _TripProgress(),
            const SizedBox(height: 35),
            const _RouteSummary(),
            SizedBox(
              height: (MediaQuery.sizeOf(context).height * .12).clamp(
                48.0,
                110.0,
              ),
            ),
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () => context.push('/trip/giza-pyramids'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Trip Details  ›',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
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

// Kept for the fallback visual map style.
// ignore: unused_element
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFE7F4E9), BlendMode.srcOver);
    final road = Paint()
      ..color = Colors.white.withValues(alpha: .8)
      ..strokeWidth = 13
      ..style = PaintingStyle.stroke;
    final thinRoad = Paint()
      ..color = const Color(0xFFC8DEC8)
      ..strokeWidth = 2;
    for (var i = 0; i < 6; i++) {
      final path = Path()
        ..moveTo(-20, 25.0 + i * 38)
        ..quadraticBezierTo(
          size.width * .4,
          0 + i * 45,
          size.width + 20,
          45 + i * 35,
        );
      canvas.drawPath(path, thinRoad);
    }
    final route = Path()
      ..moveTo(35, 45)
      ..cubicTo(
        size.width * .25,
        size.height * .12,
        size.width * .42,
        size.height * .85,
        size.width * .62,
        size.height * .55,
      )
      ..cubicTo(
        size.width * .78,
        size.height * .35,
        size.width * .85,
        size.height * .8,
        size.width - 42,
        size.height - 45,
      );
    canvas.drawPath(route, road);
    canvas.drawPath(
      route,
      Paint()
        ..color = const Color(0xFF1685E5)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => false;
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) =>
      Icon(Icons.location_on, color: color, size: 30);
}

class _BusMarker extends StatelessWidget {
  const _BusMarker();

  @override
  Widget build(BuildContext context) => Container(
    width: 58,
    height: 48,
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFB9D8EB), width: 2),
      boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 5)],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Image.asset(
        'assets/images/حافلة سياحية فاخرة على الطريق.png',
        fit: BoxFit.cover,
      ),
    ),
  );
}

class _EtaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 5)],
      ),
      child: const Row(
        children: [
          Icon(Icons.access_time, size: 17, color: Color(0xFF10233F)),
          SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Arriving', style: TextStyle(fontSize: 10)),
              Text(
                '45 min',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusStep extends StatelessWidget {
  const _StatusStep({
    required this.label,
    required this.time,
    required this.active,
  });
  final String label, time;
  final bool active;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(
        Icons.check_circle,
        color: active ? AppColors.teal : Colors.blueGrey.shade200,
        size: 20,
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
      if (time.isNotEmpty)
        Text(
          time,
          style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
        ),
    ],
  );
}

class _TripProgress extends StatelessWidget {
  const _TripProgress();

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('On The Way', '10:15 AM'),
      ('Arriving', '10:45 AM'),
      ('Arrived', ''),
    ];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < steps.length; index++)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _StatusStep(
                    label: steps[index].$1,
                    time: steps[index].$2,
                    active: true,
                  ),
                ),
                if (index < steps.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 9),
                    child: Container(
                      height: 3,
                      width: 22,
                      color: const Color(0xFF1685E5),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _RouteSummary extends StatelessWidget {
  const _RouteSummary();

  @override
  Widget build(BuildContext context) => Row(
    children: const [
      Expanded(
        child: _RouteInfo(
          icon: Icons.location_on_rounded,
          label: 'From',
          value: 'Cairo',
        ),
      ),
      SizedBox(width: 6),
      Expanded(
        child: _RouteInfo(
          icon: Icons.location_on_rounded,
          label: 'To',
          value: 'Fayoum',
        ),
      ),
      SizedBox(width: 6),
      Expanded(
        child: _RouteInfo(
          icon: Icons.calendar_month_rounded,
          label: 'Departure',
          value: '09:00 AM',
        ),
      ),
    ],
  );
}

class _RouteInfo extends StatelessWidget {
  const _RouteInfo({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    height: 78,
    padding: const EdgeInsets.fromLTRB(10, 9, 6, 8),
    decoration: BoxDecoration(
      color: const Color(0xFFE8F8F8),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.darkTeal, size: 18),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF536779),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF10233F),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}
