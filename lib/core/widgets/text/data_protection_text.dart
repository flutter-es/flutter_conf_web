import 'package:flutter/gestures.dart';
import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class DataProtectionText extends SignalWidget {
  const new({this.textAlign = .start, this.textSize, super.key});

  final TextAlign textAlign;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final config = appConfig.value;

    final theme = context.theme.fclThemeScheme;
    final textTheme = switch (context.screenSize) {
      .extraLarge ||
      .large => theme.typography.body3Regular.copyWith(fontSize: textSize),
      .normal ||
      .small => theme.typography.body4Regular.copyWith(fontSize: textSize),
    };

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: l10n.dataProtectionDialogParagraphOne,
            style: textTheme.copyWith(fontStyle: .italic),
          ),
          TextSpan(
            text: l10n.dataProtectionDialogParagraphTwo,
            style: textTheme,
            children: <InlineSpan>[
              TextSpan(
                text: l10n.dataProtectionDialogParagraphTwoBold,
                style: textTheme.copyWith(fontWeight: .bold),
              ),
            ],
          ),
          TextSpan(
            text: l10n.dataProtectionDialogParagraphThree,
            style: textTheme,
            children: <InlineSpan>[
              TextSpan(
                text: l10n.dataProtectionDialogLinkText,
                style: textTheme.copyWith(
                  decoration: .underline,
                  decorationColor: FlutterLatamColors.white,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Utils.launchUrlLink(config.privacyPolicyUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
