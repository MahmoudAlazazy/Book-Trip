import 'dart:convert';

import 'package:web/web.dart' as web;

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
    final url = web.window.location.href.split('#').first;
    web.document.title = title;
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
        web.document.head!.querySelector('meta[name="$name"]')
            as web.HTMLMetaElement? ??
        (web.HTMLMetaElement()..name = name);
    tag.content = content;
    if (tag.parentNode == null) web.document.head!.appendChild(tag);
  }

  void _property(String property, String content) {
    final tag =
        web.document.head!.querySelector('meta[property="$property"]')
            as web.HTMLMetaElement? ??
        (web.HTMLMetaElement()..setAttribute('property', property));
    tag.content = content;
    if (tag.parentNode == null) web.document.head!.appendChild(tag);
  }

  void _linkCanonical(String href) {
    final link =
        web.document.head!.querySelector('link[rel="canonical"]')
            as web.HTMLLinkElement? ??
        (web.HTMLLinkElement()..rel = 'canonical');
    link.href = href;
    if (link.parentNode == null) web.document.head!.appendChild(link);
  }

  void _jsonLd(String url) {
    final old = web.document.head!.querySelector(
      'script[data-pharatrip-schema="website"]',
    );
    old?.remove();
    final script = web.HTMLScriptElement()
      ..type = 'application/ld+json'
      ..setAttribute('data-pharatrip-schema', 'website')
      ..text = jsonEncode({
        '@context': 'https://schema.org',
        '@type': jsonLdType,
        'name': 'PharaTrip',
        'url': url,
        'description': description,
        ...?jsonLdData,
      });
    web.document.head!.appendChild(script);
  }
}
