import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/widgets/container/carousel_container.dart';
import 'package:flutter_conf_latam/core/widgets/container/keep_alive_container.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/container/shimmer_container.dart';
import 'package:flutter_conf_latam/core/widgets/images/single_image.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/features/home/presentation/view_model/home_signals.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class HomeGallery extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final gallery = galleryPreviewSignal.value;

    final size = switch (context.screenSize) {
      .extraLarge => const Size.square(360),
      _ => const Size.square(264),
    };

    return KeepAliveContainer(
      child: SectionContainer(
        spacing: 30,
        children: <Widget>[
          TitleSubtitleText(
            subtitle: (
              text: l10n.homeGalleryText,
              size: switch (context.screenSize) {
                .extraLarge || .large => 24,
                .normal || .small => 16,
              },
            ),
          ),
          gallery.maybeMap(
            data: (data) {
              if (data.isEmpty) return const Offstage();
              return CarouselContainer(
                itemSize: size,
                items: <Widget>[
                  for (final item in data)
                    Center(
                      child: SingleImage(imageUrl: item, size: size),
                    ),
                ],
              );
            },
            loading: () => Shimmer(
              child: CarouselContainer(
                itemSize: size,
                items: .generate(20, (_) {
                  return Center(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: SingleImageContainer(size: size),
                    ),
                  );
                }),
              ),
            ),
            orElse: () => const Offstage(),
          ),
        ],
      ),
    );
  }
}
