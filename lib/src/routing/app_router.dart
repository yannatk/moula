// ignore_for_file: dead_code

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moula/src/features/auth/presentation/custom_sign_in_screen.dart';
import 'package:moula/src/features/auth/presentation/firebase_auth_provider.dart';
import 'package:moula/src/features/calendar_screen.dart';
import 'package:moula/src/features/transactions_screen.dart';
import 'package:moula/src/routing/go_router_refresh_stream.dart';
import 'package:moula/src/routing/presentation/bottom_navigation_bar/app_bottom_navigation_bar.dart';
import 'package:moula/src/routing/presentation/not_found_screen.dart';
import 'package:moula/src/routing/presentation/splash_screen/splash_screen.dart';

enum AppRoute {
  splashScreen,
  authenticationScreen,
  calendarScreen,
  transactionsScreen,
}

extension AppRouteX on AppRoute {
  String get location => '/$name';

  static List<String> get authenticatedRoutes => [
        AppRoute.calendarScreen.location,
        AppRoute.transactionsScreen.location,
      ];

  static List<String> get authenticationRoutes => [
        AppRoute.authenticationScreen.location,
      ];
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);

  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  final shellNavigatorCalendarKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellCalendar');
  final shellNavigatorTransactionsKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellTransactions');

  return GoRouter(
    navigatorKey: rootNavigatorKey,

    initialLocation: '/',

    debugLogDiagnostics: true,

    redirect: (context, state) {
      final isLoggedIn = firebaseAuth.currentUser != null;

      if (isLoggedIn) {
        // If the current route is none of the authenticated routes
        if (!AppRouteX.authenticatedRoutes.any(
          (routeLocation) => state.uri.path.contains(routeLocation),
        )) {
          return AppRoute.calendarScreen.location;
        }
      } else {
        // If the current route is not the authentication routes or any of the authenticated routes
        if (AppRouteX.authenticationRoutes
                .none((location) => state.uri.path.contains(location)) ||
            AppRouteX.authenticatedRoutes.any(
              (routeLocation) => state.uri.path.contains(routeLocation),
            )) {
          return AppRoute.authenticationScreen.location;
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.splashScreen.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SplashScreen()),
      ),
      GoRoute(
        path: AppRoute.authenticationScreen.location,
        name: AppRoute.authenticationScreen.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CustomSignInScreen(),
        ),
      ),
      // The stateful shell route
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // The bottom navigation bar
          return AppBottomNavigationBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorCalendarKey,
            routes: [
              GoRoute(
                path: AppRoute.calendarScreen.location,
                name: AppRoute.calendarScreen.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: Center(child: CalendarScreen()),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorTransactionsKey,
            routes: [
              GoRoute(
                path: AppRoute.transactionsScreen.location,
                name: AppRoute.transactionsScreen.name,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: Center(child: TransactionsScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
    // The not found screen
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
