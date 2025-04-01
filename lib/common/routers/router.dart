import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rickandmorty/features/characters/data/models/characters_all_model.dart';
import 'package:rickandmorty/features/characters/presentation/screens/character_detail_screen.dart';
import 'package:rickandmorty/features/characters/presentation/screens/characters_main_screen.dart';
import 'package:rickandmorty/features/episodes/data/models/episodes_all_model.dart';
import 'package:rickandmorty/features/episodes/presentation/screens/episode_detail_screen.dart';
import 'package:rickandmorty/features/episodes/presentation/screens/episodes_main_screen.dart';
import 'package:rickandmorty/main_navigation.dart';

final GoRouter routerConfig = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MainNavigation();
      },
      routes: <RouteBase>[
        // Characters
        GoRoute(
          path: 'characters-main',
          builder: (BuildContext context, GoRouterState state) {
            return const CharactersMainScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'characters-detail',
              builder: (context, state) {
                final character = state.extra as Character;
                return CharacterDetailScreen(
                  character: character,
                );
              },
            )
          ],
        ),
        // Episodes
        GoRoute(
            path: 'episodes-main',
            builder: (context, state) {
              return const EpisodesMainScreen();
            },
            routes: <RouteBase>[
              GoRoute(
                  path: 'episodes-detail',
                  builder: (context, state) {
                    final episode = state.extra as Episode;
                    return EpisodeDetailScreen(
                      episode: episode,
                    );
                  }),
            ]),
      ],
    ),
  ],
);
