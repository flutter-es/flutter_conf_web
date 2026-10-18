import 'dart:async';

import 'package:flutter_conf_core/flutter_conf_core.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/container/error_container.dart';
import 'package:flutter_conf_latam/core/widgets/container/keep_alive_container.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/images/carousel_images.dart';
import 'package:flutter_conf_latam/features/home/presentation/view_model/home_signals.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class HomeVenue extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return KeepAliveContainer(
      child: venueSignal.value.map(
        data: (venue) {
          final l10n = appLocalizations.value;
          final theme = context.theme.fclThemeScheme;

          final description = l10n.localeName == 'es'
              ? venue.descriptionEs ?? ''
              : venue.descriptionEn ?? '';

          final imageSection = venue.imageUrl.isEmpty
              ? _VenuePlaceholderCard(name: venue.name)
              : CarouselImages(images: venue.imageUrl);

          final textContent = Column(
            spacing: 20,
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: <Widget>[
              Text(
                l10n.homeVenueSectionLabel,
                style: theme.typography.captionRegular.copyWith(
                  letterSpacing: 3,
                  fontWeight: .w600,
                  color: FlutterLatamColors.mediumBlue,
                ),
              ),
              Text(
                venue.name,
                style: theme.typography.h1Bold.copyWith(
                  fontSize: switch (context.screenSize) {
                    .extraLarge => 48,
                    .large => 36,
                    .normal || .small => 28,
                  },
                  color: FlutterLatamColors.white,
                  height: 1.1,
                ),
              ),
              if (description.isNotEmpty)
                Text(
                  description,
                  style: theme.typography.body2Regular.copyWith(
                    color: FlutterLatamColors.white.withValues(alpha: .75),
                    fontSize: switch (context.screenSize) {
                      .extraLarge || .large => 16,
                      .normal || .small => 14,
                    },
                  ),
                ),
              Row(
                spacing: 8,
                children: <Widget>[
                  SizedBox.square(
                    dimension: 20,
                    child: SvgPicture.asset(
                      Assets.images.icons.pinMap,
                      colorFilter: const ColorFilter.mode(
                        FlutterLatamColors.mediumBlue,
                        .srcIn,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${venue.address}, ${venue.city}',
                      style: theme.typography.body3Regular.copyWith(
                        color: FlutterLatamColors.white.withValues(alpha: .85),
                      ),
                    ),
                  ),
                ],
              ),
              FclButton.secondary(
                label: l10n.aboutVenueHowToArrive,
                buttonSize: .small,
                icon: SizedBox.square(
                  dimension: 18,
                  child: SvgPicture.asset(
                    Assets.images.icons.pinMap,
                    colorFilter: const ColorFilter.mode(
                      FlutterLatamColors.mediumBlue,
                      .srcIn,
                    ),
                  ),
                ),
                onPressed: venue.mapsUrl != null
                    ? () => unawaited(Utils.launchUrlLink(venue.mapsUrl!))
                    : null,
              ),
            ],
          );

          return SectionContainer(
            spacing: 40,
            children: <Widget>[
              switch (context.screenSize) {
                .extraLarge || .large => Row(
                  spacing: 48,
                  crossAxisAlignment: .start,
                  children: <Widget>[
                    Expanded(flex: 2, child: imageSection),
                    Expanded(flex: 3, child: textContent),
                  ],
                ),
                _ => Column(
                  spacing: 24,
                  children: <Widget>[imageSection, textContent],
                ),
              },
              if (venue.tips.isNotEmpty)
                Column(
                  spacing: 16,
                  crossAxisAlignment: .start,
                  children: <Widget>[
                    Text(
                      l10n.homeVenueTipsTitle,
                      style: theme.typography.h1Bold.copyWith(
                        fontSize: switch (context.screenSize) {
                          .extraLarge => 28,
                          .large => 24,
                          .normal || .small => 20,
                        },
                        color: FlutterLatamColors.white,
                      ),
                    ),
                    _VenueTipsGrid(tips: venue.tips),
                  ],
                ),
            ],
          );
        },
        error: (_, _) => const SectionContainer(
          children: [Center(child: ErrorContainer(onRetry: reloadVenue))],
        ),
        loading: () => const SectionContainer(
          children: [Center(child: CircularProgressIndicator())],
        ),
      ),
    );
  }
}

class _VenuePlaceholderCard extends StatelessWidget {
  const new({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return AspectRatio(
      aspectRatio: switch (context.screenSize) {
        .extraLarge || .large => 3 / 4,
        _ => 16 / 9,
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: FlutterLatamColors.darkBlue,
          borderRadius: .circular(20),
          border: .all(color: FlutterLatamColors.white.withValues(alpha: .08)),
        ),
        child: Column(
          spacing: 16,
          mainAxisAlignment: .center,
          children: <Widget>[
            Icon(
              Icons.location_city_rounded,
              color: FlutterLatamColors.mediumBlue,
              size: switch (context.screenSize) {
                .extraLarge || .large => 80,
                _ => 56,
              },
            ),
            Padding(
              padding: const .symmetric(horizontal: 24),
              child: Text(
                name,
                textAlign: .center,
                style: theme.typography.body1Regular.copyWith(
                  color: FlutterLatamColors.white.withValues(alpha: .7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VenueTipsGrid extends StatelessWidget {
  const new({required this.tips});

  final List<VenueTipEntity> tips;

  @override
  Widget build(BuildContext context) {
    return switch (context.screenSize) {
      .extraLarge || .large => Column(
        spacing: 12,
        children: <Widget>[
          for (int i = 0; i < tips.length; i += 2)
            IntrinsicHeight(
              child: Row(
                spacing: 12,
                crossAxisAlignment: .stretch,
                children: <Widget>[
                  Expanded(child: _VenueTipCard(tip: tips[i])),
                  if (i + 1 < tips.length)
                    Expanded(child: _VenueTipCard(tip: tips[i + 1]))
                  else
                    const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ),
        ],
      ),
      _ => Column(
        spacing: 12,
        children: <Widget>[for (final tip in tips) _VenueTipCard(tip: tip)],
      ),
    };
  }
}

class _VenueTipCard extends StatelessWidget {
  const new({required this.tip});

  final VenueTipEntity tip;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: .circular(12),
        color: FlutterLatamColors.mainBlue,
        border: .all(color: FlutterLatamColors.white.withValues(alpha: .1)),
      ),
      child: Padding(
        padding: const .all(16),
        child: Row(
          spacing: 12,
          crossAxisAlignment: .start,
          children: <Widget>[
            Icon(switch (tip.category) {
              .accommodation => Icons.hotel_rounded,
              .transportation => Icons.directions_transit_rounded,
              .deliveryApps => Icons.storefront_rounded,
              .food => Icons.restaurant_rounded,
              .security => Icons.security_rounded,
              .weather => Icons.wb_sunny_rounded,
              .currency => Icons.currency_exchange_rounded,
              .language => Icons.translate_rounded,
              .emergency => Icons.local_hospital_rounded,
              .other => Icons.info_outline_rounded,
            }, color: FlutterLatamColors.mediumBlue),
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: .start,
                children: <Widget>[
                  if (tip.title.isNotEmpty)
                    Text(
                      tip.title,
                      style: theme.typography.body3Regular.copyWith(
                        fontWeight: .w600,
                        color: FlutterLatamColors.white,
                      ),
                    ),
                  Text(
                    appLocalizations.value.localeName == 'es'
                        ? tip.descriptionEs
                        : tip.descriptionEn,
                    style: theme.typography.body4Regular.copyWith(
                      color: FlutterLatamColors.white.withValues(alpha: .65),
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
