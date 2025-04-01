import 'package:rickandmorty/features/characters/data/models/characters_all_model.dart';
import 'package:rickandmorty/features/characters/data/services/characters_service.dart';
import 'package:rickandmorty/features/characters/domain/repositories/characters_repository.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharactersService service;

  CharactersRepositoryImpl(this.service);

  @override
  Future<CharactersAllModel> getCharacters(
    int? page,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
  ) {
    return service.getCharacters(
      page,
      name,
      status,
      species,
      type,
      gender,
    );
  }

  @override
  Future<List<Character>> getMultipleCharacters(
    List<int>? characters,
  ) {
    return service.getMultipleCharacters(
      characters ?? [],
    );
  }
}
