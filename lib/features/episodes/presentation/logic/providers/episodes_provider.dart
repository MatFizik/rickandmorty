import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty/common/server/dio_client.dart';
import 'package:rickandmorty/features/episodes/data/services/episodes_services.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/impl/episodes_repository_impl.dart';
import 'package:rickandmorty/features/episodes/presentation/logic/bloc/episodes_bloc.dart';

class EpisodesProvider extends StatelessWidget {
  final Widget child;

  const EpisodesProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dio = DioClient.dio;
    final service = EpisodesServices(dio);
    final repository = EpisodesRepositoryImpl(service);

    return BlocProvider(
      create: (_) => EpisodesBloc(repository),
      child: child,
    );
  }
}
