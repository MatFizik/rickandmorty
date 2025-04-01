import 'package:rickandmorty/features/episodes/data/models/episodes_all_model.dart';
import 'package:rickandmorty/features/episodes/data/services/episodes_services.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episodes_repository.dart';

class EpisodesRepositoryImpl implements EpisodesRepository {
  final EpisodesServices service;

  EpisodesRepositoryImpl(this.service);

  @override
  Future<EpisodesAllModel> getAllEpisodes(int? page, String? name) {
    return service.getEpisodes(page, name);
  }

  @override
  Future<List<Episode>> getFilteredEpisodes(List<int> episodes) {
    return service.getFilteredEpisodes(episodes);
  }
}
