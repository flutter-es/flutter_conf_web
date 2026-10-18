import 'package:material_ui/material_ui.dart';

class AdaptableText extends StatelessWidget {
  const new(
    this.text, {
    required this.style,
    this.textAlign = .left,
    this.textDirection = .ltr,
    this.minimumFontScale = .5,
    this.textOverflow = .ellipsis,
    super.key,
  });

  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final double minimumFontScale;
  final TextOverflow textOverflow;

  @override
  Widget build(BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: textAlign,
      maxLines: 100,
      textDirection: textDirection,
    );

    return LayoutBuilder(
      builder: (_, constraints) {
        painter.layout(maxWidth: constraints.maxWidth);
        var textScaleFactor = 1.0;

        if (painter.height > constraints.maxHeight) {
          painter
            ..textScaler = .linear(minimumFontScale)
            ..layout(maxWidth: constraints.maxWidth);

          if (painter.height > constraints.maxHeight) {
            textScaleFactor = minimumFontScale;
          } else if (minimumFontScale < 1) {
            var h = 100;
            var l = (minimumFontScale * 100).toInt();

            while (h > l) {
              final mid = (l + (h - l) / 2).toInt();
              final newScale = mid.toDouble() / 100.0;

              painter
                ..textScaler = .linear(newScale)
                ..layout(maxWidth: constraints.maxWidth);

              if (painter.height > constraints.maxHeight) {
                h = mid - 1;
              } else {
                l = mid + 1;
              }

              if (h <= l) {
                textScaleFactor = newScale - .01;
                painter
                  ..textScaler = .linear(newScale)
                  ..layout(maxWidth: constraints.maxWidth);

                break;
              }
            }
          }
        }

        return Text(
          text,
          style: style,
          maxLines: 100,
          textAlign: textAlign,
          overflow: textOverflow,
          textDirection: textDirection,
          textScaler: .linear(textScaleFactor),
        );
      },
    );
  }
}
