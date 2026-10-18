import 'dart:async';
import 'dart:js_interop';

import 'package:flutter_conf_core/flutter_conf_core.dart';
import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/routes/app_routes.dart';
import 'package:flutter_conf_latam/l10n/gen/app_localizations.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

@JS('window')
external JSWindow get window;

extension type JSWindow._(JSObject _) implements JSObject {
  external int get initTime;
}

class FlutterConfWeb extends SignalStatefulWidget {
  const new({super.key});

  @override
  State<FlutterConfWeb> createState() => _FlutterConfWebState();
}

class _FlutterConfWebState extends State<FlutterConfWeb> {
  final _appRoutes = AppRoutes();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeAnalytics());
  }

  void _initializeAnalytics() {
    final analytics = analyticsRepository.value;

    unawaited(
      analytics.logEvent(event: const AnalyticsEvent(name: 'app_open')),
    );

    final initTime = window.initTime;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    final diff = (currentTime - initTime) / 1000;
    unawaited(
      analytics.logEvent(
        event: AnalyticsEvent(name: 'render_time', parameters: {'diff': diff}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = currentLocale.value;

    return MaterialApp.router(
      title: 'Flutter Conf LATAM',
      debugShowCheckedModeBanner: false,
      theme: FclTheme.light(),
      locale: appLocale,
      routerConfig: _appRoutes.router,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        ...GlobalMaterialLocalizations.delegates,
      ],
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {.mouse, .touch, .stylus, .unknown},
      ),
    );
  }
}
