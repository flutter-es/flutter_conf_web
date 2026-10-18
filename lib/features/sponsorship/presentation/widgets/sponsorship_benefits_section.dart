import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/features/sponsorship/domain/models/sponsorship_package_model.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class SponsorshipBenefitsSection extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    const packages = SponsorshipPackageModel.packages;

    return SectionContainer(
      spacing: 40,
      children: <Widget>[
        TitleSubtitleText(
          spacing: 12,
          title: (
            text: l10n.sponsorshipBenefitsSectionTitle,
            size: switch (context.screenSize) {
              .extraLarge => 64,
              .large => 48,
              .normal || .small => 28,
            },
          ),
          subtitle: (
            text: l10n.sponsorshipBenefitsSectionSubtitle,
            size: switch (context.screenSize) {
              .extraLarge || .large => 18,
              .normal || .small => 14,
            },
          ),
        ),
        const _BenefitsTable(packages: packages),
        Text(
          l10n.sponsorshipBenefitTalkDisclaimer,
          textAlign: .center,
          style: context.theme.fclThemeScheme.typography.body4Regular.copyWith(
            color: FlutterLatamColors.white.withValues(alpha: .6),
          ),
        ),
      ],
    );
  }
}

class _BenefitsTable extends SignalWidget {
  const new({required this.packages});

  final List<SponsorshipPackageModel> packages;

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final theme = context.theme.fclThemeScheme;

    final tierNames = [
      l10n.sponsorshipPackageTierPlatinum,
      l10n.sponsorshipPackageTierGold,
      l10n.sponsorshipPackageTierSilver,
      l10n.sponsorshipPackageTierBronze,
    ];

    final tierColors = [
      FlutterLatamColors.mediumBlue,
      FlutterLatamColors.white,
      FlutterLatamColors.white,
      FlutterLatamColors.white,
    ];

    final rows = <({String label, List<String> values})>[
      (
        label: l10n.sponsorshipBenefitVipTickets,
        values: packages.map((p) => '${p.vipTickets}').toList(),
      ),
      (label: l10n.sponsorshipBenefitNetworking, values: List.filled(4, '✓')),
      (label: l10n.sponsorshipBenefitWebSocial, values: List.filled(4, '✓')),
      (label: l10n.sponsorshipBenefitMentions, values: List.filled(4, '✓')),
      (
        label: l10n.sponsorshipBenefitStand,
        values: packages.map((p) => p.standSize ?? '—').toList(),
      ),
      (
        label: l10n.sponsorshipBenefitMerchandising,
        values: List.filled(4, '✓'),
      ),
      (
        label: l10n.sponsorshipBenefitTalk,
        values: packages.map((p) => p.hasTalk ? '✓' : '—').toList(),
      ),
    ];

    final tableContent = Table(
      columnWidths: const {
        0: FlexColumnWidth(2.5),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
      },
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            const _TableCell(text: '', isHeader: true),
            for (int i = 0; i < tierNames.length; i++)
              _TableCell(
                text: tierNames[i],
                isHeader: true,
                textColor: tierColors[i],
                style: theme.typography.h1Bold.copyWith(fontSize: 18),
              ),
          ],
        ),
        for (final row in rows)
          TableRow(
            children: <Widget>[
              _TableCell(
                text: row.label,
                style: theme.typography.body2Regular,
                isLabel: true,
              ),
              for (final (index, value) in row.values.indexed)
                TableCell(
                  verticalAlignment: .fill,
                  child: _TableCell(
                    text: value,
                    backgroundColor: index == 0
                        ? FlutterLatamColors.darkBlue
                        : null,
                  ),
                ),
            ],
          ),
      ],
    );

    return switch (context.screenSize) {
      .extraLarge || .large => tableContent,
      .normal || .small => SingleChildScrollView(
        scrollDirection: .horizontal,
        child: SizedBox(width: 600, child: tableContent),
      ),
    };
  }
}

class _TableCell extends StatelessWidget {
  const new({
    required this.text,
    this.isHeader = false,
    this.isLabel = false,
    this.style,
    this.backgroundColor,
    this.textColor,
  });

  final String text;
  final bool isHeader;
  final bool isLabel;
  final TextStyle? style;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;
    final baseStyle = style ?? theme.typography.body2Regular;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        border: switch (isHeader) {
          true => null,
          false => Border(
            bottom: BorderSide(
              color: FlutterLatamColors.white.withValues(alpha: .08),
            ),
          ),
        },
      ),
      child: Padding(
        padding: .symmetric(horizontal: 12, vertical: isHeader ? 20 : 16),
        child: text == '✓'
            ? const Center(child: _CheckBadge())
            : Text(
                text,
                textAlign: isLabel ? .start : .center,
                style: baseStyle.copyWith(
                  color: textColor ?? FlutterLatamColors.white,
                ),
              ),
      ),
    );
  }
}

class _CheckBadge extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: .circle,
          color: FlutterLatamColors.lightGreen.withValues(alpha: .15),
          border: .all(
            color: FlutterLatamColors.lightGreen.withValues(alpha: .5),
          ),
        ),
        child: const Icon(
          Icons.check,
          size: 14,
          color: FlutterLatamColors.lightGreen,
        ),
      ),
    );
  }
}
