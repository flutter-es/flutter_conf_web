// Set this to avoid cast for RenderObject
// ignore_for_file: cast_nullable_to_non_nullable

import 'package:flutter/material.dart';

const _shimmerGradient = LinearGradient(
  colors: [Color(0xFF0D4377), Color(0xFF3c7ce2), Color(0xFF0D4377)],
  stops: [.1, .3, .4],
  begin: Alignment(-1, -.3),
  end: Alignment(1, .3),
);

class Shimmer extends StatefulWidget {
  const Shimmer({this.linearGradient, this.child, super.key});

  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  final LinearGradient? linearGradient;
  final Widget? child;

  @override
  State<Shimmer> createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = .unbounded(vsync: this);
    _shimmerController.repeat(
      min: -.5,
      max: 1.5,
      period: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }

  Listenable get shimmerChanges => _shimmerController;

  LinearGradient get gradient {
    final defaultGradient = widget.linearGradient ?? _shimmerGradient;
    return LinearGradient(
      colors: defaultGradient.colors,
      stops: defaultGradient.stops,
      begin: defaultGradient.begin,
      end: defaultGradient.end,
      transform: _SlidingGradientTransform(
        slidePercent: _shimmerController.value,
      ),
    );
  }

  bool get isSized {
    return (context.findRenderObject() as RenderBox?)?.hasSize ?? false;
  }

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }
}

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    required this.child,
    this.isLoading = false,
    super.key,
  });

  final Widget child;
  final bool isLoading;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shimmer = Shimmer.of(context);

    if (!widget.isLoading || shimmer == null) return widget.child;
    if (!shimmer.isSized) return const SizedBox();

    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    final offsetWithShimmer = shimmer.getDescendantOffset(
      descendant: context.findRenderObject() as RenderBox,
    );

    return ShaderMask(
      blendMode: .srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetWithShimmer.dx,
            -offsetWithShimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.child,
    );
  }

  void _onShimmerChange() {
    if (widget.isLoading) setState(() {});
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return .translationValues(bounds.width * slidePercent, 0, 0);
  }
}
