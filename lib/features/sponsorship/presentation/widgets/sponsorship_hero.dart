import 'dart:async';

import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class SponsorshipHero extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;

    return SectionContainer(
      spacing: 24,
      children: <Widget>[
        TitleSubtitleText(
          title: (
            text: l10n.sponsorshipHeroTagline,
            size: switch (context.screenSize) {
              .extraLarge || .large => 48,
              .normal || .small => 32,
            },
          ),
          subtitle: (
            text: l10n.sponsorshipHeroDescription,
            size: switch (context.screenSize) {
              .extraLarge || .large => 20,
              .normal || .small => 16,
            },
          ),
        ),
        FclButton.primary(
          label: l10n.sponsorshipContactButton,
          buttonSize: .large,
          onPressed: () => unawaited(
            Utils.launchUrlLink(
              Utils.mailtoWithSubject(
                const String.fromEnvironment('CONTACT_EMAIL'),
                l10n.sponsorshipContactSubject,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
