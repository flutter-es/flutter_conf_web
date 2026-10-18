import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_conf_core/flutter_conf_core.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/widgets/container/responsive_grid.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/icons/circle_icon.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/features/home/presentation/view_model/home_signals.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class HomeFaq extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final faqList = faqListSignal.value;

    return faqList.maybeMap(
      data: (data) {
        return SectionContainer(
          spacing: 30,
          children: <Widget>[
            TitleSubtitleText(
              title: (
                text: l10n.homeFaqTitle,
                size: switch (context.screenSize) {
                  .extraLarge => 64,
                  .large => 48,
                  .normal || .small => 24,
                },
              ),
              subtitle: (
                text: l10n.homeFaqDescription,
                size: switch (context.screenSize) {
                  .extraLarge || .large => 24,
                  .normal || .small => 16,
                },
              ),
              spacing: 12,
            ),
            ResponsiveGrid(
              columnSizes: switch (context.screenSize) {
                .extraLarge => 2,
                _ => 1,
              },
              rowSizes: switch (context.screenSize) {
                .extraLarge => 2,
                _ => data.length,
              },
              children: <Widget>[
                for (final item in data) _FaqCardItem(item: item),
              ],
            ),
          ],
        );
      },
      orElse: () => const Offstage(),
    );
  }
}

class _FaqCardItem extends HookWidget {
  const new({required this.item});

  final FaqEntity item;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;
    final isExpanded = useState(false);

    return SignalBuilder(
      builder: (context) {
        final l10n = appLocalizations.value;

        final isSpanish = l10n.localeName == 'es';
        final question = isSpanish ? item.questionEs : item.questionEn;
        final answer = isSpanish ? item.answerEs : item.answerEn;

        const iconColor = FlutterLatamColors.white;
        final expandedIcon = switch (isExpanded.value) {
          true => const Icon(Icons.remove, color: iconColor, key: ValueKey(1)),
          false => const Icon(Icons.add, color: iconColor, key: ValueKey(2)),
        };

        return Card(
          clipBehavior: .antiAliasWithSaveLayer,
          color: FlutterLatamColors.darkBlue,
          shape: RoundedRectangleBorder(borderRadius: .circular(20)),
          child: Padding(
            padding: const .all(30),
            child: InkWell(
              mouseCursor: SystemMouseCursors.click,
              onTap: () => isExpanded.value = !isExpanded.value,
              child: Column(
                spacing: 10,
                crossAxisAlignment: .start,
                children: <Widget>[
                  Row(
                    spacing: 12,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          question,
                          style: theme.typography.subH2Semibold,
                        ),
                      ),
                      CircleIcon(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: expandedIcon,
                        ),
                      ),
                    ],
                  ),
                  if (isExpanded.value)
                    Text(answer, style: theme.typography.subH3Regular)
                        .animate()
                        .fade(duration: 2.seconds, curve: Curves.fastOutSlowIn),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
