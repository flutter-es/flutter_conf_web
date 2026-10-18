import 'package:flutter_conf_core/flutter_conf_core.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/widgets/images/character_image.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:material_ui/material_ui.dart';

class SpeakerCardItem extends StatelessWidget {
  const new({required this.speaker, required this.imageSize, super.key});

  final SpeakerEntity speaker;
  final Size imageSize;

  @override
  Widget build(BuildContext context) {
    final user = speaker.user;

    return Center(
      child: Column(
        spacing: 20,
        mainAxisSize: .min,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: .circular(30)),
            child: CharacterImage(
              imageUrl: (speaker.presentationImageUrl ?? '').isNotEmpty
                  ? speaker.presentationImageUrl!
                  : user.avatarUrl ?? '',
              flagImageUrl: user.countryFlag ?? '',
              size: imageSize,
            ),
          ),
          TitleSubtitleText(
            title: (
              text: user.name,
              size: switch (context.screenSize) {
                .extraLarge || .large => 24,
                .normal || .small => 12,
              },
            ),
            subtitle: (
              text: user.jobTitle ?? '',
              size: switch (context.screenSize) {
                .extraLarge || .large => 16,
                .normal || .small => 12,
              },
            ),
            spacing: 4,
          ),
        ],
      ),
    );
  }
}
