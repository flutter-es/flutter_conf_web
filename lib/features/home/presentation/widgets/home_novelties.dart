import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/card/grid_card_item.dart';
import 'package:flutter_conf_latam/core/widgets/container/responsive_grid.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class HomeNovelties extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final novelties = <({String title, String description, String image})>[];

    return SectionContainer(
      spacing: 48,
      children: <Widget>[
        if (novelties.isNotEmpty)
          Column(
            spacing: 30,
            children: <Widget>[
              TitleSubtitleText(
                title: (
                  text: l10n.homeNoveltiesTitle,
                  size: switch (context.screenSize) {
                    .extraLarge => 64,
                    .large => 48,
                    .normal || .small => 24,
                  },
                ),
                subtitle: (
                  text: l10n.homeNoveltiesDescription,
                  size: switch (context.screenSize) {
                    .extraLarge || .large => 24,
                    .normal || .small => 16,
                  },
                ),
                spacing: 12,
              ),
              ResponsiveGrid(
                columnSizes: switch (context.screenSize) {
                  .extraLarge || .large => 2,
                  .normal || .small => 1,
                },
                rowSizes: switch (context.screenSize) {
                  .extraLarge || .large => 2,
                  .normal || .small => novelties.length,
                },
                children: <Widget>[
                  for (final item in novelties)
                    GridCardItem(
                      title: item.title,
                      description: item.description,
                      imagePath: item.image,
                    ),
                ],
              ),
            ],
          ),
        SizedBox(
          width: .infinity,
          height: switch (context.screenSize) {
            .extraLarge => 665,
            .large => 1110,
            .normal || .small => 910,
          },
          child: const _NoveltyAppCard(),
        ),
      ],
    );
  }
}

class _NoveltyAppCard extends SignalWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;

    return Card(
      color: FlutterLatamColors.blue,
      clipBehavior: .antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: .circular(30)),
      child: Padding(
        padding: const .all(48),
        child: Flex(
          spacing: 10,
          direction: switch (context.screenSize) {
            .extraLarge => .horizontal,
            _ => .vertical,
          },
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                spacing: 60,
                mainAxisSize: .min,
                crossAxisAlignment: switch (context.screenSize) {
                  .extraLarge => .start,
                  _ => .center,
                },
                children: <Widget>[
                  TitleSubtitleText(
                    title: (
                      text: l10n.homeNoveltiesAppTitle,
                      size: switch (context.screenSize) {
                        .extraLarge => 48,
                        .large => 40,
                        .normal || .small => 24,
                      },
                    ),
                    subtitle: (
                      text: l10n.homeNoveltiesAppDescription,
                      size: switch (context.screenSize) {
                        .extraLarge || .large => 24,
                        .normal || .small => 16,
                      },
                    ),
                    textAlign: switch (context.screenSize) {
                      .extraLarge => .start,
                      _ => .center,
                    },
                    crossAxisAlignment: switch (context.screenSize) {
                      .extraLarge => .start,
                      _ => .center,
                    },
                    spacing: 10,
                  ),
                  const _AppStoreSection(),
                ],
              ),
            ),
            Expanded(
              child: SizedBox.square(
                dimension: switch (context.screenSize) {
                  .extraLarge || .large => 390,
                  .normal || .small => 220,
                },
                child: Image.asset(Assets.images.novelties.dashMobile),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppStoreSection extends SignalWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    final l10n = appLocalizations.value;
    final config = appConfig.value;

    final appLogoUrls = <({String imagePath, String url})>[
      (imagePath: Assets.images.novelties.appStore, url: config.appStoreUrl),
      (imagePath: Assets.images.novelties.googlePlay, url: config.googleAppUrl),
    ];

    return Column(
      spacing: 20,
      mainAxisSize: .min,
      crossAxisAlignment: switch (context.screenSize) {
        .extraLarge => .start,
        _ => .center,
      },
      children: <Widget>[
        Text(
          l10n.homeNoveltiesAppSoon,
          style: theme.typography.body1Regular.copyWith(
            fontSize: switch (context.screenSize) {
              .extraLarge || .large => 24,
              .normal || .small => 16,
            },
          ),
        ),
        Flex(
          spacing: 20,
          direction: switch (context.screenSize) {
            .extraLarge => .horizontal,
            _ => .vertical,
          },
          children: <Widget>[
            for (final item in appLogoUrls)
              InkWell(
                onTap: () => Utils.launchUrlLink(item.url),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 300,
                    maxHeight: switch (context.screenSize) {
                      .extraLarge || .large => 90,
                      .normal || .small => 60,
                    },
                  ),
                  child: Image.asset(item.imagePath, fit: .contain),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
