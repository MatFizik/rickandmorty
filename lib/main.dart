import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty/common/routers/router.dart';
import 'package:rickandmorty/common/server/dio_client.dart';
import 'package:rickandmorty/common/theme/app_theme.dart';
import 'package:rickandmorty/common/theme/bloc/cubit/theme_cubit.dart';
import 'package:rickandmorty/features/characters/data/services/characters_service.dart';
import 'package:rickandmorty/features/characters/domain/repositories/impl/characters_repository_impl.dart';
import 'package:rickandmorty/features/characters/presentation/logic/bloc/characters_bloc.dart';
import 'package:rickandmorty/features/episodes/data/services/episodes_services.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/impl/episodes_repository_impl.dart';
import 'package:rickandmorty/features/episodes/presentation/logic/bloc/episodes_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = DioClient.dio;

    final charactersService = CharactersService(dio);
    final charactersRepository = CharactersRepositoryImpl(charactersService);

    final episodesService = EpisodesServices(dio);
    final episodesRepository = EpisodesRepositoryImpl(episodesService);

    return MultiBlocProvider(
      providers: [
        BlocProvider<CharactersBloc>(
          create: (BuildContext context) =>
              CharactersBloc(charactersRepository),
        ),
        BlocProvider<EpisodesBloc>(
          create: (BuildContext context) => EpisodesBloc(episodesRepository),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            theme: state.brightness == Brightness.dark
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            routerConfig: routerConfig,
          );
        },
      ),
    );
  }
}
