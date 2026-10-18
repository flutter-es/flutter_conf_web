class SeoConfig {
  const new({
    required this.title,
    required this.description,
    this.keywords = const [],
    this.imageUrl,
    this.type = 'website',
  });

  final String title;
  final String description;
  final List<String> keywords;
  final String? imageUrl;
  final String type;

  static const String baseUrl = 'https://flutterconflatam.dev';

  static const String defaultImageUrl = '$baseUrl/icons/Icon-512.png';

  static const Map<String, SeoConfig> routes = {
    '/': SeoConfig(
      title: 'Flutter Conf Latam 2026',
      description:
          'La conferencia de Flutter más grande de Latinoamérica. '
          'Únete a desarrolladores, diseñadores y entusiastas de Flutter '
          'del 22 al 23 de septiembre de 2026.',
      keywords: [
        'Flutter',
        'Conferencia',
        'Latinoamérica',
        'Desarrollo Mobile',
        'Dart',
        'Cross-platform',
        'Flutter Conf',
        '2026',
      ],
      imageUrl: defaultImageUrl,
    ),
    '/speakers': SeoConfig(
      title: 'Speakers - Flutter Conf Latam 2026',
      description:
          'Conoce a los expertos y líderes de la comunidad Flutter '
          'que compartirán su conocimiento en Flutter Conf Latam 2026.',
      keywords: [
        'Flutter Speakers',
        'Flutter Experts',
        'Flutter Community',
        'Tech Talks',
      ],
      imageUrl: defaultImageUrl,
    ),
    '/schedule': SeoConfig(
      title: 'Agenda - Flutter Conf Latam 2026',
      description:
          'Revisa el cronograma completo de Flutter Conf Latam 2026. '
          'Talleres, charlas técnicas, keynotes y networking.',
      keywords: [
        'Flutter Schedule',
        'Conference Agenda',
        'Tech Talks',
        'Workshops',
      ],
      imageUrl: defaultImageUrl,
    ),
    '/pricing': SeoConfig(
      title: 'Tickets y Precios - Flutter Conf Latam 2026',
      description:
          'Compra tu entrada para Flutter Conf Latam 2026. '
          'Early bird, tickets regulares y pases VIP disponibles.',
      keywords: [
        'Flutter Conf Tickets',
        'Conference Pricing',
        'Buy Tickets',
        'Early Bird',
      ],
      imageUrl: defaultImageUrl,
    ),
    '/venue': SeoConfig(
      title: 'Sede - Flutter Conf Latam 2026',
      description:
          'Información sobre la sede de Flutter Conf Latam 2026. '
          'Ubicación, cómo llegar, hoteles cercanos y más.',
      keywords: [
        'Flutter Conf Venue',
        'Location',
        'How to get there',
        'Hotels',
      ],
      imageUrl: defaultImageUrl,
    ),
    '/gallery': SeoConfig(
      title: 'Galería - Flutter Conf Latam',
      description:
          'Revive los mejores momentos de Flutter Conf Latam. '
          'Fotos de ediciones anteriores, talleres, charlas y networking.',
      keywords: ['Flutter Conf Photos', 'Event Gallery', 'Conference Memories'],
      imageUrl: defaultImageUrl,
    ),
    '/organizers': SeoConfig(
      title: 'Organizadores - Flutter Conf Latam 2026',
      description:
          'Conoce al equipo organizador y comunidades aliadas '
          'detrás de Flutter Conf Latam 2026.',
      keywords: ['Flutter Community', 'Organizers', 'Flutter Latam'],
      imageUrl: defaultImageUrl,
    ),
    '/contact': SeoConfig(
      title: 'Contacto - Flutter Conf Latam 2026',
      description:
          'Ponte en contacto con el equipo de Flutter Conf Latam. '
          'Sponsors, prensa, preguntas generales.',
      keywords: ['Contact', 'Flutter Conf Contact', 'Sponsors', 'Press'],
      imageUrl: defaultImageUrl,
    ),
    '/privacy-policy': SeoConfig(
      title: 'Política de Privacidad - Flutter Conf Latam',
      description:
          'Política de privacidad y protección de datos de Flutter Conf Latam.',
      keywords: ['Privacy Policy', 'Data Protection', 'GDPR'],
      imageUrl: defaultImageUrl,
    ),
    '/terms-conditions': SeoConfig(
      title: 'Términos y Condiciones - Flutter Conf Latam',
      description:
          'Términos y condiciones de uso del sitio web de Flutter Conf Latam.',
      keywords: ['Terms', 'Conditions', 'Legal'],
      imageUrl: defaultImageUrl,
    ),
  };

  static SeoConfig getConfig(String route) {
    final cleanRoute = route.split('?').first.replaceAll(RegExp(r'/$'), '');
    if (routes.containsKey(cleanRoute)) return routes[cleanRoute]!;

    final parts = cleanRoute.split('/');
    if (parts.length > 2) {
      final baseRoute = '/${parts[1]}';
      if (routes.containsKey(baseRoute)) return routes[baseRoute]!;
    }

    return routes['/']!;
  }
}
