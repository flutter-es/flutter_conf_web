import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conf_latam/core/routes/app_route_path.dart';
import 'package:flutter_conf_latam/core/routes/app_routes_pages.dart';
import 'package:flutter_conf_latam/core/routes/helpers/seo_route_observer.dart';
import 'package:flutter_conf_latam/core/widgets/navigation/shell_navigator_page.dart';
import 'package:flutter_conf_latam/features/agenda/presentation/pages/agenda_redirect_page.dart';
import 'package:flutter_conf_latam/features/errors/presentation/pages/error_page.dart';
import 'package:flutter_conf_latam/features/home/presentation/pages/home_page.dart';
import 'package:flutter_conf_latam/features/privacy_terms/presentation/pages/privacy_page.dart';
import 'package:flutter_conf_latam/features/privacy_terms/presentation/pages/terms_page.dart';
import 'package:flutter_conf_latam/features/speakers/presentation/pages/speakers_page.dart';
import 'package:flutter_conf_latam/features/splash/presentation/pages/splash.page.dart';
import 'package:flutter_conf_latam/features/sponsorship/presentation/pages/sponsorship_page.dart';
import 'package:go_router/go_router.dart';

final _mainRoutesKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _tabRoutesKeys = GlobalKey<NavigatorState>(debugLabel: 'tabShell');

class AppRoutes {
  AppRoutes()
    : _router = GoRouter(
        initialLocation: '/${AppRoutePath.splash.pathName}',
        routerNeglect: true,
        navigatorKey: _mainRoutesKey,
        observers: [SeoRouteObserver()],
        routes: <RouteBase>[
          GoRoute(
            path: '/${AppRoutePath.splash.pathName}',
            parentNavigatorKey: _mainRoutesKey,
            pageBuilder: (_, state) {
              return ScreenPage(key: state.pageKey, child: const SplashPage());
            },
          ),
          GoRoute(
            path: '/${AppRoutePath.agenda.pathName}',
            parentNavigatorKey: _mainRoutesKey,
            pageBuilder: (_, state) {
              return ScreenPage(
                key: state.pageKey,
                child: const AgendaRedirectPage(),
              );
            },
          ),
          ShellRoute(
            navigatorKey: _tabRoutesKeys,
            builder: (_, _, child) => ShellNavigatorPage(child: child),
            routes: <RouteBase>[
              GoRoute(
                path: '/${AppRoutePath.home.pathName}',
                parentNavigatorKey: _tabRoutesKeys,
                pageBuilder: (_, _) {
                  return const NoTransitionPage(child: HomePage());
                },
              ),
              GoRoute(
                path: '/${AppRoutePath.sponsorship.pathName}',
                parentNavigatorKey: _tabRoutesKeys,
                pageBuilder: (_, _) {
                  return const NoTransitionPage(child: SponsorshipPage());
                },
              ),
              GoRoute(
                path: '/${AppRoutePath.speakers.pathName}',
                parentNavigatorKey: _tabRoutesKeys,
                pageBuilder: (_, _) {
                  return const NoTransitionPage(child: SpeakersPage());
                },
              ),
              GoRoute(
                path: '/${AppRoutePath.privacyPolicy.pathName}',
                parentNavigatorKey: _tabRoutesKeys,
                pageBuilder: (_, _) {
                  return const NoTransitionPage(child: PrivacyPage());
                },
              ),
              GoRoute(
                path: '/${AppRoutePath.termsConditions.pathName}',
                parentNavigatorKey: _tabRoutesKeys,
                pageBuilder: (_, _) {
                  return const NoTransitionPage(child: TermsPage());
                },
              ),
            ],
          ),
        ],
        errorPageBuilder: (_, _) {
          return const NoTransitionPage(child: ErrorPage());
        },
        debugLogDiagnostics: kDebugMode,
      );

  final GoRouter _router;

  GoRouter get router => _router;
}
