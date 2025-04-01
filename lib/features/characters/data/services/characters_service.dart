import 'package:dio/dio.dart';
import 'package:rickandmorty/features/characters/data/models/characters_all_model.dart';

class CharactersService {
  final Dio dio;

  CharactersService(this.dio);

  /// Получить всех персонажей с фильтрами
  Future<CharactersAllModel> getCharacters(
    int? page,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
  ) async {
    try {
      final Response<dynamic> response = await dio.get(
        'https://rickandmortyapi.com/api/character',
        queryParameters: {
          if (page != null) 'page': page,
          if (name != null) 'name': name,
          if (status != null) 'status': status,
          if (species != null) 'species': species,
          if (type != null) 'type': type,
          if (gender != null) 'gender': gender,
        },
      );

      return CharactersAllModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  /// Получить нескольких персонажей по списку ID
  Future<List<Character>> getMultipleCharacters(List<int> characters) async {
    try {
      final String ids = characters.join(',');
      final response =
          await dio.get('https://rickandmortyapi.com/api/character/$ids');

      final dynamic data = response.data;

      if (data is List) {
        return data.map((e) => Character.fromJson(e)).toList();
      } else if (data is Map<String, dynamic>) {
        return [Character.fromJson(data)];
      } else {
        throw Exception("Неожиданный формат ответа");
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw e;
    }
  }
}
