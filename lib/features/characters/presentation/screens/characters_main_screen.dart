import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:rickandmorty/common/constants/image_assets.dart';
import 'package:rickandmorty/common/models/filters_model.dart';
import 'package:rickandmorty/common/theme/app_colors.dart';
import 'package:rickandmorty/common/widgets/cards/custom_card_widget.dart';
import 'package:rickandmorty/common/widgets/custom_search_textfield.dart';
import 'package:rickandmorty/common/widgets/custom_shimmer_widget.dart';
import 'package:rickandmorty/common/widgets/empty_state_widget.dart';
import 'package:rickandmorty/common/widgets/tiles/custom_tile_widget.dart';
import 'package:rickandmorty/features/characters/data/models/characters_all_model.dart';
import 'package:rickandmorty/features/characters/presentation/logic/bloc/characters_bloc.dart';
import 'package:rickandmorty/features/characters/presentation/widgets/characters_filter_widget.dart';

class CharactersMainScreen extends StatefulWidget {
  const CharactersMainScreen({super.key});

  @override
  State<CharactersMainScreen> createState() => _CharactersMainScreenState();
}

class _CharactersMainScreenState extends State<CharactersMainScreen> {
  CharactersAllModel? characters;

  int _currentPage = 1;

  late int _maxPage;
  late ScrollController _scrollController;

  FiltersModel filters = FiltersModel();
  FiltersModel localFilters = FiltersModel();

  bool cardView = false;
  bool isLoadingMore = false;
  bool isSearch = false;

  String searchName = '';

