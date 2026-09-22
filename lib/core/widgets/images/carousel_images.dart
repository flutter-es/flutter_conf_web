import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_conf_latam/core/extensions/extension_methods.dart';
import 'package:flutter_conf_latam/core/widgets/container/shimmer_container.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';

class CarouselImages extends StatefulWidget {
  const CarouselImages({required this.images, this.aspectRatio = 2, super.key})
    : assert(images.length >= 1, 'Carousel must have at least one image');

  final List<String> images;
  final double aspectRatio;

  @override
  State<CarouselImages> createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  late final _pageController = PageController(viewportFraction: 1.1);

  bool _isLoading = true;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      if (widget.images.length > 1) _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;
        return Column(
          spacing: 10,
          mainAxisSize: .min,
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(width, width / widget.aspectRatio),
              child: Shimmer(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.images.length,
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                    _resetTimer();
                  },
                  itemBuilder: (_, index) => ShimmerLoading(
                    isLoading: _isLoading,
                    child: _CarouselImageItem(
                      imagePath: widget.images[index],
                      widthFactor: 1 / _pageController.viewportFraction,
                      aspectRatio: widget.aspectRatio,
                    ),
                  ),
                ),
              ),
            ),
            if (widget.images.length > 1)
              Row(
                spacing: 4,
                mainAxisSize: .min,
                mainAxisAlignment: .center,
                children: .generate(widget.images.length, (index) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        if (_pageController.hasClients) _animatePage(index);
                        _resetTimer();
                      },
                      child: SizedBox.square(
                        dimension: 12,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: .circle,
                            color: switch (_currentPage == index) {
                              true => FlutterLatamColors.white,
                              false => FlutterLatamColors.darkBlue,
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
          ],
        );
      },
    );
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted && (widget.images.isEmpty || !_pageController.hasClients)) {
        timer.cancel();
        return;
      }
      _animatePage((_currentPage + 1) % widget.images.length);
    });
  }

  void _animatePage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _resetTimer() {
    if (widget.images.length > 1) _startAutoScroll();
  }
}

class _CarouselImageItem extends StatelessWidget {
  const _CarouselImageItem({
    required this.imagePath,
    required this.widthFactor,
    required this.aspectRatio,
  });

  final String imagePath;
  final double widthFactor;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: switch (imagePath.isValidUrl) {
        true => NetworkImage(imagePath),
        false => AssetImage(imagePath),
      },
      fit: .cover,
      loadingBuilder: (_, child, loadingProgress) {
        return _CarouselImageContainer(
          widthFactor: widthFactor,
          aspectRatio: aspectRatio,
          child: loadingProgress == null ? child : null,
        );
      },
      frameBuilder: (_, child, frame, synchronouslyLoaded) {
        return _CarouselImageContainer(
          widthFactor: widthFactor,
          aspectRatio: aspectRatio,
          child: synchronouslyLoaded || frame != null ? child : null,
        );
      },
      errorBuilder: (_, _, _) {
        return const Center(child: Text('Error al cargar la imagen'));
      },
    );
  }
}

class _CarouselImageContainer extends StatelessWidget {
  const _CarouselImageContainer({
    required this.widthFactor,
    required this.aspectRatio,
    this.child,
  });

  final double widthFactor;
  final double aspectRatio;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ClipRRect(borderRadius: .circular(15), child: child),
      ),
    );
  }
}
