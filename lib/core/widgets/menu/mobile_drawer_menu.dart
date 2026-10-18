import 'package:flutter_conf_latam/core/routes/helpers/navigation_item_model.dart';
import 'package:flutter_conf_latam/core/widgets/menu/extra_buttons.dart';
import 'package:flutter_conf_latam/core/widgets/menu/language_button.dart';
import 'package:flutter_conf_latam/core/widgets/menu/sub_menu_button.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class MobileDrawerMenu extends SignalWidget {
  const new({required this.tabItems, required this.onSelect, super.key});

  final List<NavigationItemModel> tabItems;
  final ValueSetter<NavigationItemModel> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;

    return Drawer(
      backgroundColor: FlutterLatamColors.mainBlue,
      child: SingleChildScrollView(
        padding: const .symmetric(horizontal: 48, vertical: 20),
        child: Column(
          spacing: 20,
          crossAxisAlignment: .stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                for (final (index, item) in tabItems.indexed)
                  if (index == 0)
                    Padding(
                      padding: const .all(8),
                      child: Align(
                        alignment: .topCenter,
                        child: SizedBox(
                          height: 80,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              onSelect(item);
                            },
                            child: SvgPicture.asset(
                              semanticsLabel: l10n.menuHomeText,
                              Assets.images.fclMxMainLogo,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    _ItemDrawer(
                      item: item,
                      onSelect: (value) {
                        Navigator.of(context).pop();
                        onSelect(value);
                      },
                    ),
              ],
            ),
            const ExtraButtons(position: .column),
            const LanguageButton(),
          ],
        ),
      ),
    );
  }
}

class _ItemDrawer extends StatelessWidget {
  const new({required this.item, required this.onSelect});

  final NavigationItemModel item;
  final ValueSetter<NavigationItemModel> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;

    return Padding(
      padding: const .only(top: 20),
      child: SizedBox(
        height: 60,
        child: item.route != null
            ? InkWell(
                onTap: () => onSelect(item),
                borderRadius: const .all(.circular(60)),
                child: Container(
                  alignment: .center,
                  padding: const .symmetric(horizontal: 20),
                  decoration: switch (item.isSelected) {
                    true => BoxDecoration(
                      color: FlutterLatamColors.white.withValues(alpha: .12),
                    ),
                    false => null,
                  },
                  child: Text(
                    item.label,
                    style: theme.typography.body3Regular.copyWith(
                      fontWeight: switch (item.isSelected) {
                        true => .w600,
                        false => .w400,
                      },
                    ),
                  ),
                ),
              )
            : item.subMenus != null
            ? SubMenuButton(tabItem: item, onSelect: onSelect)
            : const Offstage(),
      ),
    );
  }
}
