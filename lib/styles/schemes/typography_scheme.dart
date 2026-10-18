import 'package:material_ui/material_ui.dart';

class FclTypographyScheme extends ThemeExtension<FclTypographyScheme> {
  new({
    required this.h1Bold,
    required this.h2Bold,
    required this.h3Bold,
    required this.h4Bold,
    required this.subH1Regular,
    required this.subH2Semibold,
    required this.subH3Regular,
    required this.buttonNormalMedium,
    required this.buttonSmallMedium,
    required this.body1Regular,
    required this.body2Regular,
    required this.body3Regular,
    required this.body3Light,
    required this.body4Regular,
    required this.captionRegular,
  });

  final TextStyle h1Bold;
  final TextStyle h2Bold;
  final TextStyle h3Bold;
  final TextStyle h4Bold;

  final TextStyle subH1Regular;
  final TextStyle subH2Semibold;
  final TextStyle subH3Regular;

  final TextStyle buttonNormalMedium;
  final TextStyle buttonSmallMedium;

  final TextStyle body1Regular;
  final TextStyle body2Regular;
  final TextStyle body3Regular;
  final TextStyle body3Light;
  final TextStyle body4Regular;

  final TextStyle captionRegular;

  @override
  ThemeExtension<FclTypographyScheme> copyWith({
    TextStyle? h1Bold,
    TextStyle? h2Bold,
    TextStyle? h3Bold,
    TextStyle? h4Bold,
    TextStyle? subH1Regular,
    TextStyle? subH2Semibold,
    TextStyle? subH3Regular,
    TextStyle? buttonNormalMedium,
    TextStyle? buttonSmallMedium,
    TextStyle? body1Regular,
    TextStyle? body2Regular,
    TextStyle? body3Regular,
    TextStyle? body3Light,
    TextStyle? body4Regular,
    TextStyle? captionRegular,
  }) {
    return FclTypographyScheme(
      h1Bold: h1Bold ?? this.h1Bold,
      h2Bold: h2Bold ?? this.h2Bold,
      h3Bold: h3Bold ?? this.h3Bold,
      h4Bold: h4Bold ?? this.h4Bold,
      subH1Regular: subH1Regular ?? this.subH1Regular,
      subH2Semibold: subH2Semibold ?? this.subH2Semibold,
      subH3Regular: subH3Regular ?? this.subH3Regular,
      buttonNormalMedium: buttonNormalMedium ?? this.buttonNormalMedium,
      buttonSmallMedium: buttonSmallMedium ?? this.buttonSmallMedium,
      body1Regular: body1Regular ?? this.body1Regular,
      body2Regular: body2Regular ?? this.body2Regular,
      body3Regular: body3Regular ?? this.body3Regular,
      body3Light: body3Light ?? this.body3Light,
      body4Regular: body4Regular ?? this.body4Regular,
      captionRegular: captionRegular ?? this.captionRegular,
    );
  }

  @override
  ThemeExtension<FclTypographyScheme> lerp(
    covariant ThemeExtension<FclTypographyScheme>? other,
    double t,
  ) {
    if (other is! FclTypographyScheme) return this;

    return FclTypographyScheme(
      h1Bold: _lerpTextStyle(h1Bold, other.h1Bold, t),
      h2Bold: _lerpTextStyle(h2Bold, other.h2Bold, t),
      h3Bold: _lerpTextStyle(h3Bold, other.h3Bold, t),
      h4Bold: _lerpTextStyle(h4Bold, other.h4Bold, t),
      subH1Regular: _lerpTextStyle(subH1Regular, other.subH1Regular, t),
      subH2Semibold: _lerpTextStyle(subH2Semibold, other.subH2Semibold, t),
      subH3Regular: _lerpTextStyle(subH3Regular, other.subH3Regular, t),
      buttonNormalMedium: _lerpTextStyle(
        buttonNormalMedium,
        other.buttonNormalMedium,
        t,
      ),
      buttonSmallMedium: _lerpTextStyle(
        buttonSmallMedium,
        other.buttonSmallMedium,
        t,
      ),
      body1Regular: _lerpTextStyle(body1Regular, other.body1Regular, t),
      body2Regular: _lerpTextStyle(body2Regular, other.body2Regular, t),
      body3Regular: _lerpTextStyle(body3Regular, other.body3Regular, t),
      body3Light: _lerpTextStyle(body3Light, other.body3Light, t),
      body4Regular: _lerpTextStyle(body4Regular, other.body4Regular, t),
      captionRegular: _lerpTextStyle(captionRegular, other.captionRegular, t),
    );
  }

  TextStyle _lerpTextStyle(TextStyle? main, TextStyle? second, double value) {
    return TextStyle.lerp(main, second, value)!;
  }
}
