import 'dart:async';

import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/card/grid_card_item.dart';
import 'package:flutter_conf_latam/core/widgets/container/responsive_grid.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/dialog/data_protection_dialog.dart';
import 'package:flutter_conf_latam/core/widgets/dialog/main_dialog.dart';
import 'package:flutter_conf_latam/core/widgets/text/adaptable_text.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class HomeFeatures extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final features = <({String title, String description, String image})>[
      (
        title: l10n.homeFeatureLearnTitle,
        description: l10n.homeFeatureLearnDescription,
        image: Assets.images.features.one,
      ),
      (
        title: l10n.homeFeatureConnectTitle,
        description: l10n.homeFeatureConnectDescription,
        image: Assets.images.features.two,
      ),
      (
        title: l10n.homeFeatureGrowthTitle,
        description: l10n.homeFeatureGrowthDescription,
        image: Assets.images.features.three,
      ),
      (
        title: l10n.homeFeaturePrizeTitle,
        description: l10n.homeFeaturePrizeDescription,
        image: Assets.images.features.four,
      ),
    ];

    return SectionContainer(
      spacing: 30,
      children: <Widget>[
        TitleSubtitleText(
          title: (
            text: l10n.homeFeatureTitle,
            size: switch (context.screenSize) {
              .extraLarge => 64,
              .large => 48,
              .normal || .small => 24,
            },
          ),
          subtitle: (
            text: l10n.homeFeatureDescription,
            size: switch (context.screenSize) {
              .extraLarge || .large => 24,
              .normal || .small => 16,
            },
          ),
          spacing: 12,
        ),
        Flex(
          spacing: 30,
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          direction: switch (context.screenSize) {
            .extraLarge => .horizontal,
            _ => .vertical,
          },
          children: <Widget>[
            Flexible(
              flex: 2,
              child: ResponsiveGrid(
                columnSizes: switch (context.screenSize) {
                  .extraLarge || .large => 2,
                  .normal || .small => 1,
                },
                rowSizes: switch (context.screenSize) {
                  .extraLarge || .large => 2,
                  .normal || .small => features.length,
                },
                children: <Widget>[
                  for (final item in features)
                    GridCardItem(
                      title: item.title,
                      description: item.description,
                      imagePath: item.image,
                    ),
                ],
              ),
            ),
            const Flexible(
              child: SizedBox(
                width: .infinity,
                child: _BuyTicketFeature(price: 150),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BuyTicketFeature extends SignalWidget {
  const new({required this.price});

  final double price;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Align(
        child: SizedBox.square(
          dimension: 180,
          child: Image.asset(Assets.images.features.tickets),
        ),
      ),
      Column(
        spacing: 30,
        crossAxisAlignment: .start,
        children: <Widget>[
          AdaptableText(
            appLocalizations.value.homeFeatureBuyTicketTitle(price),
            textAlign: switch (context.screenSize) {
              .small || .normal => .center,
              _ => .start,
            },
            style: context.theme.fclThemeScheme.typography.h3Bold,
          ),
          Align(
            alignment: switch (context.screenSize) {
              .extraLarge || .large => .centerLeft,
              .normal || .small => .center,
            },
            child: FclButton.secondary(
              label: appLocalizations.value.homeFeatureBuyTicketButton,
              buttonSize: .small,
              onPressed: () {
                final url = appConfig.value.ticketPageUrl;
                const showDisclaimer = bool.fromEnvironment(
                  'SHOW_DISCLAIMER_DIALOG',
                );

                if (!showDisclaimer) {
                  _goToTicketUrl(url);
                } else {
                  unawaited(_showDisclaimerDialog(context, url));
                }
              },
            ),
          ),
        ],
      ),
    ];

    return Card(
      clipBehavior: .antiAliasWithSaveLayer,
      color: FlutterLatamColors.fuchsia,
      child: Padding(
        padding: const .all(30),
        child: switch (context.screenSize) {
          .large => Row(
            spacing: 30,
            mainAxisSize: .min,
            children: <Widget>[
              for (final (index, item) in children.indexed)
                Expanded(flex: index == 0 ? 1 : 2, child: item),
            ],
          ),
          _ => Column(spacing: 40, mainAxisSize: .min, children: children),
        },
      ),
    );
  }

  Future<void> _showDisclaimerDialog(BuildContext context, String url) async {
    final result = await MainDialog.show<bool>(
      context,
      child: const DataProtectionDialog(),
    );
    if (result ?? false) _goToTicketUrl(url);
  }

  void _goToTicketUrl(String url) => unawaited(Utils.launchUrlLink(url));
}
