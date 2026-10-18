import 'dart:async';

import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class CountDownText extends SignalStatefulWidget {
  const new({
    required this.startDate,
    required this.endDate,
    this.label,
    super.key,
  });

  final DateTime startDate;
  final DateTime endDate;
  final String? label;

  @override
  State<CountDownText> createState() => _CountDownTextState();
}

class _CountDownTextState extends State<CountDownText> {
  Duration _duration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _duration = widget.endDate.difference(widget.startDate);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final theme = context.theme.fclThemeScheme;

    if (_duration <= Duration.zero) {
      return Center(
        child: TitleSubtitleText(
          title: (
            text: l10n.homeCountDownFinishTitle,
            size: switch (context.screenSize) {
              .extraLarge => 84,
              .large => 64,
              .normal || .small => 24,
            },
          ),
          subtitle: (
            text: l10n.homeCountDownFinishMessage,
            size: switch (context.screenSize) {
              .extraLarge || .large => 24,
              .normal || .small => 20,
            },
          ),
        ),
      );
    }

    final days = _duration.inDays.toString();
    final hours = _twoDigits(_duration.inHours.remainder(24));
    final minutes = _twoDigits(_duration.inMinutes.remainder(60));
    final seconds = _twoDigits(_duration.inSeconds.remainder(60));

    final items = [
      (value: days, label: l10n.homeCountDownDays),
      (value: hours, label: l10n.homeCountDownHours),
      (value: minutes, label: l10n.homeCountDownMinutes),
      (value: seconds, label: l10n.homeCountDownSeconds),
    ];

    final numberSize = switch (context.screenSize) {
      .extraLarge => 56.0,
      .large => 44.0,
      .normal || .small => 28.0,
    };

    final labelSize = switch (context.screenSize) {
      .extraLarge || .large => 12.0,
      .normal || .small => 10.0,
    };

    return Column(
      spacing: 16,
      mainAxisSize: .min,
      children: <Widget>[
        Text(
          widget.label ?? l10n.homeCountDownLabel,
          style: theme.typography.captionRegular.copyWith(
            color: FlutterLatamColors.white.withValues(alpha: .5),
            letterSpacing: 3,
            fontWeight: .w500,
          ),
        ),
        Row(
          spacing: switch (context.screenSize) {
            .extraLarge || .large => 12,
            _ => 6,
          },
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          crossAxisAlignment: .start,
          children: <Widget>[
            for (var i = 0; i < items.length; i++) ...[
              _CountdownUnit(
                value: items[i].value,
                label: items[i].label,
                cardSize: switch (context.screenSize) {
                  .extraLarge => 120,
                  .large => 96,
                  .normal || .small => 64,
                },
                numberSize: numberSize,
                labelSize: labelSize,
                animate: i == 3,
              ),
              if (i < items.length - 1)
                Padding(
                  padding: .only(top: labelSize),
                  child: Text(
                    ':',
                    style: theme.typography.h1Bold.copyWith(
                      fontSize: numberSize,
                      color: FlutterLatamColors.white.withValues(alpha: .4),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ],
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _duration = _duration - const Duration(seconds: 1);
        if (_duration.inSeconds <= 0) {
          _timer?.cancel();
          _duration = Duration.zero;
        }
      });
    });
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}

class _CountdownUnit extends StatelessWidget {
  const new({
    required this.value,
    required this.label,
    required this.cardSize,
    required this.numberSize,
    required this.labelSize,
    required this.animate,
  });

  final String value;
  final String label;
  final double cardSize;
  final double numberSize;
  final double labelSize;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return Column(
      spacing: 8,
      mainAxisSize: .min,
      children: <Widget>[
        SizedBox.square(
          dimension: cardSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: .circular(16),
              color: FlutterLatamColors.darkBlue,
              border: .all(
                color: FlutterLatamColors.white.withValues(alpha: .08),
              ),
            ),
            child: Center(
              child: switch (animate) {
                true => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    final slide = Tween<Offset>(
                      begin: const Offset(0, .5),
                      end: .zero,
                    ).animate(animation);

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: slide, child: child),
                    );
                  },
                  child: Text(
                    value,
                    key: ValueKey(value),
                    style: theme.typography.h1Bold.copyWith(
                      fontSize: numberSize,
                      color: FlutterLatamColors.white,
                    ),
                  ),
                ),
                false => Text(
                  value,
                  style: theme.typography.h1Bold.copyWith(
                    fontSize: numberSize,
                    color: FlutterLatamColors.white,
                  ),
                ),
              },
            ),
          ),
        ),
        Text(
          label.toUpperCase(),
          style: theme.typography.captionRegular.copyWith(
            fontSize: labelSize,
            color: FlutterLatamColors.white.withValues(alpha: .5),
            letterSpacing: 2,
            fontWeight: .w500,
          ),
        ),
      ],
    );
  }
}
