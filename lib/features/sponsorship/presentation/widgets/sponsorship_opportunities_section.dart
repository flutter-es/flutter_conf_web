import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/widgets/container/responsive_grid.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class SponsorshipOpportunitiesSection extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;

    final items = <({String title, String description, IconData icon})>[
      (
        title: l10n.sponsorshipAlacarteVipParty,
        description: l10n.sponsorshipAlacarteVipPartyDescription,
        icon: Icons.celebration_outlined,
      ),
      (
        title: l10n.sponsorshipAlacarteLunch,
        description: l10n.sponsorshipAlacarteLunchDescription,
        icon: Icons.restaurant_outlined,
      ),
      (
        title: l10n.sponsorshipAlacarteStreaming,
        description: l10n.sponsorshipAlacarteStreamingDescription,
        icon: Icons.videocam_outlined,
      ),
      (
        title: l10n.sponsorshipAlacartePrize,
        description: l10n.sponsorshipAlacartePrizeDescription,
        icon: Icons.emoji_events_outlined,
      ),
      (
        title: l10n.sponsorshipAlacarteCoffee,
        description: l10n.sponsorshipAlacarteCoffeeDescription,
        icon: Icons.coffee_outlined,
      ),
      (
        title: l10n.sponsorshipAlacarteSwag,
        description: l10n.sponsorshipAlacarteSwagDescription,
        icon: Icons.checkroom_outlined,
      ),
    ];

    final cards = [for (final item in items) _OpportunityCard(item: item)];

    return SectionContainer(
      spacing: 40,
      children: <Widget>[
        TitleSubtitleText(
          spacing: 12,
          title: (
            text: l10n.sponsorshipAlacarteSectionTitle,
            size: switch (context.screenSize) {
              .extraLarge => 64,
              .large => 48,
              .normal || .small => 24,
            },
          ),
          subtitle: (
            text: l10n.sponsorshipAlacarteDescription,
            size: switch (context.screenSize) {
              .extraLarge || .large => 18,
              .normal || .small => 14,
            },
          ),
        ),
        switch (context.screenSize) {
          .extraLarge || .large => ResponsiveGrid(
            columnSizes: 3,
            rowSizes: 2,
            children: cards,
          ),
          _ => Column(spacing: 16, mainAxisSize: .min, children: cards),
        },
      ],
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  const new({required this.item});

  final ({String title, String description, IconData icon}) item;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(16),
        side: BorderSide(
          color: FlutterLatamColors.mainBlue.withValues(alpha: .8),
        ),
      ),
      color: FlutterLatamColors.darkBlue,
      child: Padding(
        padding: const .all(20),
        child: Row(
          spacing: 12,
          crossAxisAlignment: .start,
          children: <Widget>[
            SizedBox.square(
              dimension: 40,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: .circular(8),
                  color: FlutterLatamColors.lightGreen.withValues(alpha: .15),
                ),
                child: Icon(item.icon, color: FlutterLatamColors.lightGreen),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 12,
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: <Widget>[
                  Text(
                    item.title,
                    style: theme.typography.subH2Semibold.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    item.description,
                    style: theme.typography.body3Regular.copyWith(
                      color: FlutterLatamColors.white.withValues(alpha: .7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
