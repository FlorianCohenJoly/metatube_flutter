import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metatube_app/components/navbar.dart';

GoRouter appRouter() => GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const BottomNavigation();
          },
          // routes: <RouteBase>[
          //   GoRoute(
          //     path: 'details',
          //     builder: (BuildContext context, GoRouterState state) {
          //       return const DetailsScreen();
          //     },
          //   ),
          // ],
        ),
      ],
    );
