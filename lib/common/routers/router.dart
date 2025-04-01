import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rickandmorty/features/characters/presentation/screens/characters_main_screen.dart';

final GoRouter routerConfig = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/characters',
      builder: (BuildContext context, GoRouterState state) {
        return const CharactersMainScreen();
      },
    ),
  ],
);
