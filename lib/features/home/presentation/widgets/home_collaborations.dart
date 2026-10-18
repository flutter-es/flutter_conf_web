import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/routes/app_route_path.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/container/responsive_grid.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class HomeCollaborations extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        value: appLocalizations.value.homeCollaborationStat1Value,
        label: appLocalizations.value.homeCollaborationStat1Label,
      ),
      (
        value: appLocalizations.value.homeCollaborationStat2Value,
        label: appLocalizations.value.homeCollaborationStat2Label,
      ),
      (
        value: appLocalizations.value.homeCollaborationStat3Value,
        label: appLocalizations.value.homeCollaborationStat3Label,
      ),
      (
        value: appLocalizations.value.homeCollaborationStat4Value,
        label: appLocalizations.value.homeCollaborationStat4Label,
      ),
    ];

    final benefits = [
      appLocalizations.value.homeCollaborationBenefit1,
      appLocalizations.value.homeCollaborationBenefit2,
      appLocalizations.value.homeCollaborationBenefit3,
    ];

    final optionButtons = <Widget>[
      FclButton.primary(
        label: appLocalizations.value.homeCollaborationRequestButton,
        buttonSize: .large,
        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
        iconAlignment: .end,
        onPressed: () => context.go('/${AppRoutePath.sponsorship.pathName}'),
      ),
      FclButton.secondary(
        label: appLocalizations.value.homeCollaborationPackagesButton,
        buttonSize: .large,
        onPressed: () => context.go('/${AppRoutePath.sponsorship.pathName}'),
      ),
    ];

    return SectionContainer(
      spacing: 48,
      children: <Widget>[
        TitleSubtitleText(
          title: (
            text: appLocalizations.value.homeCollaborationTitle,
            size: switch (context.screenSize) {
              .extraLarge => 64,
              .large => 48,
              .normal || .small => 32,
            },
          ),
          subtitle: (
            text: appLocalizations.value.homeCollaborationSubtitle,
            size: switch (context.screenSize) {
              .extraLarge || .large => 24,
              .normal || .small => 16,
            },
          ),
          spacing: 12,
        ),
        ResponsiveGrid(
          columnSizes: switch (context.screenSize) {
            .extraLarge || .large => 4,
            _ => 1,
          },
          rowSizes: switch (context.screenSize) {
            .extraLarge || .large => 1,
            _ => 4,
          },
          children: <Widget>[
            for (final s in stats) _StatCard(value: s.value, label: s.label),
          ],
        ),
        switch (context.screenSize) {
          .extraLarge || .large => Row(
            children: <Widget>[
              Expanded(child: _BenefitsList(benefits: benefits)),
              Row(spacing: 16, mainAxisSize: .min, children: optionButtons),
            ],
          ),
          _ => Column(
            spacing: 24,
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: <Widget>[
              _BenefitsList(benefits: benefits),
              ...optionButtons,
            ],
          ),
        },
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const new({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return Container(
      padding: const .all(24),
      decoration: BoxDecoration(
        borderRadius: .circular(20),
        color: FlutterLatamColors.darkBlue,
        border: .all(color: FlutterLatamColors.white.withValues(alpha: .08)),
      ),
      child: Column(
        spacing: 12,
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: <Widget>[
          Text(
            value,
            style: theme.typography.h1Bold.copyWith(
              fontSize: switch (context.screenSize) {
                .extraLarge || .large => 56,
                _ => 40,
              },
              color: FlutterLatamColors.mediumBlue,
            ),
          ),
          Text(
            label,
            style: theme.typography.body3Regular.copyWith(
              color: FlutterLatamColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsList extends StatelessWidget {
  const new({required this.benefits});

  final List<String> benefits;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return Column(
      spacing: 16,
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: <Widget>[
        for (final benefit in benefits)
          Row(
            spacing: 12,
            crossAxisAlignment: .start,
            children: <Widget>[
              const Icon(
                Icons.check_rounded,
                size: 16,
                color: FlutterLatamColors.yellow,
              ),
              Expanded(
                child: Text(
                  benefit,
                  style: theme.typography.body3Regular.copyWith(
                    color: FlutterLatamColors.white.withValues(alpha: .7),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
