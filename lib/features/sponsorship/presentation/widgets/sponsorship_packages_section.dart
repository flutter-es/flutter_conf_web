import 'dart:async';

import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/features/sponsorship/domain/models/sponsorship_package_model.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class SponsorshipPackagesSection extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final theme = context.theme.fclThemeScheme;

    const packages = SponsorshipPackageModel.packages;

    return SectionContainer(
      spacing: 40,
      children: <Widget>[
        TitleSubtitleText(
          title: (
            text: l10n.sponsorshipPackagesSectionTitle,
            size: switch (context.screenSize) {
              .extraLarge => 64,
              .large => 48,
              .normal || .small => 24,
            },
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: .circular(24),
            color: FlutterLatamColors.yellow.withValues(alpha: .1),
            border: .all(color: FlutterLatamColors.yellow),
          ),
          child: Padding(
            padding: const .symmetric(horizontal: 24, vertical: 10),
            child: Text(
              l10n.sponsorshipPackagesPromoLabel,
              style: theme.typography.body2Regular.copyWith(
                fontWeight: .w600,
                color: FlutterLatamColors.yellow,
              ),
            ),
          ),
        ),
        switch (context.screenSize) {
          .extraLarge || .large => Row(
            spacing: 16,
            crossAxisAlignment: .start,
            children: <Widget>[
              for (final pkg in packages)
                Expanded(child: _SponsorshipPackageCard(package: pkg)),
            ],
          ),
          .normal || .small => Column(
            spacing: 16,
            mainAxisSize: .min,
            children: <Widget>[
              for (final pkg in packages) _SponsorshipPackageCard(package: pkg),
            ],
          ),
        },
      ],
    );
  }
}

class _SponsorshipPackageCard extends SignalWidget {
  const new({required this.package});

  final SponsorshipPackageModel package;

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final theme = context.theme.fclThemeScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: .circular(20),
        color: FlutterLatamColors.darkBlue,
        border: .all(
          color: package.tier == .platinum
              ? _accentColor
              : FlutterLatamColors.mainBlue.withValues(alpha: .8),
          width: package.tier == .platinum ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const .all(24),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: <Widget>[
            Row(
              mainAxisAlignment: .spaceBetween,
              children: <Widget>[
                Text(
                  switch (package.tier) {
                    .platinum => l10n.sponsorshipPackageTierPlatinum,
                    .gold => l10n.sponsorshipPackageTierGold,
                    .silver => l10n.sponsorshipPackageTierSilver,
                    .bronze => l10n.sponsorshipPackageTierBronze,
                  },
                  style: theme.typography.h1Bold.copyWith(
                    fontSize: switch (context.screenSize) {
                      .extraLarge || .large => 24,
                      .normal || .small => 16,
                    },
                  ),
                ),
                if (package.tier == .platinum)
                  SizedBox.square(
                    dimension: 32,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: .circle,
                        border: .all(color: _accentColor),
                        color: _accentColor.withValues(alpha: .15),
                      ),
                      child: Icon(Icons.star, size: 16, color: _accentColor),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.sponsorshipPackageRegularPrice.toUpperCase(),
              style: theme.typography.body4Regular.copyWith(
                color: FlutterLatamColors.white.withValues(alpha: .5),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${l10n.sponsorshipPackagePrice(package.regularPrice)}',
              style: theme.typography.h1Bold.copyWith(
                fontSize: switch (context.screenSize) {
                  .extraLarge || .large => 24,
                  .normal || .small => 16,
                },
                decoration: .lineThrough,
                color: FlutterLatamColors.white.withValues(alpha: .4),
                decorationColor: FlutterLatamColors.white.withValues(alpha: .4),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.sponsorshipPackagePromoPrice.toUpperCase(),
              style: theme.typography.body3Regular.copyWith(
                letterSpacing: 1,
                fontWeight: .w600,
                color: _accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$ ${l10n.sponsorshipPackagePrice(package.promoPrice)}',
              style: theme.typography.h1Bold.copyWith(
                fontSize: switch (context.screenSize) {
                  .extraLarge || .large => 36,
                  .normal || .small => 24,
                },
                color: package.tier == .platinum
                    ? _accentColor
                    : FlutterLatamColors.white,
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: FlutterLatamColors.white.withValues(alpha: .1)),
            const SizedBox(height: 16),
            _FeatureRow(
              icon: Icons.confirmation_number_outlined,
              text: l10n.sponsorshipPackageVipTickets(package.vipTickets),
            ),
            const SizedBox(height: 10),
            _FeatureRow(
              icon: Icons.storefront_outlined,
              text: switch (package.standSize) {
                String() => 'Stand: ${package.standSize}',
                null => l10n.sponsorshipPackageNoStand,
              },
            ),
            const SizedBox(height: 10),
            _FeatureRow(
              icon: package.hasTalk ? Icons.check : Icons.close,
              iconColor: package.hasTalk
                  ? FlutterLatamColors.lightGreen
                  : FlutterLatamColors.grey,
              text: package.hasTalk
                  ? l10n.sponsorshipPackageTalkIncluded
                  : l10n.sponsorshipPackageNoTalk,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: .infinity,
              child: FclButton.primary(
                label: l10n.sponsorshipPackageCtaButton,
                buttonSize: .small,
                textSize: .small,
                color: package.tier == .platinum ? _accentColor : null,
                onPressed: () => unawaited(
                  Utils.launchUrlLink(
                    Utils.mailtoWithSubject(
                      const String.fromEnvironment('CONTACT_EMAIL'),
                      l10n.sponsorshipPackageContactSubject(
                        switch (package.tier) {
                          .platinum => l10n.sponsorshipPackageTierPlatinum,
                          .gold => l10n.sponsorshipPackageTierGold,
                          .silver => l10n.sponsorshipPackageTierSilver,
                          .bronze => l10n.sponsorshipPackageTierBronze,
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _accentColor => switch (package.tier) {
    .platinum => FlutterLatamColors.mediumBlue,
    .gold => FlutterLatamColors.yellow,
    .silver => FlutterLatamColors.silver,
    .bronze => FlutterLatamColors.bronze,
  };
}

class _FeatureRow extends StatelessWidget {
  const new({
    required this.icon,
    required this.text,
    this.iconColor = FlutterLatamColors.mediumBlue,
  });

  final IconData icon;
  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: <Widget>[
        Icon(icon, size: 18, color: iconColor),
        Expanded(
          child: Text(
            text,
            style: context.theme.fclThemeScheme.typography.body4Regular,
          ),
        ),
      ],
    );
  }
}
