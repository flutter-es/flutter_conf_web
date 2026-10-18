import 'dart:convert';

import 'package:universal_html/html.dart' as html;

class MetaTagsManager {
  static void updateMetaTags({
    required String title,
    required String description,
    String? imageUrl,
    String? url,
    String? type = 'website',
    List<String>? keywords,
  }) {
    html.document.title = '$title | Flutter Conf Latam';

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

    var element = html.document.querySelector('meta[$attribute="$name"]');
    if (element == null) {
      element = html.MetaElement()
        ..setAttribute(attribute, name)
        ..content = content;
      html.document.head?.append(element);
    } else if (element is html.MetaElement) {
      element.content = content;
    }
  }

  static void _setMetaProperty(String property, String content) {
    _setMetaTag(property, content, attribute: 'property');
  }

  static void _setCanonicalUrl(String url) {
    var element = html.document.querySelector('link[rel="canonical"]');
    if (element == null) {
      element = html.LinkElement()
        ..rel = 'canonical'
        ..href = url;
      html.document.head?.append(element);
    } else if (element is html.LinkElement) {
      element.href = url;
    }
  }

  static void addStructuredData(Map<String, dynamic> structuredData) {
    final existing = html.document.querySelector('#structured-data');
    existing?.remove();

    final script = html.ScriptElement()
      ..id = 'structured-data'
      ..type = 'application/ld+json'
      ..text = jsonEncode(structuredData);
    html.document.head?.append(script);
  }

  static void removeStructuredData() {
    html.document.querySelector('#structured-data')?.remove();
  }
}
