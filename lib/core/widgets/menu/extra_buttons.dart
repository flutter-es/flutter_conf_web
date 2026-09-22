import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/routes/app_route_path.dart';
import 'package:flutter_conf_latam/core/seo/seo_config.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/dialog/data_protection_dialog.dart';
import 'package:flutter_conf_latam/core/widgets/dialog/main_dialog.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';

enum ButtonPosition { row, column }

class ExtraButtons extends SignalWidget {
  const ExtraButtons({required this.position, super.key});

  final ButtonPosition position;

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final config = appConfig.value;

    final children = <Widget>[
      FclButton.secondary(
        label: l10n.menuBeSponsorButton,
        buttonSize: .small,
        onPressed: () => context.go('/${AppRoutePath.sponsorship.pathName}'),
      ),
      /*
      FclButton.secondary(
        label: l10n.menuBeSpeakerButton,
        buttonSize: .small,
        onPressed: () => Utils.launchUrlLink(config.cfpFormUrl),
      ),
      */
      FclButton.primary(
        label: l10n.menuBuyTicketsButton,
        buttonSize: .small,
        onPressed: () {
          const showDisclaimer = bool.fromEnvironment('SHOW_DISCLAIMER_DIALOG');

          if (showDisclaimer) {
            unawaited(_showDisclaimerDialog(context, config.ticketPageUrl));
          } else {
            unawaited(Utils.launchUrlLink(config.ticketPageUrl));
          }
        },
      ),
      FclButton.secondary(
        label: l10n.menuAgendaButton,
        buttonSize: .small,
        onPressed: () {
          unawaited(
            Utils.launchUrlLink(
              '${SeoConfig.baseUrl}/${AppRoutePath.agenda.pathName}',
            ),
          );
        },
      ),
    ];

    return switch (position) {
      .row => Row(spacing: 20, mainAxisSize: .min, children: children),
      .column => Column(spacing: 20, mainAxisSize: .min, children: children),
    };
  }

  Future<void> _showDisclaimerDialog(BuildContext context, String url) async {
    final result = await MainDialog.show<bool>(
      context,
      child: const DataProtectionDialog(),
    );
    if (result ?? false) unawaited(Utils.launchUrlLink(url));
  }
}
