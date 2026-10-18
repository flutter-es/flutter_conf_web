import 'package:flutter_conf_latam/core/routes/helpers/navigation_item_model.dart';
import 'package:flutter_conf_latam/core/widgets/menu/extra_buttons.dart';
import 'package:flutter_conf_latam/core/widgets/menu/language_button.dart';
import 'package:flutter_conf_latam/core/widgets/menu/sub_menu_button.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

class HeaderMenu extends HookWidget {
  const new({required this.tabItems, required this.onSelect, super.key});

  final List<NavigationItemModel> tabItems;
  final ValueSetter<NavigationItemModel> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;
    final tabController = useTabController(
      initialLength: tabItems.length,
      initialIndex: tabItems.indexWhere((item) => item.isSelected),
    );

    return SliverAppBar(
      pinned: true,
      elevation: 0,
      collapsedHeight: 100,
      expandedHeight: 120,
      backgroundColor: FlutterLatamColors.mainBlue,
      flexibleSpace: Padding(
        padding: const .symmetric(vertical: 20, horizontal: 122),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TabBar(
                onTap: (index) {
                  final item = tabItems[index];
                  if (item.route != null) onSelect(item);
                },
                controller: tabController,
                tabAlignment: .start,
                isScrollable: true,
                indicatorWeight: 1,
                dividerColor: Colors.transparent,
                labelColor: FlutterLatamColors.darkBlue,
                indicatorColor: switch (tabController.index) {
                  0 => Colors.transparent,
                  _ => FlutterLatamColors.white,
                },
                unselectedLabelColor: FlutterLatamColors.silver,
                tabs: <Widget>[
                  for (final (index, item) in tabItems.indexed)
                    if (index == 0)
                      LayoutBuilder(
                        builder: (_, constraint) => SizedBox(
                          height: constraint.maxHeight,
                          child: SvgPicture.asset(Assets.images.fclMxMainLogo),
                        ),
                      )
                    else if (item.route != null)
                      Tab(
                        child: Text(
                          item.label,
                          style: theme.typography.body3Regular.copyWith(
                            fontWeight: switch (item.isSelected) {
                              true => .w600,
                              false => .w400,
                            },
                          ),
                        ),
                      )
                    else if (item.subMenus != null)
                      Tab(
                        child: SubMenuButton(
                          tabItem: item,
                          onSelect: (value) {
                            tabController.index = index;
                            onSelect(value);
                          },
                        ),
                      ),
                ],
              ),
            ),
            const ExtraButtons(position: .row),
            const LanguageButton(),
          ],
        ),
      ),
    );
  }
}
