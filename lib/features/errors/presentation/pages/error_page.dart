import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/routes/app_route_path.dart';
import 'package:flutter_conf_latam/core/widgets/animations/flutter_rive_animated.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class ErrorPage extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;
    final l10n = appLocalizations.value;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          mainAxisSize: .min,
          children: <Widget>[
            SizedBox.square(
              dimension: switch (context.screenSize) {
                .extraLarge => 400,
                .large => 300,
                _ => 250,
              },
              child: FlutterRiveAnimated(
                path: Assets.animations.flutterWarning,
                animation: .flutterWarning,
              ),
            ),
            Text(
              l10n.errorPageTitle,
              textAlign: .center,
              style: theme.typography.h1Bold.copyWith(
                color: FlutterLatamColors.grey,
                fontSize: switch (context.screenSize) {
                  .extraLarge => 60,
                  .large => 50,
                  _ => 40,
                },
              ),
            ),
            Text(
              l10n.errorPageSubtitle,
              textAlign: .center,
              style: theme.typography.subH2Semibold.copyWith(
                color: FlutterLatamColors.grey,
                fontSize: switch (context.screenSize) {
                  .extraLarge => 30,
                  _ => 20,
                },
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: const StadiumBorder(),
                backgroundColor: FlutterLatamColors.darkBlue,
                foregroundColor: FlutterLatamColors.white,
              ),
              onPressed: () => context.go('/${AppRoutePath.home.pathName}'),
              child: Padding(
                padding: const .all(16),
                child: Text(l10n.errorReturnHomeButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
