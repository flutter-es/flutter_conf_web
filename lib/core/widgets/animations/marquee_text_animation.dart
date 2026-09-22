import 'package:flutter/material.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';

class MarqueeTextAnimation extends StatefulWidget {
  const MarqueeTextAnimation({required this.text, this.speed = 80, super.key});

  final String text;
  final double speed;

  @override
  State<MarqueeTextAnimation> createState() => _MarqueeTextAnimationState();
}

class _MarqueeTextAnimationState extends State<MarqueeTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  double? _textWidth;
  double? _screenWidth;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateDimensions();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_textWidth == null || _screenWidth == null) return const Offstage();

    final currentTextWidth = _textWidth!;
    final currentScreenWidth = _screenWidth!;

    return ClipRect(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) {
          final totalWidth = currentTextWidth + currentScreenWidth;
          return Transform.translate(
            offset: Offset(-_animationController.value * totalWidth, 0),
            child: OverflowBox(
              minWidth: 0,
              maxWidth: double.infinity,
              child: child,
            ),
          );
        },
        child: Row(
          spacing: currentScreenWidth,
          children: <Widget>[
            Text(widget.text, style: _currentStyle),
            Text(widget.text, style: _currentStyle),
          ],
        ),
      ),
    );
  }

  TextStyle get _currentStyle {
    final theme = context.theme.fclThemeScheme;
    final textStyle = switch (context.screenSize) {
      .extraLarge => theme.typography.body1Regular,
      .large => theme.typography.body2Regular,
      _ => theme.typography.body3Regular,
    };
    return textStyle.copyWith(color: FlutterLatamColors.black);
  }

  void _calculateDimensions() {
    if (!mounted) return;

    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: _currentStyle),
      maxLines: 1,
      textDirection: .ltr,
    )..layout();

    setState(() {
      _textWidth = textPainter.size.width;
      _screenWidth = MediaQuery.sizeOf(context).width;

      if (_textWidth != null && _screenWidth != null) {
        final totalWidth = _textWidth! + _screenWidth!;
        _animationController.duration = Duration(
          milliseconds: (totalWidth / widget.speed * 1000).toInt(),
        );

        _animationController
          ..forward(from: 0)
          ..repeat();
      }
    });
  }
}