  @override
  void initState() {
    BlocProvider.of<CharactersBloc>(context).add(
      CharactersEvent.getCharacters(_currentPage, null, null, null, null, null),
    );

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshCharacters() async {
    _currentPage = 1;
    BlocProvider.of<CharactersBloc>(context).add(
      CharactersEvent.getCharacters(
        _currentPage,
        searchName,
        filters.status,
        filters.species,
        filters.type,
        filters.gender,
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_currentPage < _maxPage) {
        isLoadingMore = true;
        _currentPage += 1;
        BlocProvider.of<CharactersBloc>(context).add(
          CharactersEvent.getCharacters(
            _currentPage,
            searchName,
            filters.status,
            filters.species,
            filters.type,
            filters.gender,
          ),
        );
      }
    }
  }

  void onSearch(String characterName) {
    localFilters = FiltersModel(
      status: filters.status,
      gender: filters.gender,
    );
    searchName = characterName;
    _currentPage = 1;
    isSearch = true;
    BlocProvider.of<CharactersBloc>(context).add(
      CharactersEvent.getCharacters(
        _currentPage,
        characterName,
        filters.status,
        filters.species,
        filters.type,
        filters.gender,
      ),
    );
  }

  void onFilter() {
    if (localFilters.gender != filters.gender ||
        localFilters.status != filters.status) {
      localFilters = FiltersModel(
        status: filters.status,
        gender: filters.gender,
      );
      _currentPage = 1;
      isSearch = true;
      BlocProvider.of<CharactersBloc>(context).add(
        CharactersEvent.getCharacters(
          _currentPage,
          searchName,
          filters.status,
          filters.species,
          filters.type,
          filters.gender,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: context.canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () => context.pop(),
                )
              : null,
          title: CustomSearchTextfield(
            onChanged: onSearch,
            filter: true,
            onLeading: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return CharactersFiltersBottomSheet(filters: filters);
                },
              ).then((_) => onFilter());
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshCharacters,
          child: BlocConsumer<CharactersBloc, CharactersState>(
            listener: (context, state) {
              state.whenOrNull(
                loadingGetCharacters: () => true,
                successGetMoreCharacters: (list) {
                  if (isLoadingMore) {
                    characters?.characters.addAll(list.characters);
                    isLoadingMore = false;
                  }
                },
                successGetCharacters: (list) {
                  if (characters == null || !isLoadingMore) {
                    characters = list;
                    _maxPage = list.info.pages;
                  }
                },
                errorGetCharacters: (err) => isLoadingMore = false,
                errorGetMultipleCharacters: (err) => true,
              );
            },
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: state.maybeWhen(
                  loadingGetCharacters: () {
                    return cardView
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 60),
                            child: ShimmerGridWidget(),
                          )
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 60),
                            child: ShimmerListWidget(),
                          );
                  },
                  errorGetCharacters: (err) {
                    if (err.response?.statusCode == 404) {
                      return searchName != ''
                          ? const EmptyStateWidget(
                              key: ValueKey('searchEmpty'),
                              title: 'Персонажа с таким\n именем нет',
                              imgPath: ImageAssets.searchEmpty,
                            )
                          : const EmptyStateWidget(
                              key: ValueKey('filterEmpty'),
                              title: 'По данным фильтра\nничего не найдено',
                              imgPath: ImageAssets.rickFlying,
                            );
                    }
                    return null;
                  },
                  orElse: () {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Всего персонажей: ${characters?.info.count ?? ''}",
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        cardView = !cardView;
                                      });
                                    },
                                    child: !cardView
                                        ? Image.asset(ImageAssets.gridCardIcon)
                                        : Image.asset(ImageAssets.gridListIcon),
                                  ),
                                  filters.gender != null ||
                                          filters.status != null
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                            left: 24,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              setState(() {
                                                filters = FiltersModel();
                                              });
                                              onFilter();
                                            },
                                            child: Image.asset(
                                              width: 30,
                                              ImageAssets.removeFiltersIcon,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: !cardView
                                ? ListView.builder(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    itemCount:
                                        (characters?.characters.length ?? 0) +
                                            3,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          index <
                                                  (characters
                                                          ?.characters.length ??
                                                      2)
                                              ? CustomTileWidget(
                                                  title: characters
                                                          ?.characters[index]
                                                          .name ??
                                                      '',
                                                  description:
                                                      '${characters?.characters[index].species},'
                                                      '${characters?.characters[index].gender}',
                                                  status: characters
                                                          ?.characters[index]
                                                          .status ??
                                                      '',
                                                  statusColor: characters
                                                              ?.characters[
                                                                  index]
                                                              .status ==
                                                          'Alive'
                                                      ? AppColors.green
                                                      : characters
                                                                  ?.characters[
                                                                      index]
                                                                  .status ==
                                                              'Dead'
                                                          ? AppColors.red
                                                          : null,
                                                  imgPath: characters
                                                          ?.characters[index]
                                                          .image ??
                                                      ImageAssets.rickSad,
                                                  onTap: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    context.push(
                                                      '/characters-main/characters-detail',
                                                      extra: characters!
                                                          .characters[index],
                                                    );
                                                  },
                                                )
                                              : index <
                                                      (characters?.info.count ??
                                                          0)
                                                  ? const ShimmerTileWidget()
                                                  : const SizedBox(),
                                          const SizedBox(height: 24)
                                        ],
                                      );
                                    },
                                  )
                                : GridView.builder(
                                    controller: _scrollController,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16.0,
                                      mainAxisSpacing: 16.0,
                                      childAspectRatio: 0.7,
                                    ),
                                    itemCount:
                                        (characters?.characters.length ?? 0) +
                                            2,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          index <
                                                  (characters
                                                          ?.characters.length ??
                                                      1)
                                              ? CustomCardWidget(
                                                  title: characters
                                                          ?.characters[index]
                                                          .name ??
                                                      '',
                                                  description:
                                                      '${characters?.characters[index].species},'
                                                      '${characters?.characters[index].gender}',
                                                  status: characters
                                                          ?.characters[index]
                                                          .status ??
                                                      '',
                                                  statusColor: characters
                                                              ?.characters[
                                                                  index]
                                                              .status ==
                                                          'Alive'
                                                      ? AppColors.green
                                                      : characters
                                                                  ?.characters[
                                                                      index]
                                                                  .status ==
                                                              'Dead'
                                                          ? AppColors.red
                                                          : null,
                                                  imgPath: characters
                                                          ?.characters[index]
                                                          .image ??
                                                      ImageAssets.rickSad,
                                                  onTap: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    context.push(
                                                      '/characters-main/characters-detail',
                                                      extra: characters!
                                                          .characters[index],
                                                    );
                                                  },
                                                )
                                              : index < characters!.info.count
                                                  ? const ShimmerCardWidget()
                                                  : const SizedBox(),
                                          const SizedBox(height: 24),
                                        ],
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
