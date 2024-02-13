import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metatube_app/components/navbar.dart';
import 'package:metatube_app/screens/login_screen.dart';
import 'package:metatube_app/screens/register_screen.dart';

GoRouter appRouter() => GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return RegisterPage();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'details',
              builder: (BuildContext context, GoRouterState state) {
                return const BottomNavigation();
              },
            ),
          ],
        ),
      ],
    );
