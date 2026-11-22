import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:bookhotel/app.dart';

void main() {
  testWidgets('PharaTrip app starts', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PharaTripApp()));
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(Image), findsOneWidget);
  });
}
