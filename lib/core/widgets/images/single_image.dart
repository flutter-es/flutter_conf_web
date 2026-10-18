import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:material_ui/material_ui.dart';

class SingleImage extends StatelessWidget {
  const new({
    required this.imageUrl,
    required this.size,
    this.borderRadius = 12,
    super.key,
  });

  final String imageUrl;
  final Size size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (_, imageProvider) => SingleImageContainer(
        size: size,
        borderRadius: borderRadius,
        image: DecorationImage(image: imageProvider, fit: .cover),
      ),
      progressIndicatorBuilder: (_, _, _) {
        return SingleImageContainer(size: size, borderRadius: borderRadius);
      },
      errorWidget: (_, _, _) {
        return const Center(child: Text('Error al cargar la imagen'));
      },
    );
  }
}

class SingleImageContainer extends StatelessWidget {
  const new({
    required this.size,
    this.borderRadius = 12,
    this.image,
    super.key,
  });

  final Size size;
  final double borderRadius;
  final DecorationImage? image;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: image == null ? FlutterLatamColors.darkBlue : null,
          borderRadius: .circular(borderRadius),
          image: image,
        ),
        child: image == null ? const SizedBox() : null,
      ),
    );
  }
}
