import 'dart:async';

import 'package:flutter_conf_core/flutter_conf_core.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/routes/app_route_path.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/features/home/presentation/view_model/home_signals.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class HomeSponsors extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;

    final currentSponsors = sponsorsSignal.value;
    final pastSponsors = pastSponsorsSignal.value;

    return currentSponsors.maybeMap(
      data: (current) {
        if (current.isEmpty) return const SizedBox.shrink();

        final past = pastSponsors.maybeMap(
          data: (p) => p,
          orElse: () => <SponsorEntity>[],
        );

        final spotlight = current.where((s) => s.tier == .spotlight).toList();
        final regular = current.where((s) => s.tier != .spotlight).toList();

        return SectionContainer(
          spacing: 48,
          children: <Widget>[
            Text(
              l10n.homeSponsorsTitle,
              textAlign: .center,
              style: context.theme.fclThemeScheme.typography.h1Bold.copyWith(
                fontSize: switch (context.screenSize) {
                  .extraLarge => 64,
                  .large => 48,
                  .normal || .small => 32,
                },
                color: FlutterLatamColors.white,
              ),
            ),
            if (regular.isNotEmpty)
              Column(
                spacing: 32,
                mainAxisSize: .min,
                children: <Widget>[
                  _SectionLabel(
                    text: l10n.homeSponsorsConfirmedLabel,
                    color: FlutterLatamColors.mediumBlue,
                  ),
                  _CurrentSponsorsGrid(sponsors: regular),
                ],
              ),
            if (spotlight.isNotEmpty) ...[
              Divider(color: FlutterLatamColors.white.withValues(alpha: .1)),
              Column(
                spacing: 32,
                mainAxisSize: .min,
                children: <Widget>[
                  _SectionLabel(
                    text: l10n.homeSponsorsSpotlightLabel,
                    color: FlutterLatamColors.fuchsia,
                  ),
                  _CurrentSponsorsGrid(sponsors: spotlight),
                ],
              ),
            ],
            if (past.isNotEmpty)
              Column(
                spacing: 32,
                mainAxisSize: .min,
                children: <Widget>[
                  _SectionLabel(
                    text: l10n.homeSponsorsEditionsLabel,
                    color: FlutterLatamColors.white.withValues(alpha: .5),
                  ),
                  _PastSponsorsCarousel(sponsors: past),
                ],
              ),
            Center(
              child: FclButton.secondary(
                label: l10n.homeSponsorsWantToBeButton,
                buttonSize: .large,
                onPressed: () =>
                    context.go('/${AppRoutePath.sponsorship.pathName}'),
              ),
            ),
          ],
        );
      },
      orElse: () => const Offstage(),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const new({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;
    return Text(
      text,
      textAlign: TextAlign.center,
      style: theme.typography.captionRegular.copyWith(
        color: color,
        letterSpacing: 4,
        fontWeight: .w600,
      ),
    );
  }
}

class _CurrentSponsorsGrid extends StatelessWidget {
  const new({required this.sponsors});

  final List<SponsorEntity> sponsors;

  @override
  Widget build(BuildContext context) {
    final cardWidth = switch (context.screenSize) {
      .extraLarge => 260.0,
      .large => 220.0,
      _ => null,
    };

    if (cardWidth != null) {
      return Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: .center,
          children: <Widget>[
            for (final s in sponsors)
              _CurrentSponsorCard(sponsor: s, cardWidth: cardWidth),
          ],
        ),
      );
    }

    return Column(
      spacing: 12,
      children: <Widget>[
        for (final s in sponsors)
          _CurrentSponsorCard(sponsor: s, cardWidth: null),
      ],
    );
  }
}

class _CurrentSponsorCard extends HookWidget {
  const new({required this.sponsor, required this.cardWidth});

