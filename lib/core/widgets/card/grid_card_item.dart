import 'package:flutter/gestures.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';

class GridCardItem extends StatelessWidget {
  const new({
    required this.title,
    required this.description,
    this.imagePath,
    this.icon,
    this.url,
    super.key,
  });

  final String title;
  final String description;
  final String? imagePath;
  final IconData? icon;
  final ({String url, String text})? url;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return Card(
      color: const Color(0xFF2E5288),
      clipBehavior: .antiAliasWithSaveLayer,
      child: Padding(
        padding: const .all(28),
        child: Column(
          spacing: 10,
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: <Widget>[
            Row(
              spacing: 8,
              crossAxisAlignment: .start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: switch (context.screenSize) {
                      .extraLarge => theme.typography.h3Bold,
                      _ => theme.typography.h4Bold,
                    },
                  ),
                ),
                if (imagePath != null)
                  SizedBox.square(
                    dimension: 80,
                    child: Image.asset(imagePath!, semanticLabel: title),
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    size: 64,
                    color: FlutterLatamColors.white,
                    semanticLabel: title,
                  ),
              ],
            ),
            Text.rich(
              TextSpan(
                text: description,
                children: <InlineSpan>[
                  if (url != null)
                    TextSpan(
                      text: url!.text,
                      style: theme.typography.body3Regular.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: FlutterLatamColors.white,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Utils.launchUrlLink(url!.url),
                    ),
                ],
              ),
              style: theme.typography.body3Regular,
            ),
          ],
        ),
      ),
    );
  }
}
