import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty/common/constants/image_assets.dart';
import 'package:rickandmorty/common/server/dio_client.dart';
import 'package:rickandmorty/common/widgets/custom_shimmer_widget.dart';
import 'package:rickandmorty/common/widgets/empty_state_widget.dart';
import 'package:rickandmorty/common/widgets/tiles/custom_tile_widget.dart';
import 'package:rickandmorty/features/characters/presentation/logic/bloc/characters_bloc.dart';
import 'package:rickandmorty/features/characters/presentation/screens/character_detail_screen.dart';
import 'package:rickandmorty/features/episodes/data/services/episodes_services.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/impl/episodes_repository_impl.dart';
import 'package:rickandmorty/features/episodes/presentation/logic/bloc/episodes_bloc.dart';

class MultipleCharactersWidget extends StatefulWidget {
  final int? episodeId;
  final List<int>? charactersId;

  const MultipleCharactersWidget({
    super.key,
    this.episodeId,
    this.charactersId,
  });

  @override
  State<MultipleCharactersWidget> createState() => _MultipleCharactersState();
}

class _MultipleCharactersState extends State<MultipleCharactersWidget> {
  @override
  void initState() {
    if (widget.charactersId != null) {
      if (widget.charactersId!.isNotEmpty) {
        BlocProvider.of<CharactersBloc>(context).add(
          CharactersEvent.getMultipleCharacters(
            widget.charactersId,
          ),
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharactersBloc, CharactersState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () => true,
          loadingGetMultipleCharacters: () => true,
          successGetMultipleCharacters: (list) => true,
          errorGetMultipleCharacters: (err) => true,
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          loadingGetMultipleCharacters: () {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: ShimmerTileWidget(),
            );
          },
          successGetMultipleCharacters: (list) {
            return list.isNotEmpty
                ? Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 24),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              CustomTileWidget(
                                title: list[index].name,
                                description:
                                    '${list[index].species}, ${list[index].gender}',
                                status: list[index].status,
                                imgPath: list[index].image,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (_) => EpisodesBloc(
                                          EpisodesRepositoryImpl(
                                            EpisodesServices(
                                              DioClient.dio,
                                            ),
                                          ),
                                        ),
                                        child: CharacterDetailScreen(
                                          character: list[index],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24)
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 34)
                    ],
                  )
                : const EmptyStateWidget(
                    title: 'Здесь никто не живет',
                    imgPath: 'assets/images/empty_state.png',
                  );
          },
          errorGetMultipleCharacters: (err) {
            return const EmptyStateWidget(
              title: 'Что-то пошло не так',
              imgPath: ImageAssets.errorState,
              width: 120,
            );
          },
          orElse: () {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              child: widget.charactersId!.isEmpty
                  ? const EmptyStateWidget(
                      title: 'Здесь никто не живет',
                      imgPath: ImageAssets.rickFlying,
                    )
                  : const EmptyStateWidget(
                      title: 'Что-то пошло не так',
                      imgPath: ImageAssets.errorState,
                      width: 120,
                    ),
            );
          },
        );
      },
    );
  }
}
