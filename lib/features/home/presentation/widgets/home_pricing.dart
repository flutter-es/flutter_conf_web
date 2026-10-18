import 'dart:async';

import 'package:flutter_conf_core/flutter_conf_core.dart';
import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/extensions/extension_methods.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/dialog/data_protection_dialog.dart';
import 'package:flutter_conf_latam/core/widgets/dialog/main_dialog.dart';
import 'package:flutter_conf_latam/core/widgets/text/count_down_text.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/features/home/presentation/view_model/home_signals.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

enum _CardState { soldOut, availableNow, comingSoon }

class HomePricing extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final pricingList = pricingSignal.value;

    return pricingList.maybeMap(
      data: (data) {
        if (data.isEmpty) return const Offstage();
        final activeTier = DateTime.now().ticketDate(data);

        return SectionContainer(
          spacing: 48,
          children: <Widget>[
            TitleSubtitleText(
              title: (
                text: appLocalizations.value.homePricingTitle,
                size: switch (context.screenSize) {
                  .extraLarge => 64,
                  .large => 48,
                  .normal || .small => 24,
                },
              ),
              subtitle: (
                text: appLocalizations.value.homePricingDescription,
                size: switch (context.screenSize) {
                  .extraLarge || .large => 24,
                  .normal || .small => 16,
                },
              ),
              spacing: 12,
            ),
            if (activeTier != null) ...[
              CountDownText(
                startDate: DateTime.now(),
                endDate: activeTier.endDate,
                label: appLocalizations.value.homePricingCountdownLabel,
              ),
              Center(
                child: _PriceGoesUpBadge(
                  date: activeTier.endDate.add(const Duration(days: 1)),
                ),
              ),
            ],
            if (data.length == 1)
              Center(
                child: SizedBox(
                  width: switch (context.screenSize) {
                    .extraLarge || .large => 380,
                    _ => .infinity,
                  },
                  child: _PricingCard(ticket: data.first),
                ),
              )
            else
              switch (context.screenSize) {
                .extraLarge || .large => LayoutBuilder(
                  builder: (_, constraints) {
                    final n = data.length;
                    final cardWidth = (constraints.maxWidth - 16 * (n - 1)) / n;

                    return IntrinsicHeight(
                      child: Row(
                        spacing: 16,
                        crossAxisAlignment: .stretch,
                        children: <Widget>[
                          for (final t in data)
                            SizedBox(
                              width: cardWidth,
                              child: _PricingCard(ticket: t),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                _ => Column(
                  spacing: 16,
                  children: <Widget>[
                    for (final t in data) _PricingCard(ticket: t),
                  ],
                ),
              },
          ],
        );
      },
      orElse: () => const Offstage(),
    );
  }
}

class _PriceGoesUpBadge extends StatelessWidget {
  const new({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return Container(
      padding: const .symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: .circular(100),
        color: FlutterLatamColors.yellow.withValues(alpha: .12),
        border: .all(color: FlutterLatamColors.yellow.withValues(alpha: .4)),
      ),
      child: Row(
        spacing: 8,
        mainAxisSize: .min,
        children: <Widget>[
          const Icon(
            Icons.access_time_rounded,
            size: 14,
            color: FlutterLatamColors.yellow,
          ),
          Text(
            appLocalizations.value.homePricingPriceGoesUp(date),
            style: theme.typography.captionRegular.copyWith(
              letterSpacing: 1,
              fontWeight: .w500,
              color: FlutterLatamColors.yellow,
            ),
          ),
        ],
      ),
    );
  }
}

class _PricingCard extends SignalWidget {
  const new({required this.ticket});

  final TicketPricingEntity ticket;

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;

    final theme = context.theme.fclThemeScheme;
    const whiteColor = FlutterLatamColors.white;

    final state = switch (DateTime.now()) {
      DateTime(:final isAfter) when isAfter(ticket.endDate) =>
        _CardState.soldOut,
      DateTime(:final isBefore) when !isBefore(ticket.startDate) =>
        _CardState.availableNow,
      _ => _CardState.comingSoon,
    };

    final priceColor = switch (state) {
      .soldOut => whiteColor.withValues(alpha: .3),
      .availableNow => ticket.color.toColor,
      .comingSoon => whiteColor,
    };

    return Card.filled(
      margin: .zero,
      color: switch (state) {
        .availableNow => ticket.color.toColor.withValues(alpha: .2),
        _ => Colors.transparent,
      },
      clipBehavior: .antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(20),
        side: BorderSide(
          color: switch (state) {
            .availableNow => ticket.color.toColor.withValues(alpha: .35),
            _ => whiteColor.withValues(alpha: .08),
          },
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const .all(24),
        child: Column(
          spacing: 50,
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: .start,
          children: <Widget>[
            Column(
              spacing: 20,
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: <Widget>[
                Align(
                  alignment: .centerLeft,
                  child: Container(
                    padding: const .symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: switch (state) {
                        .soldOut => whiteColor.withValues(alpha: .08),
                        .availableNow => ticket.color.toColor.withValues(
                          alpha: .12,
                        ),
                        .comingSoon => whiteColor.withValues(alpha: .05),
                      },
                      borderRadius: .circular(100),
                      border: .all(
                        color: switch (state) {
                          .soldOut => whiteColor.withValues(alpha: .2),
                          .availableNow => ticket.color.toColor.withValues(
                            alpha: .5,
                          ),
                          .comingSoon => whiteColor.withValues(alpha: .1),
                        },
                      ),
                    ),
                    child: Text(
                      switch (state) {
                        .soldOut => l10n.homePricingSoldOut.toUpperCase(),
                        .availableNow => l10n.homePricingAvailableNow,
                        .comingSoon => l10n.homePricingComingSoon,
                      },
                      style: theme.typography.captionRegular.copyWith(
                        color: switch (state) {
                          .soldOut => whiteColor.withValues(alpha: .5),
                          .availableNow => ticket.color.toColor,
                          .comingSoon => whiteColor.withValues(alpha: .3),
                        },
                        fontSize: 11,
                        letterSpacing: 2,
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                ),
                Text(
                  ticket.name,
                  style: theme.typography.h1Bold.copyWith(
                    fontSize: switch (context.screenSize) {
                      .extraLarge || .large => 22,
                      _ => 18,
                    },
                    color: whiteColor,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: '${ticket.currency} ',
                        style: theme.typography.body3Regular.copyWith(
                          color: priceColor,
                          fontWeight: .w600,
                        ),
                      ),
                      TextSpan(
                        text: ticket.price.toStringAsFixed(0),
                        style: theme.typography.h1Bold.copyWith(
                          fontSize: switch (context.screenSize) {
                            .extraLarge || .large => 36,
                            _ => 24,
                          },
                          color: priceColor,
                          decoration: state == .soldOut ? .lineThrough : null,
                          decorationColor: priceColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (state != .soldOut)
                  Text(
                    l10n.homePricingDateRange(ticket.startDate, ticket.endDate),
                    style: theme.typography.body4Regular.copyWith(
                      color: whiteColor.withValues(alpha: .5),
                    ),
                  ),
                Divider(color: whiteColor.withValues(alpha: .08), height: 1),
                _BenefitsSection(
                  benefits: l10n.localeName == 'es'
                      ? ticket.benefitsEs
                      : ticket.benefitsEn,
                ),
              ],
            ),
            if (state == .availableNow)
              SizedBox(
                width: .infinity,
                child: FclButton.primary(
                  label: l10n.homePricingBuyTicketsButton,
                  buttonSize: .small,
                  onPressed: () {
                    final url = ticket.url ?? appConfig.value.ticketPageUrl;
                    const showDisclaimer = bool.fromEnvironment(
                      'SHOW_DISCLAIMER_DIALOG',
                    );

                    if (showDisclaimer) {
                      unawaited(_showDisclaimerDialog(context, url));
                    } else {
                      unawaited(Utils.launchUrlLink(url));
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDisclaimerDialog(BuildContext context, String url) async {
    final result = await MainDialog.show<bool>(
      context,
      child: const DataProtectionDialog(),
    );
    if (result ?? false) unawaited(Utils.launchUrlLink(url));
  }
}

class _BenefitsSection extends StatelessWidget {
  const new({required this.benefits});

  final List<String> benefits;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return Column(
      spacing: 10,
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: <Widget>[
        for (final item in benefits)
          Row(
            spacing: 8,
            crossAxisAlignment: .start,
            children: <Widget>[
              const Icon(
                Icons.check_rounded,
                size: 14,
                color: FlutterLatamColors.lightGreen,
              ),
              Expanded(
                child: Text(
                  item,
                  style: theme.typography.body4Regular.copyWith(
                    color: FlutterLatamColors.white.withValues(alpha: .8),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
