import 'package:flutter_conf_latam/l10n/gen/app_localizations.dart';

final class EditionModel {
  const new({
    required this.year,
    required this.flag,
    required this.city,
    required this.country,
    required this.label,
    required this.isCurrent,
  });

  final int year;
  final String flag;
  final String city;
  final String country;
  final String label;
  final bool isCurrent;
}

List<EditionModel> editions(AppLocalizations l10n) => <EditionModel>[
  EditionModel(
    year: 2023,
    flag: '🇨🇴',
    city: 'Medellín',
    country: l10n.homeTimeline1Country,
    label: l10n.homeTimeline1Label,
    isCurrent: false,
  ),
  EditionModel(
    year: 2024,
    flag: '🇵🇪',
    city: 'Arequipa',
    country: l10n.homeTimeline2Country,
    label: l10n.homeTimeline2Label,
    isCurrent: false,
  ),
  EditionModel(
    year: 2025,
    flag: '🇪🇨',
    city: 'Quito',
    country: l10n.homeTimeline3Country,
    label: l10n.homeTimeline3Label,
    isCurrent: false,
  ),
  EditionModel(
    year: 2026,
    flag: '🇲🇽',
    city: 'Cancún',
    country: l10n.homeTimeline4Country,
    label: l10n.homeTimeline4Label,
    isCurrent: true,
  ),
];
