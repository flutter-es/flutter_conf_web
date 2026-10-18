import 'package:flutter_conf_latam/core/seo/meta_tags_manager.dart';
import 'package:flutter_conf_latam/core/seo/seo_config.dart';
import 'package:flutter_conf_latam/core/seo/structured_data_builder.dart';
import 'package:material_ui/material_ui.dart';
import 'package:universal_html/html.dart' as html;

class SeoRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _updateSeoForRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) _updateSeoForRoute(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _updateSeoForRoute(newRoute);
  }

  void _updateSeoForRoute(Route<dynamic> route) {
    final routeName = route.settings.name;
    if (routeName == null || routeName.isEmpty) return;

    final currentUrl = '${SeoConfig.baseUrl}$routeName';
    final seoConfig = SeoConfig.getConfig(routeName);

    MetaTagsManager.updateMetaTags(
      title: seoConfig.title,
      description: seoConfig.description,
      keywords: seoConfig.keywords,
      imageUrl: seoConfig.imageUrl,
      url: currentUrl,
      type: seoConfig.type,
    );
    _addStructuredDataForRoute(routeName);
  }

  void _addStructuredDataForRoute(String route) {
    final cleanRoute = route.split('?').first.replaceAll(RegExp(r'/$'), '');

    switch (cleanRoute) {
      case '/':
      case '/home':
        MetaTagsManager.addStructuredData(
          StructuredDataBuilder.buildEventData(),
        );
      case '/splash':
        MetaTagsManager.removeStructuredData();
      default:
        final parts = cleanRoute.split('/').where((p) => p.isNotEmpty).toList();
        if (parts.isEmpty) return;

        final breadcrumbs = <BreadcrumbItem>[
          const BreadcrumbItem(name: 'Home', url: SeoConfig.baseUrl),
          for (var i = 0; i < parts.length; i++)
            BreadcrumbItem(
              name: _getRouteName(parts[i]),
              url: '${SeoConfig.baseUrl}/${parts.sublist(0, i + 1).join('/')}',
            ),
        ];

        MetaTagsManager.addStructuredData(
          StructuredDataBuilder.buildBreadcrumbData(breadcrumbs),
        );
    }
    _updateHtmlLang();
  }

  String _getRouteName(String routePart) {
    return switch (routePart) {
      'speakers' => 'Speakers',
      'be-sponsor' => 'Sponsorship',
      'privacy-policy' => 'Política de Privacidad',
      'terms-conditions' => 'Términos y Condiciones',
      _ => routePart,
    };
  }

  void _updateHtmlLang() {
    html.document.documentElement?.setAttribute('lang', 'es');
  }
}
