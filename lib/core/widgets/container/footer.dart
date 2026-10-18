import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/routes/app_route_path.dart';
import 'package:flutter_conf_latam/core/routes/helpers/navigation_view_model.dart';
import 'package:flutter_conf_latam/core/social/providers/social_media_provider.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/icons/social_media_row.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class Footer extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;
    final l10n = appLocalizations.value;

    final paddingHorizontal = switch (context.screenSize) {
      .extraLarge => 122.0,
      .large => 72.0,
      .normal || .small => 28.0,
    };

    final paddingTop = switch (context.screenSize) {
      .extraLarge || .large => 96.0,
      .normal || .small => 48.0,
    };

    final paddingBottom = switch (context.screenSize) {
      .extraLarge || .large => 96.0,
      .normal || .small => 28.0,
    };

    final footerLinks = <({String text, String url})>[
      (
        text: l10n.footerTermsAndConditions,
        url: AppRoutePath.termsConditions.pathName,
      ),
      (
        text: l10n.footerPrivacyPolicy,
        url: AppRoutePath.privacyPolicy.pathName,
      ),
    ];

    final footerChildren = <Widget>[
      Text(
        l10n.footerCopyright(DateTime.now().year),
        style: theme.typography.body4Regular.copyWith(fontSize: 16),
      ),
      Column(
        spacing: 10,
        children: <Widget>[
          for (final item in footerLinks)
            InkWell(
              mouseCursor: SystemMouseCursors.click,
              onTap: () => context.go('/${item.url}'),
              child: Text(
                item.text,
                style: theme.typography.body4Regular.copyWith(
                  decoration: .underline,
                  decorationColor: FlutterLatamColors.white,
                ),
              ),
            ),
        ],
      ),
    ];

    return Column(
      children: <Widget>[
        Padding(
          padding: .fromLTRB(
            paddingHorizontal,
            paddingTop,
            paddingHorizontal,
            paddingBottom,
          ),
          child: Column(
            spacing: 64,
            children: <Widget>[
              const Divider(),
              Flex(
                mainAxisSize: .min,
                mainAxisAlignment: switch (context.screenSize) {
                  .extraLarge => .spaceBetween,
                  _ => .start,
                },
                spacing: switch (context.screenSize) {
                  .extraLarge || .large => 100,
                  .normal || .small => 48,
                },
                crossAxisAlignment: .start,
                direction: switch (context.screenSize) {
                  .extraLarge => .horizontal,
                  _ => .vertical,
                },
                children: <Widget>[
                  if (context.screenSize == .extraLarge) ...[
                    const Expanded(flex: 2, child: _SocialFooter()),
                    const Expanded(child: _SocialVideos()),
                  ] else ...[
                    const _SocialFooter(),
                    const _SocialVideos(),
                  ],
                ],
              ),
              const Divider(),
              switch (context.screenSize) {
                .extraLarge || .large => Row(
                  mainAxisAlignment: .spaceBetween,
                  children: footerChildren,
                ),
                .normal ||
                .small => Column(spacing: 16, children: footerChildren),
              },
            ],
          ),
        ),
        /*
        Builder(
          builder: (_) {
            final paddingHorizontal = switch (context.screenSize) {
              .extraLarge || .large => 122.0,
              .normal || .small => 40.0,
            };

            final textAlign = switch (context.screenSize) {
              .extraLarge || .large => TextAlign.start,
              .normal || .small => TextAlign.center,
            };

            return ColoredBox(
              color: FlutterLatamColors.darkBlue,
              child: Padding(
                padding: .symmetric(
                  horizontal: paddingHorizontal,
                  vertical: 32,
                ),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: switch (context.screenSize) {
                    .extraLarge || .large => .start,
                    .normal || .small => .center,
                  },
                  children: <Widget>[
                    Text(
                      l10n.footerDataProtectionTitle,
                      textAlign: textAlign,
                      style: theme.typography.body4Regular,
                    ),
                    DataProtectionText(textSize: 14, textAlign: textAlign),
                  ],
                ),
              ),
            );
          },
        ),
        */
      ],
    );
  }
}

class _SocialFooter extends SignalWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final socialMediaList = socialMediaSignal.value;
    final list = socialMediaList.value ?? [];

    return Column(
      spacing: 10,
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      mainAxisAlignment: .spaceBetween,
      children: <Widget>[
        SizedBox.fromSize(
          size: const Size(222, 167),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: _goToHome,
              child: SvgPicture.asset(Assets.images.fclMxMainLogo),
            ),
          ),
        ),
        SocialMediaRow(
          socialMediaList: list.map((item) {
            final iconPath = switch (item.type) {
              .youtube => Assets.images.icons.youtube,
              .linkedIn => Assets.images.icons.linkedIn,
              .tikTok => Assets.images.icons.tikTok,
              .twitter => Assets.images.icons.twitter,
              .facebook => Assets.images.icons.facebook,
              .instagram => Assets.images.icons.instagram,
            };
            return (iconPath: iconPath, linkUrl: item.link);
          }).toList(),
        ),
      ],
    );
  }

  void _goToHome() {
    navigationController.selectNavItemFromRoute(
      '/${AppRoutePath.home.pathName}',
    );
  }
}

class _SocialVideos extends SignalWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;
    final l10n = appLocalizations.value;

    const youtubeUrl = 'https://www.youtube.com/watch';
    final videoList = <({String text, String url})>[
      (text: l10n.footerMemoriesVideoOne, url: '$youtubeUrl?v=FSRlBfMwoG8'),
      (text: l10n.footerMemoriesVideoTwo, url: '$youtubeUrl?v=AroSepWRDMw'),
      (text: l10n.footerMemoriesVideoThree, url: '$youtubeUrl?v=AQjO-V4xGis'),
    ];

    return Column(
      spacing: 30,
      crossAxisAlignment: .start,
      children: <Widget>[
        Column(
          spacing: 10,
          crossAxisAlignment: .start,
          children: <Widget>[
            Text(
              l10n.footerMemoriesTitle,
              style: theme.typography.subH2Semibold,
            ),
            Text(
              l10n.footerMemoriesDescription,
              style: theme.typography.body3Regular,
            ),
          ],
        ),
        ...[
          for (final item in videoList)
            Row(
              spacing: 10,
              children: <Widget>[
                SvgPicture.asset(Assets.images.icons.youtubeLogo),
                Expanded(
                  child: InkWell(
                    onTap: () => Utils.launchUrlLink(item.url),
                    child: Text(
                      item.text,
                      style: theme.typography.body3Regular.copyWith(
                        decoration: .underline,
                        decorationColor: FlutterLatamColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ],
    );
  }
}
