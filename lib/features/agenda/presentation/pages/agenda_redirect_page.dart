import 'package:flutter/material.dart';
import 'package:flutter_conf_latam/core/config/config.dart';
import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:signals/signals_flutter.dart';
import 'package:universal_html/html.dart' as html;

class AgendaRedirectPage extends SignalWidget {
  const AgendaRedirectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;
    final l10n = appLocalizations.value;

    final config = appConfig.value;
    final storeUrl = _storeUrlForUserAgent(config);

    if (storeUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        html.window.location.assign(storeUrl);
      });
    }

    final storeLinks = <({String imagePath, String url})>[
      (imagePath: Assets.images.novelties.appStore, url: config.appStoreUrl),
      (imagePath: Assets.images.novelties.googlePlay, url: config.googleAppUrl),
    ];

    return Scaffold(
      backgroundColor: FlutterLatamColors.mainBlue,
      body: Center(
        child: Padding(
          padding: const .all(32),
          child: Column(
            mainAxisSize: .min,
            children: <Widget>[
              if (storeUrl != null) ...[
                const CircularProgressIndicator(
                  color: FlutterLatamColors.white,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.agendaRedirectTitle,
                  textAlign: .center,
                  style: theme.typography.h1Bold.copyWith(
                    color: FlutterLatamColors.white,
                    fontSize: switch (context.screenSize) {
                      .extraLarge || .large => 32,
                      _ => 24,
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.agendaRedirectSubtitle,
                  textAlign: .center,
                  style: theme.typography.body1Regular.copyWith(
                    color: FlutterLatamColors.white.withValues(alpha: .7),
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Utils.launchUrlLink(storeUrl),
                  child: Text(
                    l10n.agendaRedirectManualLink,
                    style: theme.typography.body1Regular.copyWith(
                      color: FlutterLatamColors.mediumBlue,
                      decoration: .underline,
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  l10n.agendaRedirectDesktopTitle,
                  textAlign: .center,
                  style: theme.typography.h1Bold.copyWith(
                    color: FlutterLatamColors.white,
                    fontSize: switch (context.screenSize) {
                      .extraLarge || .large => 32,
                      _ => 24,
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.agendaRedirectDesktopMessage,
                  textAlign: .center,
                  style: theme.typography.body1Regular.copyWith(
                    color: FlutterLatamColors.white.withValues(alpha: .7),
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: .center,
                  children: <Widget>[
                    for (final item in storeLinks)
                      InkWell(
                        onTap: () => Utils.launchUrlLink(item.url),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 200,
                            maxHeight: 60,
                          ),
                          child: Image.asset(item.imagePath, fit: .contain),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? _storeUrlForUserAgent(Config config) {
    final ua = html.window.navigator.userAgent.toLowerCase();
    final maxTouchPoints = html.window.navigator.maxTouchPoints ?? 0;

    final isIOS =
        RegExp('iphone|ipad|ipod').hasMatch(ua) ||
        (ua.contains('macintosh') && maxTouchPoints > 1);
    if (isIOS) return config.appStoreUrl;

    if (ua.contains('android')) return config.googleAppUrl;

    return null;
  }
}
