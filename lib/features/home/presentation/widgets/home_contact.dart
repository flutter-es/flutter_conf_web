import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/button/fcl_button.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class HomeContact extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    final l10n = appLocalizations.value;
    final email = appConfig.value.contactEmail;

    return SectionContainer(
      spacing: 32,
      children: <Widget>[
        TitleSubtitleText(
          title: (
            text: l10n.contactMainTitle,
            size: switch (context.screenSize) {
              .extraLarge => 48,
              .large => 36,
              .normal || .small => 24,
            },
          ),
          subtitle: (
            text: l10n.contactMainDescription,
            size: switch (context.screenSize) {
              .extraLarge || .large => 20,
              .normal || .small => 16,
            },
          ),
          spacing: 16,
        ),
        Container(
          padding: const .symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: .circular(16),
            color: FlutterLatamColors.darkBlue,
            border: .all(
              color: FlutterLatamColors.mediumBlue.withValues(alpha: .4),
            ),
          ),
          child: switch (context.screenSize) {
            .extraLarge || .large => Row(
              spacing: 16,
              children: <Widget>[
                Expanded(
                  child: Text(
                    email,
                    style: theme.typography.body2Regular.copyWith(
                      color: FlutterLatamColors.mediumBlue,
                    ),
                  ),
                ),
                FclButton.secondary(
                  label: l10n.contactCopyEmail,
                  buttonSize: .small,
                  icon: SizedBox.square(
                    dimension: 18,
                    child: SvgPicture.asset(Assets.images.icons.copy),
                  ),
                  onPressed: () {
                    _copyEmail(context, email, l10n.contactCopyEmail);
                  },
                ),
                FclButton.primary(
                  label: l10n.menuContactText,
                  buttonSize: .small,
                  icon: const Icon(Icons.mail_outline),
                  onPressed: () =>
                      unawaited(Utils.launchUrlLink('mailto:$email')),
                ),
              ],
            ),
            _ => Column(
              spacing: 12,
              crossAxisAlignment: .start,
              children: <Widget>[
                Text(
                  email,
                  style: theme.typography.body2Regular.copyWith(
                    color: FlutterLatamColors.mediumBlue,
                  ),
                ),
                Row(
                  spacing: 12,
                  children: <Widget>[
                    Expanded(
                      child: FclButton.secondary(
                        label: l10n.contactCopyEmail,
                        buttonSize: .small,
                        icon: SizedBox.square(
                          dimension: 18,
                          child: SvgPicture.asset(Assets.images.icons.copy),
                        ),
                        onPressed: () {
                          _copyEmail(context, email, l10n.contactCopyEmail);
                        },
                      ),
                    ),
                    Expanded(
                      child: FclButton.primary(
                        label: l10n.menuContactText,
                        buttonSize: .small,
                        onPressed: () =>
                            unawaited(Utils.launchUrlLink('mailto:$email')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          },
        ),
      ],
    );
  }

  void _copyEmail(BuildContext context, String email, String label) {
    unawaited(Clipboard.setData(ClipboardData(text: email)));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(label), duration: const Duration(seconds: 2)),
    );
  }
}
