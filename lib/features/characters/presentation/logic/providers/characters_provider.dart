import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty/common/server/dio_client.dart';
import 'package:rickandmorty/features/characters/data/services/characters_service.dart';
import 'package:rickandmorty/features/characters/domain/repositories/impl/characters_repository_impl.dart';
import 'package:rickandmorty/features/characters/presentation/logic/bloc/characters_bloc.dart';

class CharacterProvider extends StatelessWidget {
  final Widget child;

  const CharacterProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dio = DioClient.dio;
    final charactersService = CharactersService(dio);
    final charactersRepository = CharactersRepositoryImpl(charactersService);

    return BlocProvider(
      create: (_) => CharactersBloc(charactersRepository),
      child: child,
    );
  }
}
