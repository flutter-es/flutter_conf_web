import 'package:equatable/equatable.dart';

class NavigationItemModel extends Equatable {
  const new({
    required this.label,
    this.route,
    this.isSelected = false,
    this.visible = true,
    this.subMenus,
  });

  final String label;
  final String? route;
  final bool isSelected;
  final bool visible;
  final List<SubNavigationItemModel>? subMenus;

  NavigationItemModel copyWith({
    bool? isSelected,
    List<SubNavigationItemModel>? subMenus,
  }) {
    return NavigationItemModel(
      label: label,
      route: route,
      isSelected: isSelected ?? this.isSelected,
      visible: visible,
      subMenus: subMenus ?? this.subMenus,
    );
  }

  @override
  List<Object?> get props => [route, isSelected, visible, subMenus];
}

class SubNavigationItemModel extends Equatable {
  const new({
    required this.label,
    required this.route,
    this.isSelected = false,
  });

  final String label;
  final String route;
  final bool isSelected;

  SubNavigationItemModel copyWith({bool? isSelected}) {
    return SubNavigationItemModel(
      label: label,
      route: route,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [route, isSelected];
}
