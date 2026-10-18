import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';

typedef TextWithSize = ({String text, double size});

class TitleSubtitleText extends StatelessWidget {
  const new({
    this.title,
    this.subtitle,
    this.textAlign = .center,
    this.crossAxisAlignment = .center,
    this.spacing = 0,
    super.key,
  });

  final TextWithSize? title;
  final TextWithSize? subtitle;
  final TextAlign textAlign;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return Column(
      spacing: spacing,
      mainAxisSize: .min,
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        if (title != null)
          Text(
            title!.text,
            textAlign: textAlign,
            style: theme.typography.h1Bold.copyWith(fontSize: title!.size),
          ),
        if (subtitle != null)
          Text(
            subtitle!.text,
            textAlign: textAlign,
            style: theme.typography.subH1Regular.copyWith(
              fontSize: subtitle!.size,
            ),
          ),
      ],
    );
  }
}

class TitleSubtitleTextContainer extends StatelessWidget {
  const new({this.crossAxisAlignment = .center, super.key});

  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: FlutterLatamColors.darkBlue,
      borderRadius: .circular(16),
    );

    return Column(
      spacing: 16,
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        SizedBox.fromSize(
          size: const Size(200, 24),
          child: DecoratedBox(decoration: decoration),
        ),
        SizedBox.fromSize(
          size: const Size(100, 24),
          child: DecoratedBox(decoration: decoration),
        ),
      ],
    );
  }
}
