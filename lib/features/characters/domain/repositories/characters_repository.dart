import 'package:rickandmorty/features/characters/data/models/characters_all_model.dart';

abstract class CharactersRepository {
  Future<CharactersAllModel> getCharacters(
    int? page,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
  );
  Future<List<Character>> getMultipleCharacters(List<int>? characters);
}
