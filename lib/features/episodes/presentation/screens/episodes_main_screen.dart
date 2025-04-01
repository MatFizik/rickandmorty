import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rickandmorty/common/constants/image_assets.dart';
import 'package:rickandmorty/common/widgets/cards/custom_card_widget.dart';
import 'package:rickandmorty/common/widgets/custom_search_textfield.dart';
import 'package:rickandmorty/common/widgets/custom_shimmer_widget.dart';
import 'package:rickandmorty/common/widgets/empty_state_widget.dart';
import 'package:rickandmorty/common/widgets/tiles/custom_tile_widget.dart';
import 'package:rickandmorty/features/episodes/data/models/episodes_all_model.dart';
import 'package:rickandmorty/features/episodes/presentation/logic/bloc/episodes_bloc.dart';

class EpisodesMainScreen extends StatefulWidget {
  const EpisodesMainScreen({super.key});

  @override
  State<EpisodesMainScreen> createState() => _EpisodesMainScreenState();
}

class _EpisodesMainScreenState extends State<EpisodesMainScreen> {
  EpisodesAllModel? episodesAllModel;
  List<Episode> episodesList = [];
  Random random = Random();

  late String image;

  int _currentPage = 1;

  bool cardView = false;
  bool isLoadingMore = false;
  bool isSearch = false;

  String? searchName;
  int maxSeason = 0;

  @override
  void initState() {
    BlocProvider.of<EpisodesBloc>(context).add(
      EpisodesEvent.getAllEpisodes(_currentPage, null),
    );
    super.initState();
  }

  String imageRand() {
    int randomNumber = random.nextInt(40) + 1;
    return 'https://rickandmortyapi.com/api/character/avatar/$randomNumber.jpeg';
  }

  Future<void> _refresh() async {
    _currentPage = 1;
    BlocProvider.of<EpisodesBloc>(context).add(
      EpisodesEvent.getAllEpisodes(_currentPage, null),
    );
  }

  void _onFilter(String episodeName) {
    searchName = episodeName;
    if (episodeName.isEmpty || episodeName.length >= 2) {
      BlocProvider.of<EpisodesBloc>(context).add(
        EpisodesEvent.getAllEpisodes(null, searchName),
      );
    }
  }

  void getMaxSeason() {
    if (episodesAllModel != null) {
      setState(() => maxSeason = episodesAllModel?.episodes
              .map((e) => e.seasonId ?? 0)
              .reduce((max, season) => season > max ? season : max) ??
          0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DefaultTabController(
        length: maxSeason, //todo
        child: Scaffold(
          appBar: AppBar(
            title: CustomSearchTextfield(
              onChanged: _onFilter,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: BlocConsumer<EpisodesBloc, EpisodesState>(
              buildWhen: (previous, current) {
                return current.maybeWhen(
                  orElse: () => true,
                  loadingGetAllEpisodes: () => episodesAllModel == null,
                  loadingGetMoreEpisodes: () => false,
                );
              },
              listener: (context, state) {
                state.whenOrNull(
                  loadingGetAllEpisodes: () => isLoadingMore = true,
                  loadingGetFilteredEpisodes: () => true,
                  successGetAllEpisodes: (list) {
                    if (episodesAllModel == null || (searchName != null)) {
                      episodesAllModel = list;
                      episodesList = list.episodes;

                      List<int> episodesIds = List.generate(
                          list.info!.count ?? 1, (index) => index + 1);

                      BlocProvider.of<EpisodesBloc>(context).add(
                        EpisodesEvent.getFilteredEpisodes(episodesIds),
                      );
                    }
                  },
                  successGetFilteredEpisodes: (list) {
                    if (searchName == null || searchName == '') {
                      episodesAllModel?.episodes = list;
                      getMaxSeason();
                      episodesList = list
                          .where((element) => element.seasonId == 1)
                          .toList();
                    }
                  },
                  errorGetFilteredEpisodes: (err) => true,
                  errorGetAllEpisodes: (err) => isLoadingMore = false,
                );
              },
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: state.maybeWhen(
                    loadingGetAllEpisodes: () {
                      return cardView
                          ? const ShimmerGridWidget()
                          : const ShimmerListWidget();
                    },
                    errorGetAllEpisodes: (err) {
                      if (err.response?.statusCode == 404) {
                        return searchName != ''
                            ? const EmptyStateWidget(
                                key: ValueKey('searchEmpty'),
                                title: 'Эпизода с таким\nназванием нет',
                                imgPath: ImageAssets.searchEmpty,
                              )
                            : const EmptyStateWidget(
                                key: ValueKey('filterEmpty'),
                                title: 'По данным фильтра\nничего не найдено',
                                imgPath: ImageAssets.rickSad,
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
                                  "Всего эпизодов: ${episodesAllModel?.info?.count ?? ''}",
                                ),
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
                              ],
                            ),
                            const SizedBox(height: 20),
                            searchName == '' || searchName == null
                                ? TabBar(
                                    isScrollable: true,
                                    tabAlignment: TabAlignment.start,
                                    dividerHeight: 0,
                                    labelPadding: const EdgeInsets.only(
                                        bottom: 5, right: 18),
                                    onTap: (value) {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        episodesList = episodesAllModel!
                                            .episodes
                                            .where(
                                                (e) => e.seasonId == value + 1)
                                            .toList();
                                      });
                                    },
                                    tabs: List<Widget>.generate(
                                      maxSeason,
                                      (index) => Text(
                                        'SEASON ${index + 1}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 26),
                            Expanded(
                              child: !cardView
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: episodesList.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            CustomTileWidget(
                                              title: episodesList[index].name ??
                                                  '',
                                              description:
                                                  episodesList[index].airDate ??
                                                      '',
                                              imageCircle: false,
                                              status:
                                                  "Season ${episodesList[index].seasonId} | "
                                                  "Episode ${episodesList[index].episodeId}",
                                              imgPath: imageRand(),
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                context.push(
                                                  '/episodes-main/episodes-detail',
                                                  extra: episodesList[index],
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 24)
                                          ],
                                        );
                                      },
                                    )
                                  : GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16.0,
                                        mainAxisSpacing: 16.0,
                                        childAspectRatio: 0.7,
                                      ),
                                      itemCount: episodesList.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            CustomCardWidget(
                                              title: episodesList[index].name ??
                                                  '',
                                              description:
                                                  episodesList[index].airDate ??
                                                      '',
                                              status:
                                                  "Season ${episodesList[index].seasonId} | "
                                                  "Episode ${episodesList[index].episodeId}",
                                              imgPath: imageRand(),
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                context.push(
                                                  '/episodes-main/episodes-detail',
                                                  extra: episodesList[index],
                                                );
                                              },
                                            )
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
      ),
    );
  }
}
