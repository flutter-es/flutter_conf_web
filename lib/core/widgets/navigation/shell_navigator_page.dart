import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/routes/helpers/navigation_item_model.dart';
import 'package:flutter_conf_latam/core/routes/helpers/navigation_view_model.dart';
import 'package:flutter_conf_latam/core/widgets/menu/header_menu.dart';
import 'package:flutter_conf_latam/core/widgets/menu/mobile_drawer_menu.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/generated/assets.gen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class ShellNavigatorPage extends SignalStatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  State<ShellNavigatorPage> createState() => _ShellNavigatorPageState();
}

class _ShellNavigatorPageState extends State<ShellNavigatorPage> {
  List<NavigationItemModel>? _previousItems;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigationController.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final allItems = navigationController.value;

    final tabItems = allItems.where((item) => item.visible).toList();

    if (_previousItems != null && !listEquals(_previousItems, allItems)) {
      final itemRoute = allItems.singleWhereOrNull((item) => item.isSelected);
      if (itemRoute != null) {
        if ((itemRoute.route ?? '').isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) context.go(itemRoute.route!);
          });
        } else if ((itemRoute.subMenus ?? []).isNotEmpty) {
          final subItemRoute = itemRoute.subMenus?.singleWhereOrNull(
            (item) => item.isSelected,
          );
          if (subItemRoute != null && subItemRoute.route.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) context.go(subItemRoute.route);
            });
          }
        }
      }
    }
    _previousItems = List.from(allItems);

    return Scaffold(
      backgroundColor: FlutterLatamColors.mainBlue,
      appBar: switch (context.isMobileFromResponsive) {
        true => AppBar(
          backgroundColor: FlutterLatamColors.mainBlue,
          leadingWidth: 90,
          leading: Padding(
            padding: const .all(8),
            child: InkWell(
              mouseCursor: SystemMouseCursors.click,
              onTap: switch (tabItems.isNotEmpty) {
                true => () => _goToRoute(tabItems.first),
                false => null,
              },
              child: SvgPicture.asset(
                Assets.images.fclMxMainLogo,
                semanticsLabel: l10n.menuHomeText,
              ),
            ),
          ),
        ),
        false => null,
      },
      endDrawer: switch (context.isMobileFromResponsive) {
        true => MobileDrawerMenu(tabItems: tabItems, onSelect: _goToRoute),
        false => null,
      },
      body: Column(
        children: <Widget>[
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (_, _) {
                return [
                  if (!context.isMobileFromResponsive)
                    HeaderMenu(tabItems: tabItems, onSelect: _goToRoute),
                ];
              },
              body: widget.child,
            ),
          ),
          /*
            SizedBox(
              height: switch (context.screenSize) {
                .extraLarge || .large => 56,
                .normal || .small => 40,
              },
              child: ColoredBox(
                color: FlutterLatamColors.yellow,
                child: MarqueeTextAnimation(text: l10n.marqueeDisclaimer),
              ),
            ),
            */
        ],
      ),
    );
  }

  void _goToRoute(NavigationItemModel item) {
    navigationController.selectNavItem(item);

    final routeSubmenu = item.subMenus
        ?.firstWhereOrNull((i) => i.isSelected)
        ?.route;

    final route = item.route ?? routeSubmenu;
    if (route != null && route.isNotEmpty) context.go(route);
  }
}
