import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/container/dialog_container.dart';
import 'package:flutter_conf_latam/core/widgets/text/data_protection_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class DataProtectionDialog extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final theme = context.theme.fclThemeScheme;

    final paddingTop = switch (context.screenSize) {
      .extraLarge || .large => 64.0,
      .normal || .small => 60.0,
    };

    final dialogMessageStyle = switch (context.screenSize) {
      .extraLarge || .large => theme.typography.body2Regular,
      .normal || .small => theme.typography.body3Regular,
    };

    return SafeArea(
      bottom: false,
      child: DialogContainer(
        child: Padding(
          padding: .fromLTRB(36, paddingTop, 36, 42),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: .min,
              spacing: switch (context.screenSize) {
                .extraLarge || .large => 26,
                .normal || .small => 20,
              },
              children: <Widget>[
                Text(
                  l10n.dataProtectionDialogTitle,
                  style: switch (context.screenSize) {
                    .extraLarge || .large => theme.typography.h4Bold,
                    .normal || .small => theme.typography.subH2Semibold,
                  },
                ),
                const DataProtectionText(),
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(text: l10n.dataProtectionDialogButtonMessageOne),
                      TextSpan(
                        text: l10n.dataProtectionDialogButtonMessageBold,
                        style: dialogMessageStyle.copyWith(fontWeight: .bold),
                      ),
                      TextSpan(text: l10n.dataProtectionDialogButtonMessageTwo),
                    ],
                  ),
                  style: dialogMessageStyle,
                ),
                FclButton.primary(
                  label: l10n.dataProtectionDialogAcceptButton,
                  buttonSize: .small,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
