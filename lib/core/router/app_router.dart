import 'package:flutter/material.dart';
import 'package:flutter_face_rec/core/router/router_constant.dart';
import 'package:flutter_face_rec/pages/home/home_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  AppRouter._();

  static final GoRouter _instance = _createRouter();

  static GoRouter get goRouter => _instance;
  static GoRouter _createRouter() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: AppRoutes.home,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const HomePage(),
        ),
      ],
      navigatorKey: rootNavigatorKey,
      initialLocation: '/',
    );
    return router;
  }
}

// temporary solutiion on [GoRouter] pop until [issues] https://github.com/flutter/flutter/issues/131625
extension GoRouterExtension on GoRouter {
  void popUntilPath(String ancestorPath) {
    while (routerDelegate.currentConfiguration.matches.last.matchedLocation !=
        ancestorPath) {
      if (!canPop()) {
        return;
      }
      pop();
    }
  }
}
