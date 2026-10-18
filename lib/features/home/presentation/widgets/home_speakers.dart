import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/routes/app_route_path.dart';
import 'package:flutter_conf_latam/core/routes/helpers/navigation_view_model.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/card/speaker_card_item.dart';
import 'package:flutter_conf_latam/core/widgets/container/responsive_grid.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/features/speakers/presentation/view_model/speakers_view_model.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class HomeSpeakers extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final randomSpeakersList = speakersRandomSignal.value;

    return randomSpeakersList.maybeMap(
      data: (data) {
        final colSize = switch (context.screenSize) {
          .extraLarge => 4,
          _ => 2,
        };
        final imageSize = switch (context.screenSize) {
          .extraLarge || .large => const Size.square(206),
          .normal || .small => const Size.square(120),
        };

        return SectionContainer(
          spacing: 30,
          children: <Widget>[
            TitleSubtitleText(
              title: (
                text: l10n.homeSpeakersTitle,
                size: switch (context.screenSize) {
                  .extraLarge => 64,
                  .large => 48,
                  .normal || .small => 24,
                },
              ),
              subtitle: (
                text: l10n.homeSpeakersDescription,
                size: switch (context.screenSize) {
                  .extraLarge || .large => 24,
                  .normal || .small => 16,
                },
              ),
              spacing: 12,
            ),
            ResponsiveGrid(
              columnSizes: colSize,
              rowSizes: ((data.length + 1) / colSize).ceil(),
              children: <Widget>[
                for (final item in data)
                  SpeakerCardItem(speaker: item, imageSize: imageSize),
                const _RedirectSpeakersCard(),
              ],
            ),
          ],
        );
      },
      orElse: () => const Offstage(),
    );
  }
}

class _RedirectSpeakersCard extends SignalWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final theme = context.theme.fclThemeScheme;

    return Center(
      child: SizedBox.fromSize(
        size: const Size.fromWidth(240),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: FlutterLatamColors.blue,
            borderRadius: .circular(20),
          ),
          child: Padding(
            padding: const .all(30),
            child: Column(
              spacing: 30,
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              children: <Widget>[
                Text(
                  l10n.homeSpeakersRedirectTitle,
                  textAlign: .center,
                  style: switch (context.screenSize) {
                    .extraLarge || .large => theme.typography.h3Bold,
                    .normal || .small => theme.typography.h4Bold,
                  },
                ),
                FclButton.secondary(
                  label: l10n.homeSpeakersSeeMoreSpeakers,
                  buttonSize: .small,
                  onPressed: _goToSpeakers,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToSpeakers() {
    navigationController.selectNavItemFromRoute(
      '/${AppRoutePath.speakers.pathName}',
    );
  }
}
