import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_conf_backend/flutter_conf_backend.dart';
import 'package:flutter_conf_common/flutter_conf_common.dart';
import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> bootstrap(
  FutureOr<Widget> Function() builder,
  FirebaseOptions options,
) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(
    () async {
      usePathUrlStrategy();

      await initializeDateFormatting('es_CO');
      tz.initializeTimeZones();

      WidgetsFlutterBinding.ensureInitialized();
      await RiveNative.init();

      const webDebugSiteKey = String.fromEnvironment('WEB_DEBUG_SITE_KEY');
      const webCaptchaSiteKey = String.fromEnvironment('WEB_CAPTCHA_SITE_KEY');

      final initializer = FirebaseInitializer.withConfig(
        options: options,
        appCheckConfig: kDebugMode
            ? AppCheckConfig.debug(webCaptchaSiteKey: webDebugSiteKey)
            : AppCheckConfig.release(webCaptchaSiteKey: webCaptchaSiteKey),
      );

      final result = await initializer.initialize();
      if (result case Failure(:final failure)) {
        log('Failed to initialize Firebase: $failure');
      }

      final prefs = await SharedPreferences.getInstance();
      initSharedPreferences(prefs);

      runApp(await builder());
    },
    (error, stack) {
      if (kDebugMode) log(error.toString(), stackTrace: stack);
    },
  );
}
