import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:material_ui/material_ui.dart';

class ResponsiveGrid extends StatelessWidget {
  const new({
    required this.children,
    required this.columnSizes,
    required this.rowSizes,
    super.key,
  });

  final List<Widget> children;
  final int columnSizes;
  final int rowSizes;

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      rowGap: 30,
      columnGap: 30,
      columnSizes: .generate(columnSizes, (_) => 1.fr),
      rowSizes: .generate(rowSizes, (_) => auto),
      children: children,
    );
  }
}
