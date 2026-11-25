import 'dart:convert';

import 'package:web/web.dart' as web;

class MetaTagsManager {
  static void updateMetaTags({
    required String title,
    required String description,
    String? imageUrl,
    String? url,
    String? type = 'website',
    List<String>? keywords,
  }) {
    web.document.title = '$title | Flutter Conf Latam';

    _setMetaTag('description', description);
    if (keywords != null && keywords.isNotEmpty) {
      _setMetaTag('keywords', keywords.join(', '));
    }

    _setMetaProperty('og:title', title);
    _setMetaProperty('og:description', description);
    _setMetaProperty('og:type', type ?? 'website');
    if (url != null) _setMetaProperty('og:url', url);
    if (imageUrl != null) {
      _setMetaProperty('og:image', imageUrl);
      _setMetaProperty('og:image:width', '1200');
      _setMetaProperty('og:image:height', '630');
      _setMetaProperty('og:image:alt', title);
    }

    _setMetaTag('twitter:card', 'summary_large_image');
    _setMetaTag('twitter:title', title);
    _setMetaTag('twitter:description', description);
    if (imageUrl != null) _setMetaTag('twitter:image', imageUrl);

    _setMetaTag('author', 'Flutter Conf Latam Team');
    _setMetaProperty('og:locale', 'es_CO');
    _setMetaProperty('og:locale:alternate', 'en_US');
    _setMetaProperty('og:site_name', 'Flutter Conf Latam');

    if (url != null) _setCanonicalUrl(url);
  }

  static void _setMetaTag(
    String name,
    String content, {
    String attribute = 'name',
  }) {
    if (content.isEmpty) return;

    final element = web.document.querySelector('meta[$attribute="$name"]');
    if (element == null) {
      final meta = web.HTMLMetaElement()
        ..setAttribute(attribute, name)
        ..content = content;
      web.document.head?.append(meta);
    } else {
      element.setAttribute('content', content);
    }
  }

  static void _setMetaProperty(String property, String content) {
    _setMetaTag(property, content, attribute: 'property');
  }

  static void _setCanonicalUrl(String url) {
    final element = web.document.querySelector('link[rel="canonical"]');
    if (element == null) {
      final link = web.HTMLLinkElement()
        ..rel = 'canonical'
        ..href = url;
      web.document.head?.append(link);
    } else {
      element.setAttribute('href', url);
    }
  }

  static void addStructuredData(Map<String, dynamic> structuredData) {
    final existing = web.document.querySelector('#structured-data');
    existing?.remove();

    final script = web.HTMLScriptElement()
      ..id = 'structured-data'
      ..type = 'application/ld+json'
      ..text = jsonEncode(structuredData);
    web.document.head?.append(script);
  }

  static void removeStructuredData() {
    web.document.querySelector('#structured-data')?.remove();
  }
}
