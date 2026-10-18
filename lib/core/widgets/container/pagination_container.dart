import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:flutter_conf_latam/styles/core/colors.dart';
import 'package:flutter_conf_latam/styles/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class PaginationContainer extends SignalWidget {
  const new({
    required this.child,
    required this.totalSize,
    required this.pageSize,
    required this.onChangedPage,
    this.currentPage = 1,
    this.maxButtons = 3,
    super.key,
  });

  final Widget child;
  final int totalSize;
  final int pageSize;
  final ValueSetter<int> onChangedPage;
  final int currentPage;
  final int maxButtons;

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;

    return Column(
      spacing: 30,
      mainAxisSize: .min,
      children: <Widget>[
        child,
        SizedBox(
          height: 84,
          child: SingleChildScrollView(
            scrollDirection: .horizontal,
            child: Row(
              spacing: 20,
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              children: <Widget>[
                _PaginationButton(
                  semanticLabel: l10n.previousPageText,
                  onPressed: currentPage > 1
                      ? () => onChangedPage(currentPage - 1)
                      : null,
                  child: const Icon(Icons.arrow_back_ios, size: 24),
                ),
                _PaginationNumberButtons(
                  currentPage: currentPage,
                  totalPages: _totalPages,
                  onSendPage: onChangedPage,
                  maxButtons: maxButtons,
                ),
                _PaginationButton(
                  semanticLabel: l10n.nextPageText,
                  onPressed: currentPage < _totalPages
                      ? () => onChangedPage(currentPage + 1)
                      : null,
                  child: const Icon(Icons.arrow_forward_ios, size: 24),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int get _totalPages => (totalSize / pageSize).ceil();
}

class _PaginationNumberButtons extends SignalWidget {
  const new({
    required this.currentPage,
    required this.totalPages,
    required this.onSendPage,
    required this.maxButtons,
  });

  final int currentPage;
  final int totalPages;
  final ValueSetter<int> onSendPage;
  final int maxButtons;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const Offstage();

    final l10n = appLocalizations.value;

    var startPage = max(1, currentPage - (maxButtons / 2).floor());
    final endPage = min(totalPages, startPage + maxButtons - 1);

    if (endPage == totalPages) startPage = max(1, totalPages - maxButtons + 1);

    return Row(
      spacing: 20,
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      children: <Widget>[
        if (startPage > 1) ...[
          _PaginationButton(
            semanticLabel: l10n.numberPageText(1),
            onPressed: () => onSendPage(1),
            child: const Text('1'),
          ),
          if (startPage > 2)
            _PaginationButton(
              semanticLabel: l10n.morePagesText,
              child: const Text('...'),
            ),
        ],
        ...[
          for (var i = startPage; i <= endPage; i++)
            _PaginationButton(
              semanticLabel: l10n.numberPageText(i),
              onPressed: () => onSendPage(i),
              isActive: currentPage == i,
              child: Text('$i'),
            ),
        ],
        if (endPage < totalPages) ...[
          if (endPage < totalPages - 1)
            _PaginationButton(
              semanticLabel: l10n.morePagesText,
              child: const Text('...'),
            ),
          _PaginationButton(
            semanticLabel: l10n.numberPageText(totalPages),
            onPressed: () => onSendPage(totalPages),
            child: Text('$totalPages'),
          ),
        ],
      ],
    );
  }
}

class _PaginationButton extends StatelessWidget {
  const new({
    required this.semanticLabel,
    required this.child,
    this.onPressed,
    this.isActive = false,
  });

  final String semanticLabel;
  final Widget child;
  final VoidCallback? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme.fclThemeScheme;
    final background = isActive ? FlutterLatamColors.blue : Colors.transparent;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        fixedSize: const .square(64),
        shadowColor: background,
        backgroundColor: background,
        foregroundColor: FlutterLatamColors.white,
        disabledForegroundColor: FlutterLatamColors.white.withValues(alpha: .5),
        shape: RoundedRectangleBorder(
          side: isActive
              ? .none
              : const BorderSide(color: FlutterLatamColors.white, width: 1.5),
          borderRadius: const .all(.circular(6)),
        ),
        textStyle: theme.typography.body2Regular,
      ),
      onPressed: onPressed,
      child: Semantics(
        label: semanticLabel,
        role: SemanticsRole.spinButton,
        child: child,
      ),
    );
  }
}
