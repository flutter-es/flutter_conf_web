import 'package:flutter_conf_latam/core/models/edition_model.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/painter/vertical_line_painter.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class HomeTimeline extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      spacing: 48,
      children: <Widget>[
        TitleSubtitleText(
          title: (
            text: appLocalizations.value.homeTimelineTitle,
            size: switch (context.screenSize) {
              .extraLarge => 64,
              .large => 48,
              .normal || .small => 32,
            },
          ),
          subtitle: (
            text: appLocalizations.value.homeTimelineSubtitle,
            size: switch (context.screenSize) {
              .extraLarge || .large => 24,
              .normal || .small => 16,
            },
          ),
          spacing: 12,
        ),
        _TimelineSection(editions: editions(appLocalizations.value)),
      ],
    );
  }
}

class _TimelineSection extends StatefulWidget {
  const new({required this.editions});

  final List<EditionModel> editions;

  @override
  State<_TimelineSection> createState() => _TimelineSectionState();
}

class _TimelineSectionState extends State<_TimelineSection> {
  late final List<GlobalKey> _keys;
  late final List<bool> _visible;

  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();

    _keys = List.generate(widget.editions.length, (_) => GlobalKey());
    _visible = List.filled(widget.editions.length, false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;

    if (position != null && position != _scrollPosition) {
      _scrollPosition?.removeListener(_checkVisibility);
      _scrollPosition = position;
      _scrollPosition!.addListener(_checkVisibility);
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_checkVisibility);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (context.screenSize) {
      .extraLarge || .large => _DesktopTimeline(
        editions: widget.editions,
        keys: _keys,
        visible: _visible,
      ),
      _ => _MobileTimeline(
        editions: widget.editions,
        keys: _keys,
        visible: _visible,
      ),
    };
  }

  void _checkVisibility() {
    if (!mounted) return;

    final screenHeight = MediaQuery.of(context).size.height;
    var changed = false;

    for (var i = 0; i < _keys.length; i++) {
      final renderBox =
          _keys[i].currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.attached) continue;

      final topLeft = renderBox.localToGlobal(.zero);
      final itemHeight = renderBox.size.height;

      final isInView =
          topLeft.dy + itemHeight > screenHeight * 0.1 &&
          topLeft.dy < screenHeight * 0.88;

      if (_visible[i] != isInView) {
        _visible[i] = isInView;
        changed = true;
      }
    }
    if (changed) setState(() {});
  }
}

class _DesktopTimeline extends StatelessWidget {
  const new({
    required this.editions,
    required this.keys,
    required this.visible,
  });

  final List<EditionModel> editions;
  final List<GlobalKey> keys;
  final List<bool> visible;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: VerticalLinePainter(
        getX: (w) => w / 2,
        color: FlutterLatamColors.mediumBlue.withValues(alpha: .22),
      ),
      child: Column(
        children: <Widget>[
          for (var i = 0; i < editions.length; i++)
            _AnimatedItem(
              itemKey: keys[i],
              visible: visible[i],
              child: Row(
                spacing: 36,
                children: <Widget>[
                  Expanded(
                    child: i.isEven
                        ? Align(
                            alignment: .centerRight,
                            child: _EditionCard(edition: editions[i]),
                          )
                        : const SizedBox(),
                  ),
                  _TimelineDot(isCurrent: editions[i].isCurrent),
                  Expanded(
                    child: i.isOdd
                        ? Align(
                            alignment: .centerLeft,
                            child: _EditionCard(edition: editions[i]),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MobileTimeline extends StatelessWidget {
  const new({
    required this.editions,
    required this.keys,
    required this.visible,
  });

  final List<EditionModel> editions;
  final List<GlobalKey> keys;
  final List<bool> visible;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: VerticalLinePainter(
        getX: (_) => 20,
        color: FlutterLatamColors.mediumBlue.withValues(alpha: .22),
      ),
      child: Column(
        children: <Widget>[
          for (var i = 0; i < editions.length; i++)
            _AnimatedItem(
              itemKey: keys[i],
              visible: visible[i],
              child: Row(
                spacing: 16,
                crossAxisAlignment: .start,
                children: <Widget>[
                  Padding(
                    padding: const .only(top: 28),
                    child: _TimelineDot(isCurrent: editions[i].isCurrent),
                  ),
                  Expanded(child: _EditionCard(edition: editions[i])),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AnimatedItem extends StatelessWidget {
  const new({
    required this.itemKey,
    required this.visible,
    required this.child,
  });

  final GlobalKey itemKey;
  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: visible ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        offset: visible ? .zero : const Offset(0, 0.05),
        child: Padding(
          key: itemKey,
          padding: const .symmetric(vertical: 20),
          child: child,
        ),
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const new({required this.isCurrent});

  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    if (isCurrent) {
      return SizedBox.square(
        dimension: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: .circle,
            color: FlutterLatamColors.mediumBlue.withValues(alpha: .15),
            border: .all(
              color: FlutterLatamColors.mediumBlue.withValues(alpha: .5),
            ),
          ),
          child: const Center(
            child: SizedBox.square(
              dimension: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: .circle,
                  color: FlutterLatamColors.mediumBlue,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox.square(
      dimension: 40,
      child: Center(
        child: SizedBox.square(
          dimension: 12,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: .circle,
              color: FlutterLatamColors.mainBlue,
              border: .all(
                color: FlutterLatamColors.white.withValues(alpha: .5),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditionCard extends SignalWidget {
  const new({required this.edition});

  final EditionModel edition;

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final theme = context.theme.fclThemeScheme;

    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const .all(24),
      decoration: BoxDecoration(
        borderRadius: .circular(20),
        color: edition.isCurrent
            ? FlutterLatamColors.darkBlue
            : FlutterLatamColors.white.withValues(alpha: .04),
        border: .all(
          color: edition.isCurrent
              ? FlutterLatamColors.mediumBlue.withValues(alpha: .3)
              : FlutterLatamColors.white.withValues(alpha: .08),
        ),
      ),
      child: Column(
        spacing: 12,
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: <Widget>[
          Container(
            padding: const .symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: .circular(100),
              color: FlutterLatamColors.mediumBlue.withValues(alpha: .12),
              border: .all(
                color: FlutterLatamColors.mediumBlue.withValues(alpha: .35),
              ),
            ),
            child: Text(
              edition.isCurrent
                  ? '${edition.label} · ${l10n.homeTimelineCurrentBadge}'
                  : edition.label,
              style: theme.typography.captionRegular.copyWith(
                color: FlutterLatamColors.mediumBlue,
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: .w600,
              ),
            ),
          ),
          Row(
            spacing: 10,
            children: <Widget>[
              Text(edition.flag, style: const TextStyle(fontSize: 28)),
              Expanded(
                child: Text(
                  '${edition.year} · ${edition.city}',
                  style: theme.typography.h1Bold.copyWith(
                    fontSize: 26,
                    color: FlutterLatamColors.white,
                  ),
                ),
              ),
            ],
          ),
          Text(
            edition.country,
            style: theme.typography.body3Regular.copyWith(
              color: FlutterLatamColors.white.withValues(alpha: .5),
            ),
          ),
        ],
      ),
    );
  }
}
