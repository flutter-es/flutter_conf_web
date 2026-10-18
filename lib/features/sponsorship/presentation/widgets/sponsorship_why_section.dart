import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/widgets/container/responsive_grid.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class SponsorshipWhySection extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;

    final benefits = <({String title, String description, IconData icon})>[
      (
        title: l10n.sponsorshipWhyTalentTitle,
        description: l10n.sponsorshipWhyTalentDescription,
        icon: Icons.people_outline,
      ),
      (
        title: l10n.sponsorshipWhyBrandTitle,
        description: l10n.sponsorshipWhyBrandDescription,
        icon: Icons.campaign_outlined,
      ),
      (
        title: l10n.sponsorshipWhyRelationsTitle,
        description: l10n.sponsorshipWhyRelationsDescription,
        icon: Icons.handshake_outlined,
      ),
      (
        title: l10n.sponsorshipWhyExpertiseTitle,
        description: l10n.sponsorshipWhyExpertiseDescription,
        icon: Icons.present_to_all_outlined,
      ),
      (
        title: l10n.sponsorshipWhyLeadershipTitle,
        description: l10n.sponsorshipWhyLeadershipDescription,
        icon: Icons.lightbulb_outline,
      ),
    ];

    return SectionContainer(
      spacing: 40,
      children: <Widget>[
        TitleSubtitleText(
          title: (
            text: l10n.sponsorshipWhySectionTitle,
            size: switch (context.screenSize) {
              .extraLarge || .large => 48,
              .normal || .small => 24,
            },
          ),
        ),
        switch (context.screenSize) {
          .extraLarge || .large => ResponsiveGrid(
            rowSizes: 2,
            columnSizes: 3,
            children: <Widget>[
              for (final item in benefits)
                _BenefitCard(
                  title: item.title,
                  description: item.description,
                  icon: item.icon,
                ),
            ],
          ),
          .normal || .small => Column(
            spacing: 16,
            mainAxisSize: .min,
            children: <Widget>[
              for (final item in benefits)
                _BenefitCard(
                  title: item.title,
                  description: item.description,
                  icon: item.icon,
                ),
            ],
          ),
        },
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const new({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(16),
        side: BorderSide(
          color: FlutterLatamColors.mediumBlue.withValues(alpha: .3),
        ),
      ),
      color: FlutterLatamColors.darkBlue,
      child: Padding(
        padding: const .all(24),
        child: Column(
          spacing: 16,
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: <Widget>[
            Container(
              padding: const .all(12),
              decoration: BoxDecoration(
                borderRadius: .circular(12),
                color: FlutterLatamColors.blue.withValues(alpha: .2),
              ),
              child: Icon(icon, color: FlutterLatamColors.mediumBlue),
            ),
            Text(
              title,
              style: theme.typography.subH2Semibold.copyWith(fontSize: 18),
            ),
            Text(
              description,
              style: theme.typography.body2Regular.copyWith(
                color: FlutterLatamColors.white.withValues(alpha: .8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
