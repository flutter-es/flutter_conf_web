import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

typedef SocialMediaInfo = ({String iconPath, String linkUrl});

class SocialMediaRow extends StatelessWidget {
  const new({required this.socialMediaList, super.key});

  final List<SocialMediaInfo> socialMediaList;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      mainAxisSize: .min,
      children: <Widget>[
        for (final social in socialMediaList)
          InkWell(
            onTap: () => Utils.launchUrlLink(social.linkUrl),
            child: SizedBox.square(
              dimension: 24,
              child: SvgPicture.asset(
                social.iconPath,
                colorFilter: const ColorFilter.mode(
                  FlutterLatamColors.white,
                  .srcIn,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class SocialMediaRowContainer extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      mainAxisSize: .min,
      children: .generate(3, (_) {
        return const SizedBox.square(
          dimension: 24,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: .circle,
              color: FlutterLatamColors.darkBlue,
            ),
          ),
        );
      }),
    );
  }
}
