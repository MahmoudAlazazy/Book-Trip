import 'dart:convert';
import 'dart:html' as html;

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
  Widget build(BuildContext context) {
    final url = html.window.location.href.split('#').first;
    html.document.title = title;
    _meta('description', description);
    _meta('robots', indexable ? 'index, follow' : 'noindex, nofollow');
    _linkCanonical(url);
    _property('og:title', title);
    _property('og:description', description);
    _property('og:url', url);
    _property('og:type', 'website');
    if (image != null) _property('og:image', image!);
    _meta('twitter:card', 'summary_large_image');
    _meta('twitter:title', title);
    _meta('twitter:description', description);
    _jsonLd(url);
    return Semantics(
      container: true,
      label: '$title. $description',
      child: const SizedBox.shrink(),
    );
  }

  void _meta(String name, String content) {
    final tag =
        html.document.head!.querySelector('meta[name="$name"]')
            as html.MetaElement? ??
        (html.MetaElement()..name = name);
    tag.content = content;
    if (tag.parent == null) html.document.head!.append(tag);
  }

  void _property(String property, String content) {
    final tag =
        html.document.head!.querySelector('meta[property="$property"]')
            as html.MetaElement? ??
        (html.MetaElement()..setAttribute('property', property));
    tag.content = content;
    if (tag.parent == null) html.document.head!.append(tag);
  }

  void _linkCanonical(String href) {
    final link =
        html.document.head!.querySelector('link[rel="canonical"]')
            as html.LinkElement? ??
        (html.LinkElement()..rel = 'canonical');
    link.href = href;
    if (link.parent == null) html.document.head!.append(link);
  }

  void _jsonLd(String url) {
    final old = html.document.head!.querySelector(
      'script[data-pharatrip-schema="website"]',
    );
    old?.remove();
    final script = html.ScriptElement()
      ..type = 'application/ld+json'
      ..setAttribute('data-pharatrip-schema', 'website')
      ..text = jsonEncode({
        '@context': 'https://schema.org',
        '@type': jsonLdType,
        'name': 'PharaTrip',
        'url': url,
        'description': description,
        if (jsonLdData != null) ...jsonLdData!,
      });
    html.document.head!.append(script);
  }
}
