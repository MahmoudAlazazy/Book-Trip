import 'package:flutter/widgets.dart';

class SeoHead extends StatelessWidget {
  const SeoHead({
    required this.title,
    required this.description,
    this.image,
    this.jsonLdType = 'WebPage',
    this.jsonLdData,
    this.indexable = true,
    super.key,
  });
  final String title;
  final String description;
  final String? image;
  final String jsonLdType;
  final Map<String, dynamic>? jsonLdData;
  final bool indexable;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '$title. $description',
    child: const SizedBox.shrink(),
  );
}
