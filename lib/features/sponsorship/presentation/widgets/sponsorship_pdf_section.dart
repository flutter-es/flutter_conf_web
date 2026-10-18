import 'dart:async';

import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class SponsorshipPdfSection extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final language = currentLocale.value.languageCode;

    final l10n = appLocalizations.value;
    final config = appConfig.value;

    return SectionContainer(
      spacing: 24,
      children: <Widget>[
        TitleSubtitleText(
          title: (
            text: l10n.sponsorshipCtaTitle,
            size: switch (context.screenSize) {
              .extraLarge => 48,
              .large => 36,
              .normal || .small => 24,
            },
          ),
          subtitle: (
            text: l10n.sponsorshipCtaDescription,
            size: switch (context.screenSize) {
              .extraLarge || .large => 20,
              .normal || .small => 16,
            },
          ),
          spacing: 16,
        ),
        FclButton.primary(
          icon: const Icon(Icons.download_outlined),
          label: l10n.sponsorshipCtaDownloadButton,
          buttonSize: .large,
          onPressed: () => _downloadFile(switch (language) {
            'es' => Assets.files.sponsorFileEs,
            _ => Assets.files.sponsorFileEn,
          }, '${language.toUpperCase()}-${config.sponsorshipFileName}'),
        ),
      ],
    );
  }

  void _downloadFile(String assetPath, String fileName) {
    unawaited(Utils.downloadPdf(assetPath, fileName));
  }
}
