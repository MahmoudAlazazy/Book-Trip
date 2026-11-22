import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesProvider = StateProvider<Set<String>>((ref) => <String>{});
