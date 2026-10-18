import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:signals/signals.dart';

final privacyPolicySignal = futureSignal<String>(() async {
  final localeName = appLocalizations.value.localeName;
  final filePath = switch (Locale(localeName).languageCode) {
    'en' => Assets.markdown.privacyPolicyEn,
    _ => Assets.markdown.privacyPolicyEs,
  };
  return await rootBundle.loadString(filePath);
});

final termsSignal = futureSignal<String>(() async {
  final localeName = appLocalizations.value.localeName;
  final filePath = switch (Locale(localeName).languageCode) {
    'en' => Assets.markdown.termsAndConditionsEn,
    _ => Assets.markdown.termsAndConditionsEs,
  };
  return await rootBundle.loadString(filePath);
});

void reloadPrivacyTerms() {
  unawaited(privacyPolicySignal.reload());
  unawaited(termsSignal.reload());
}
