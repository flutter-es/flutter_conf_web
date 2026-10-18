import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/container/list.dart';
import 'package:markdown_widget/widget/blocks/leaf/heading.dart';
import 'package:markdown_widget/widget/blocks/leaf/link.dart';
import 'package:markdown_widget/widget/blocks/leaf/paragraph.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:material_ui/material_ui.dart';

class MarkdownContainer extends StatelessWidget {
  const new({required this.markdownData, super.key});

  final String markdownData;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;
    final bodyTextStyle = switch (context.screenSize) {
      .extraLarge || .large => theme.typography.body1Regular.copyWith(
        color: theme.colorScheme.inverseNeutral,
      ),
      .normal || .small => theme.typography.body3Regular.copyWith(
        color: theme.colorScheme.inverseNeutral,
      ),
    };

    return ColoredBox(
      color: theme.colorScheme.neutral,
      child: SectionContainer(
        spacing: 30,
        children: <Widget>[
          MarkdownWidget(
            data: markdownData,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            config: MarkdownConfig(
              configs: [
                H1Config(
                  style: theme.typography.h1Bold.copyWith(
                    color: theme.colorScheme.inverseNeutral,
                  ),
                ),
                H2Config(
                  style: theme.typography.h2Bold.copyWith(
                    color: theme.colorScheme.inverseNeutral,
                  ),
                ),
                H3Config(
                  style: theme.typography.h3Bold.copyWith(
                    color: theme.colorScheme.inverseNeutral,
                  ),
                ),
                H4Config(
                  style: theme.typography.h4Bold.copyWith(
                    color: theme.colorScheme.inverseNeutral,
                  ),
                ),
                H5Config(
                  style: theme.typography.h4Bold.copyWith(
                    fontSize: 20,
                    color: theme.colorScheme.inverseNeutral,
                  ),
                ),
                H6Config(
                  style: theme.typography.h4Bold.copyWith(
                    fontSize: 18,
                    color: theme.colorScheme.inverseNeutral,
                  ),
                ),
                PConfig(textStyle: bodyTextStyle),
                LinkConfig(
                  style: bodyTextStyle.copyWith(
                    color: theme.colorScheme.accentPrimary,
                    decoration: .underline,
                    decorationColor: theme.colorScheme.accentPrimary,
                  ),
                  onTap: Utils.launchUrlLink,
                ),
                ListConfig(
                  marker: (_, _, _) => Padding(
                    padding: const .only(top: 15),
                    child: SizedBox.square(
                      dimension: 6,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: .circle,
                          color: theme.colorScheme.inverseNeutral,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
