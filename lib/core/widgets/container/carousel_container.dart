import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CarouselContainer extends HookWidget {
  const CarouselContainer({
    required this.items,
    this.itemSize,
    this.height = 400,
    this.autoPlayDuration = const Duration(seconds: 2),
    this.animationCurve = Curves.easeInOut,
    this.spacing = 10,
    super.key,
  });

  final List<Widget> items;
  final Size? itemSize;
  final double height;
  final Duration autoPlayDuration;
  final Curve animationCurve;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final isHovering = useState(false);
    final pageController = usePageController(
      initialPage: 10000,
      viewportFraction: .35,
    );

    useEffect(
      () {
        final timer = Timer.periodic(autoPlayDuration, (timer) {
          if (!isHovering.value && pageController.hasClients) {
            final nextPage = (pageController.page ?? 0).toInt() + 1;
            pageController.animateToPage(
              nextPage,
              curve: animationCurve,
              duration: const Duration(milliseconds: 600),
            );
          }
        });
        return timer.cancel;
      },
      const [],
    );

    return SizedBox(
      height: itemSize?.height ?? height,
      child: MouseRegion(
        onEnter: (_) => isHovering.value = true,
        onExit: (_) => isHovering.value = false,
        child: PageView.builder(
          controller: pageController,
          itemBuilder: (_, index) => Padding(
            padding: .symmetric(horizontal: spacing / 2),
            child: items[index % items.length],
          ),
        ),
      ),
    );
  }
}
