import 'package:collection/collection.dart';
import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/routes/app_route_path.dart';
import 'package:flutter_conf_latam/core/routes/helpers/navigation_item_model.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:signals/signals.dart';

class NavigationController {
  new() {
    _state = signal(_buildInitialList());
  }

  late final Signal<List<NavigationItemModel>> _state;

  List<NavigationItemModel> get value => _state.value;

  ReadonlySignal<List<NavigationItemModel>> get state => _state;

  List<NavigationItemModel> _buildInitialList() {
    final navigationItemList = <NavigationItemModel>[
      NavigationItemModel(
        label: '',
        route: '/${AppRoutePath.home.pathName}',
        isSelected: true,
      ),
      NavigationItemModel(
        label: appLocalizations.value.menuSpeakersText,
        route: '/${AppRoutePath.speakers.pathName}',
      ),
    ];

    if (_selectedNav.isEmpty) return navigationItemList;
    return navigationItemList.map((item) {
      if (item.route != null) {
        if (item.route == _selectedNav) return item.copyWith(isSelected: true);
      } else if (item.subMenus != null) {
        final subMenu = item.subMenus!.firstWhereOrNull(
          (item) => item.route == _selectedNav,
        );
        if (subMenu != null) {
          final newSubmenu = subMenu.copyWith(isSelected: true);
          final index = item.subMenus!.indexOf(subMenu);

          final newSubmenus = [...item.subMenus!]
            ..removeAt(index)
            ..insert(index, newSubmenu);

          return item.copyWith(isSelected: true, subMenus: newSubmenus);
        }
      }
      return item;
    }).toList();
  }

  void init() {
    if (_selectedNav.isNotEmpty) {
      selectNavItemFromRoute(_selectedNav);
    } else {
      selectNavItem(_state.value.first);
    }
  }

  void selectNavItemFromRoute(String route) {
    selectNavItem(
      _state.value.firstWhere((item) {
        if (item.route != null) {
          return item.route == route;
        } else if (item.subMenus != null) {
          return item.subMenus!.where((item) => item.route == route).isNotEmpty;
        }
        return false;
      }, orElse: () => _state.value.first),
    );
  }

  void selectNavItem(NavigationItemModel item) {
    _state.value = [
      for (final element in _state.value)
        element.copyWith(
          isSelected: item.route == element.route,
          subMenus: item.route != element.route
              ? item.subMenus?.map((item) {
                  return item.copyWith(isSelected: false);
                }).toList()
              : item.subMenus,
        ),
    ];

    final currentRoute =
        item.route ??
        item.subMenus?.firstWhereOrNull((item) => item.isSelected)?.route;

    if (currentRoute == null) return;
    webLocalStorage.value.storeSelectedNav(currentRoute);
  }

  String get _selectedNav => webLocalStorage.value.getSelectedNav();

  void dispose() => _state.dispose();
}

final navigationController = NavigationController();
