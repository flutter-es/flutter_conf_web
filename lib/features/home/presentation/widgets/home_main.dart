import 'dart:async';

import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/routes/app_route_path.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/text/count_down_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class HomeMain extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final dashImage = Image.asset(
      Assets.images.surfDash,
      width: switch (context.screenSize) {
        .extraLarge => 560,
        .large => 420,
        .normal || .small => 280,
      },
    );

    final titleWhite = Text(
      appLocalizations.value.homeMainTitle,
      textAlign: switch (context.screenSize) {
        .extraLarge || .large => .start,
        _ => .center,
      },
      style: context.theme.fclThemeScheme.typography.h1Bold.copyWith(
        fontSize: switch (context.screenSize) {
          .extraLarge => 72,
          .large => 52,
          .normal || .small => 36,
        },
        height: 1.1,
      ),
    );

    final titleColored = Text(
      appLocalizations.value.homeMainTitleColored,
      textAlign: switch (context.screenSize) {
        .extraLarge || .large => .start,
        _ => .center,
      },
      style: context.theme.fclThemeScheme.typography.h1Bold.copyWith(
        fontSize: switch (context.screenSize) {
          .extraLarge => 72,
          .large => 52,
          .normal || .small => 36,
        },
        height: 1.1,
        color: FlutterLatamColors.mediumBlue,
      ),
    );

    final description = Text(
      appLocalizations.value.homeMainDescription,
      textAlign: switch (context.screenSize) {
        .extraLarge || .large => .start,
        _ => .center,
      },
      style: context.theme.fclThemeScheme.typography.body2Regular.copyWith(
        color: FlutterLatamColors.white.withValues(alpha: .85),
        fontSize: switch (context.screenSize) {
          .extraLarge => 18,
          .large => 16,
          .normal || .small => 14,
        },
      ),
    );

    final buttons = switch (context.screenSize) {
      .extraLarge || .large => Row(
        spacing: 16,
        children: <Widget>[
          FclButton.primary(
            label: appLocalizations.value.menuBuyTicketsButton,
            buttonSize: .large,
            onPressed: () =>
                unawaited(Utils.launchUrlLink(appConfig.value.ticketPageUrl)),
          ),
          FclButton.secondary(
            label: appLocalizations.value.menuBeSponsorButton,
            buttonSize: .large,
            onPressed: () =>
                context.go('/${AppRoutePath.sponsorship.pathName}'),
          ),
        ],
      ),
      _ => Column(
        spacing: 12,
        crossAxisAlignment: .stretch,
        children: <Widget>[
          FclButton.primary(
            label: appLocalizations.value.menuBuyTicketsButton,
            buttonSize: .large,
            onPressed: () =>
                unawaited(Utils.launchUrlLink(appConfig.value.ticketPageUrl)),
          ),
          FclButton.secondary(
            label: appLocalizations.value.menuBeSponsorButton,
            buttonSize: .large,
            onPressed: () =>
                context.go('/${AppRoutePath.sponsorship.pathName}'),
          ),
        ],
      ),
    };

    return Column(
      spacing: 24,
      children: <Widget>[
        Stack(
          children: <Widget>[
            const Positioned.fill(child: _HeroBackground()),
            Padding(
              padding: .symmetric(
                horizontal: switch (context.screenSize) {
                  .extraLarge => 122,
                  .large => 72,
                  .normal || .small => 28,
                },
                vertical: switch (context.screenSize) {
                  .extraLarge || .large => 80,
                  .normal || .small => 48,
                },
              ),
              child: switch (context.screenSize) {
                .extraLarge || .large => Row(
                  spacing: 40,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        spacing: 24,
                        mainAxisSize: .min,
                        crossAxisAlignment: .start,
                        children: <Widget>[
                          _HeroBadge(
                            text: appLocalizations.value.homeHeroBadge,
                          ),
                          Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .start,
                            children: <Widget>[titleWhite, titleColored],
                          ),
                          description,
                          buttons,
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(alignment: .centerRight, child: dashImage),
                    ),
                  ],
                ),
                _ => Column(
                  spacing: 24,
                  mainAxisSize: .min,
                  children: <Widget>[
                    dashImage,
                    _HeroBadge(text: appLocalizations.value.homeHeroBadge),
                    Column(
                      mainAxisSize: .min,
                      children: <Widget>[titleWhite, titleColored],
                    ),
                    description,
                    buttons,
                  ],
                ),
              },
            ),
          ],
        ),
        CountDownText(startDate: .now(), endDate: DateTime(2026, 9, 22, 7, 30)),
      ],
    );
  }
}

class _HeroBackground extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(color: FlutterLatamColors.mainBlue),
        const Positioned(
          top: -150,
          right: -150,
          child: SizedBox.square(
            dimension: 600,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: .circle,
                gradient: RadialGradient(
                  colors: [Color(0x4DC49A1A), Colors.transparent],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const new({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: .circular(100),
        border: .all(
          color: FlutterLatamColors.mediumBlue.withValues(alpha: .6),
        ),
        color: FlutterLatamColors.mediumBlue.withValues(alpha: .08),
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 16, vertical: 8),
        child: Text(
          text,
          style: context.theme.fclThemeScheme.typography.body4Regular.copyWith(
            color: FlutterLatamColors.mediumBlue,
            letterSpacing: 2,
            fontWeight: .w600,
          ),
        ),
      ),
    );
  }
}
