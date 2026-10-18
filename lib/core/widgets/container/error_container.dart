import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class ErrorContainer extends SignalWidget {
  const new({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;

    return Column(
      spacing: 40,
      mainAxisSize: .min,
      children: <Widget>[
        TitleSubtitleText(
          spacing: 20,
          title: (
            text: l10n.errorDataTitle,
            size: switch (context.screenSize) {
              .extraLarge => 48,
              .large => 32,
              .normal || .small => 16,
            },
          ),
          subtitle: (
            text: l10n.errorDataMessage,
            size: switch (context.screenSize) {
              .extraLarge || .large => 20,
              .normal || .small => 12,
            },
          ),
          textAlign: .start,
        ),
        FclButton.primary(
          label: l10n.errorDataRetryButton,
          buttonSize: .small,
          onPressed: onRetry,
        ),
      ],
    );
  }
}
