import 'dart:convert';

import 'package:floor/floor.dart';

@entity
class Genres {
  @PrimaryKey(autoGenerate: false)
  final int id;
  String name;
  Genres(
    this.id,
    this.name,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Genres.fromMap(Map<String, dynamic> map) {
    return Genres(
      map['id'],
      map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Genres.fromJson(String source) => Genres.fromMap(json.decode(source));

  static Genres getGenreMaster(List<Genres> genres, int id) {
    for (var genre in genres) {
      if (genre.id == id) {
        return genre;
      }
    }
    return Genres(0, "none");
  }
}

@dao
abstract class GenresDao {
  @Query('SELECT * FROM Genres')
  Future<List<Genres>> findAllGenres();

  @Query('SELECT * FROM Genres WHERE id = :id')
  Future<Genres?> findGenreById(int id);

  @insert
  Future<void> insertGenre(Genres data);
}
