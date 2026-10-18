import 'package:flutter_conf_latam/core/seo/seo_config.dart';

class StructuredDataBuilder {
  static Map<String, dynamic> buildEventData() {
    return {
      '@context': 'https://schema.org',
      '@type': 'Event',
      'name': 'Flutter Conf Latam 2026',
      'description':
          'La conferencia de Flutter más grande de Latinoamérica. '
          'Únete a desarrolladores, diseñadores y entusiastas de Flutter.',
      'startDate': '2026-09-22T09:00:00-05:00',
      'endDate': '2026-09-24T18:00:00-05:00',
      'eventStatus': 'https://schema.org/EventScheduled',
      'eventAttendanceMode': 'https://schema.org/OfflineEventAttendanceMode',
      'location': {
        '@type': 'Place',
        'name': 'Por confirmar',
        'address': {
          '@type': 'PostalAddress',
          'addressLocality': 'Por confirmar',
          'addressCountry': 'CO',
        },
      },
      'image': [SeoConfig.defaultImageUrl],
      'organizer': {
        '@type': 'Organization',
        'name': 'Flutter Latam Community',
        'url': SeoConfig.baseUrl,
      },
      'offers': {
        '@type': 'AggregateOffer',
        'url': '${SeoConfig.baseUrl}/pricing',
        'priceCurrency': 'USD',
        'lowPrice': '50',
        'highPrice': '200',
        'availability': 'https://schema.org/InStock',
        'validFrom': '2026-01-01T00:00:00-05:00',
      },
    };
  }

  static Map<String, dynamic> buildOrganizationData() {
    return {
      '@context': 'https://schema.org',
      '@type': 'Organization',
      'name': 'Flutter Conf Latam',
      'url': SeoConfig.baseUrl,
      'logo': SeoConfig.defaultImageUrl,
      'description': 'La conferencia de Flutter más grande de Latinoamérica',
      'sameAs': [
        'https://twitter.com/flutterconflat',
        'https://www.linkedin.com/company/flutterconflatam',
      ],
    };
  }

  static Map<String, dynamic> buildBreadcrumbData(List<BreadcrumbItem> items) {
    return {
      '@context': 'https://schema.org',
      '@type': 'BreadcrumbList',
      'itemListElement': items.asMap().entries.map((entry) {
        return {
          '@type': 'ListItem',
          'position': entry.key + 1,
          'name': entry.value.name,
          'item': entry.value.url,
        };
      }).toList(),
    };
  }

  static Map<String, dynamic> buildFaqData(List<FaqItem> faqs) {
    return {
      '@context': 'https://schema.org',
      '@type': 'FAQPage',
      'mainEntity': faqs.map((faq) {
        return {
          '@type': 'Question',
          'name': faq.question,
          'acceptedAnswer': {'@type': 'Answer', 'text': faq.answer},
        };
      }).toList(),
    };
  }

  static Map<String, dynamic> buildPersonData({
    required String name,
    required String jobTitle,
    String? image,
    String? description,
    String? url,
  }) {
    return {
      '@context': 'https://schema.org',
      '@type': 'Person',
      'name': name,
      if (jobTitle.isNotEmpty) 'jobTitle': jobTitle,
      'image': ?image,
      'description': ?description,
      'url': ?url,
    };
  }
}

class BreadcrumbItem {
  const new({required this.name, required this.url});

  final String name;
  final String url;
}

class FaqItem {
  const new({required this.question, required this.answer});

  final String question;
  final String answer;
}
