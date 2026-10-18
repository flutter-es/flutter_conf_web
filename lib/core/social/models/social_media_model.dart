import 'package:json_annotation/json_annotation.dart';

part 'social_media_model.g.dart';

@JsonSerializable(createToJson: false)
class SocialMediaModel {
  const new({required this.type, required this.label, required this.link});

  factory fromJson(Map<String, dynamic> json) =>
      _$SocialMediaModelFromJson(json);

  final SocialMediaType type;
  final String label;
  final String link;
}

@JsonEnum()
enum SocialMediaType { youtube, linkedIn, tikTok, twitter, facebook, instagram }
