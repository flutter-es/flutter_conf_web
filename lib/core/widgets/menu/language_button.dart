import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/l10n/gen/app_localizations.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/l10n/support_locale.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class LanguageButton extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = currentLocale.value.languageCode;

    return Container(
      height: 50,
      width: switch (context.screenSize) {
        .extraLarge || .large => 160,
        .normal || .small => 100,
      },
      margin: const .all(10),
      decoration: const BoxDecoration(
        color: FlutterLatamColors.mediumBlue,
        borderRadius: .all(.circular(60)),
      ),
      child: Stack(
        children: <Widget>[
          FractionallySizedBox(
            widthFactor: .5,
            child: Container(
              margin: const .all(5),
              decoration: BoxDecoration(
                color: FlutterLatamColors.darkBlue,
                borderRadius: .circular(20),
              ),
            ),
          ).animate().slideX(
            begin: languageCode == SupportLocale.en.languageCode ? 1 : 0,
            end: languageCode == SupportLocale.en.languageCode ? 0 : 1,
            duration: 1.seconds,
          ),
          Row(
            children: <Widget>[
              for (final local in AppLocalizations.supportedLocales)
                Expanded(
                  child: _LanguageItem(
                    title: local.languageCode,
                    isActive: languageCode == local.languageCode,
                    onTap: () => updateLocale(local),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageItem extends StatelessWidget {
  const new({required this.title, required this.isActive, required this.onTap});

  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return Center(
      child: ClipRRect(
        borderRadius: const .all(.circular(20)),
        child: InkWell(
          onTap: onTap,
          mouseCursor: SystemMouseCursors.click,
          child: Text(
            title.toUpperCase(),
            textAlign: .center,
            style: theme.typography.h4Bold.copyWith(
              fontSize: 16,
              color: switch (isActive) {
                true => FlutterLatamColors.white,
                false => FlutterLatamColors.darkBlue,
              },
            ),
          ),
        ),
      ),
    );
  }
}
