import 'package:dio/dio.dart';

import 'package:rickandmorty/features/episodes/data/models/episodes_all_model.dart';

class EpisodesServices {
  final Dio dio;

  EpisodesServices(this.dio);

  /// Получить список эпизодов с фильтрами
  Future<EpisodesAllModel> getEpisodes(int? page, String? name) async {
    try {
      final response = await dio.get(
        'https://rickandmortyapi.com/api/episode',
        queryParameters: {
          if (page != null) 'page': page,
          if (name != null) 'name': name,
        },
      );

      return EpisodesAllModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  /// Получить список эпизодов по ID
  Future<List<Episode>> getFilteredEpisodes(List<int> episodes) async {
    try {
      final String ids = episodes.join(',');
      final response =
          await dio.get('https://rickandmortyapi.com/api/episode/$ids');

      final dynamic data = response.data;

      if (data is List) {
        return data.map((e) => Episode.fromJson(e)).toList();
      } else if (data is Map<String, dynamic>) {
        return [Episode.fromJson(data)];
      } else {
        throw Exception("Неожиданный формат ответа");
      }
    } catch (e) {
      throw e;
    }
  }
}
