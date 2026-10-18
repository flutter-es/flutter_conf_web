import 'dart:async';

import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class SponsorshipStartupSection extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final theme = context.theme.fclThemeScheme;

    final benefits = <String>[
      l10n.sponsorshipStartupBenefit1,
      l10n.sponsorshipStartupBenefit2,
      l10n.sponsorshipStartupBenefit3,
      l10n.sponsorshipStartupBenefit4,
      l10n.sponsorshipStartupBenefit5,
      l10n.sponsorshipStartupBenefit6,
    ];

    return Padding(
      padding: .symmetric(
        horizontal: switch (context.screenSize) {
          .extraLarge || .large => 96,
          _ => 0,
        },
      ),
      child: SectionContainer(
        children: <Widget>[
          Container(
            width: .infinity,
            padding: .all(switch (context.screenSize) {
              .extraLarge || .large => 48,
              .normal || .small => 28,
            }),
            decoration: BoxDecoration(
              borderRadius: .circular(24),
              border: .all(
                width: 3,
                color: FlutterLatamColors.lightGreen.withValues(alpha: .3),
              ),
              gradient: LinearGradient(
                begin: .topLeft,
                end: .bottomRight,
                colors: [
                  FlutterLatamColors.lightGreen.withValues(alpha: .45),
                  FlutterLatamColors.mainBlue,
                ],
                stops: const [0.05, 0.3],
              ),
            ),
            child: Column(
              spacing: 24,
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: <Widget>[
                switch (context.screenSize) {
                  .extraLarge || .large => Row(
                    spacing: 8,
                    children: <Widget>[
                      const Icon(
                        Icons.rocket_launch_outlined,
                        color: FlutterLatamColors.lightGreen,
                      ),
                      Text(
                        l10n.sponsorshipStartupSectionLabel.toUpperCase(),
                        style: theme.typography.body3Regular.copyWith(
                          letterSpacing: 2,
                          fontWeight: .w600,
                          color: FlutterLatamColors.lightGreen,
                        ),
                      ),
                      const Spacer(),
                      _StartupBadge(label: l10n.sponsorshipStartupBadge),
                    ],
                  ),
                  _ => Column(
                    spacing: 8,
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    children: <Widget>[
                      Row(
                        spacing: 8,
                        children: <Widget>[
                          const Icon(
                            Icons.rocket_launch_outlined,
                            color: FlutterLatamColors.lightGreen,
                          ),
                          Flexible(
                            child: Text(
                              l10n.sponsorshipStartupSectionLabel.toUpperCase(),
                              style: theme.typography.body3Regular.copyWith(
                                letterSpacing: 2,
                                fontWeight: .w600,
                                color: FlutterLatamColors.lightGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _StartupBadge(label: l10n.sponsorshipStartupBadge),
                    ],
                  ),
                },
                Text(
                  l10n.sponsorshipStartupTitle,
                  style: theme.typography.h1Bold.copyWith(
                    fontSize: switch (context.screenSize) {
                      .extraLarge => 48,
                      .large => 36,
                      .normal || .small => 24,
                    },
                  ),
                ),
                Text(
                  l10n.sponsorshipStartupDescription,
                  style: theme.typography.body2Regular.copyWith(
                    color: FlutterLatamColors.white.withValues(alpha: .85),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: .circular(16),
                    border: .all(color: FlutterLatamColors.mediumBlue),
                    color: FlutterLatamColors.mediumBlue.withValues(alpha: .1),
                  ),
                  child: Padding(
                    padding: const .symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      l10n.sponsorshipStartupRequirement,
                      style: theme.typography.body3Regular.copyWith(
                        fontWeight: .w600,
                        color: FlutterLatamColors.mediumBlue,
                      ),
                    ),
                  ),
                ),
                switch (context.screenSize) {
                  .extraLarge || .large => Row(
                    spacing: 16,
                    crossAxisAlignment: .start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          spacing: 16,
                          mainAxisSize: .min,
                          crossAxisAlignment: .start,
                          children: <Widget>[
                            _BenefitItem(text: benefits[0]),
                            _BenefitItem(text: benefits[2]),
                            _BenefitItem(text: benefits[4]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 16,
                          mainAxisSize: .min,
                          crossAxisAlignment: .start,
                          children: <Widget>[
                            _BenefitItem(text: benefits[1]),
                            _BenefitItem(text: benefits[3]),
                            _BenefitItem(text: benefits[5]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _ => Column(
                    spacing: 12,
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    children: <Widget>[
                      for (final b in benefits) _BenefitItem(text: b),
                    ],
                  ),
                },
                Column(
                  spacing: 12,
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: <Widget>[
                    FclButton.primary(
                      buttonSize: .large,
                      color: FlutterLatamColors.lightGreen,
                      label: l10n.sponsorshipStartupApplyButton,
                      onPressed: () =>
                          _goToMail(l10n.sponsorshipStartupContactSubject),
                    ),
                    Text(
                      l10n.sponsorshipStartupNote,
                      style: theme.typography.body4Regular.copyWith(
                        color: FlutterLatamColors.white.withValues(alpha: .6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToMail(String subject) {
    unawaited(
      Utils.launchUrlLink(
        Utils.mailtoWithSubject(
          const String.fromEnvironment('CONTACT_EMAIL'),
          subject,
        ),
      ),
    );
  }
}

class _StartupBadge extends StatelessWidget {
  const new({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: .circular(20),
        border: .all(color: FlutterLatamColors.yellow.withValues(alpha: .3)),
        color: FlutterLatamColors.yellow.withValues(alpha: .1),
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 14, vertical: 8),
        child: Text(
          label,
          style: theme.typography.body4Regular.copyWith(
            fontWeight: .w600,
            color: FlutterLatamColors.yellow,
          ),
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  const new({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      crossAxisAlignment: .start,
      children: <Widget>[
        const Padding(
          padding: .only(top: 2),
          child: Icon(Icons.check, color: FlutterLatamColors.mediumBlue),
        ),
        Expanded(
          child: Text(
            text,
            style: context.theme.fclThemeScheme.typography.body3Regular,
          ),
        ),
      ],
    );
  }
}