  final SponsorEntity sponsor;
  final double? cardWidth;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);

    final theme = context.theme.fclThemeScheme;
    final color = switch (sponsor.tier) {
      .platinum => FlutterLatamColors.mediumBlue,
      .gold => FlutterLatamColors.yellow,
      .silver => FlutterLatamColors.silver,
      .bronze => FlutterLatamColors.bronze,
      .inKind => FlutterLatamColors.fluorescent,
      .senior => FlutterLatamColors.lightBlue,
      .junior => FlutterLatamColors.lightYellow,
      .spotlight => FlutterLatamColors.fuchsia,
    };

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: cardWidth,
      decoration: BoxDecoration(
        color: FlutterLatamColors.darkBlue,
        borderRadius: .circular(16),
        border: .all(
          color: isHovered.value
              ? color.withValues(alpha: .45)
              : FlutterLatamColors.white.withValues(alpha: .08),
          width: 1.5,
        ),
      ),
      padding: const .symmetric(horizontal: 32, vertical: 24),
      child: SizedBox(
        height: switch (context.screenSize) {
          .extraLarge => 90,
          .large => 70,
          _ => 56,
        },
        child: _GrayscaleLogo(url: sponsor.logoUrl, isHovered: isHovered.value),
      ),
    );

    final badge = sponsor.tier == .spotlight
        ? null
        : AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const .symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: .circular(100),
              color: color.withValues(alpha: isHovered.value ? .12 : .06),
              border: .all(
                color: color.withValues(alpha: isHovered.value ? .8 : .4),
              ),
            ),
            child: Text(
              switch (sponsor.tier) {
                .platinum => appLocalizations.value.homeSponsorPlatinum,
                .gold => appLocalizations.value.homeSponsorGold,
                .silver => appLocalizations.value.homeSponsorSilver,
                .bronze => appLocalizations.value.homeSponsorsBronze,
                .inKind => appLocalizations.value.homeSponsorInKind,
                .senior => appLocalizations.value.homeSponsorSenior,
                .junior => appLocalizations.value.homeSponsorJunior,
                .spotlight => appLocalizations.value.homeSponsorSpotlight,
              }.toUpperCase(),
              style: theme.typography.captionRegular.copyWith(
                color: color,
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: .w600,
              ),
            ),
          );

    return MouseRegion(
      cursor: sponsor.websiteUrl != null ? SystemMouseCursors.click : .defer,
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onTap: () {
          if (sponsor.websiteUrl != null) {
            unawaited(Utils.launchUrlLink(sponsor.websiteUrl!));
          }
        },
        child: SizedBox(
          width: cardWidth,
          child: Column(
            spacing: 10,
            mainAxisSize: .min,
            children: <Widget>[card, ?badge],
          ),
        ),
      ),
    );
  }
}

class _PastSponsorsCarousel extends StatefulWidget {
  const new({required this.sponsors});

  final List<SponsorEntity> sponsors;

  @override
  State<_PastSponsorsCarousel> createState() => _PastSponsorsCarouselState();
}

class _PastSponsorsCarouselState extends State<_PastSponsorsCarousel> {
  late final ScrollController _scrollController;
  late final List<SponsorEntity> _items;

  Timer? _timer;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _items = [...widget.sponsors, ...widget.sponsors];
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScroll());
  }

  void _startScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (_isHovered || !_scrollController.hasClients) return;
      final max = _scrollController.position.maxScrollExtent;
      final half = max / 2;

      if (_scrollController.offset >= half) {
        _scrollController.jumpTo(_scrollController.offset - half);
      } else {
        _scrollController.jumpTo(_scrollController.offset + 1.5);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        height: switch (context.screenSize) {
          .extraLarge || .large => 100,
          _ => 72,
        },
        child: ListView.separated(
          itemCount: _items.length,
          scrollDirection: .horizontal,
          controller: _scrollController,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (_, i) => _PastSponsorCard(sponsor: _items[i]),
        ),
      ),
    );
  }
}

class _PastSponsorCard extends HookWidget {
  const new({required this.sponsor});

  final SponsorEntity sponsor;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);

    final cardHeight = switch (context.screenSize) {
      .extraLarge || .large => 100.0,
      _ => 72.0,
    };

    return MouseRegion(
      cursor: sponsor.websiteUrl != null ? SystemMouseCursors.click : .defer,
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onTap: () {
          if (sponsor.websiteUrl != null) {
            unawaited(Utils.launchUrlLink(sponsor.websiteUrl!));
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: cardHeight * (16 / 9),
          height: cardHeight,
          decoration: BoxDecoration(
            color: FlutterLatamColors.darkBlue,
            borderRadius: .circular(12),
            border: .all(
              color: isHovered.value
                  ? FlutterLatamColors.white.withValues(alpha: .25)
                  : FlutterLatamColors.white.withValues(alpha: .08),
            ),
          ),
          padding: const .symmetric(horizontal: 20, vertical: 12),
          child: _GrayscaleLogo(
            url: sponsor.logoUrl,
            isHovered: isHovered.value,
          ),
        ),
      ),
    );
  }
}

class _GrayscaleLogo extends StatelessWidget {
  const new({required this.url, required this.isHovered});

  final String url;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: <Widget>[
        SvgPicture.network(url),
        AnimatedOpacity(
          opacity: isHovered ? 0 : 1,
          duration: const Duration(milliseconds: 250),
          child: ColorFiltered(
            colorFilter: const ColorFilter.matrix(Utils.grayscaleMatrix),
            child: SvgPicture.network(url),
          ),
        ),
      ],
    );
  }
}
