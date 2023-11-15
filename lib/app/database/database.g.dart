// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  GenresDao? _genresDaoInstance;

  MovieDataDao? _movieDataDaoInstance;

  MovieGenresDao? _movieGenresDaoInstance;

  MovieVideosDao? _movieVideosDaoInstance;

  MovieImagesDao? _movieImagesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Genres` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MovieData` (`id` INTEGER NOT NULL, `adult` INTEGER NOT NULL, `backdropPath` TEXT NOT NULL, `originalLanguage` TEXT NOT NULL, `originalTitle` TEXT NOT NULL, `overview` TEXT NOT NULL, `popularity` REAL NOT NULL, `posterPath` TEXT NOT NULL, `releaseDate` TEXT NOT NULL, `title` TEXT NOT NULL, `video` INTEGER NOT NULL, `voteAverage` REAL NOT NULL, `voteCount` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MovieGenres` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `movieId` INTEGER NOT NULL, `genreId` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MovieImages` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `movieId` INTEGER NOT NULL, `imageType` TEXT NOT NULL, `aspectRatio` REAL NOT NULL, `height` INTEGER NOT NULL, `iso_639_1` TEXT NOT NULL, `filePath` TEXT NOT NULL, `voteAverage` REAL NOT NULL, `voteCount` INTEGER NOT NULL, `width` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MovieVideos` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `movieId` INTEGER NOT NULL, `iso_639_1` TEXT NOT NULL, `iso_3166_1` TEXT NOT NULL, `name` TEXT NOT NULL, `key` TEXT NOT NULL, `site` TEXT NOT NULL, `size` INTEGER NOT NULL, `type` TEXT NOT NULL, `official` INTEGER NOT NULL, `publishedAt` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  GenresDao get genresDao {
    return _genresDaoInstance ??= _$GenresDao(database, changeListener);
  }

  @override
  MovieDataDao get movieDataDao {
    return _movieDataDaoInstance ??= _$MovieDataDao(database, changeListener);
  }

  @override
  MovieGenresDao get movieGenresDao {
    return _movieGenresDaoInstance ??=
        _$MovieGenresDao(database, changeListener);
  }

  @override
  MovieVideosDao get movieVideosDao {
    return _movieVideosDaoInstance ??=
        _$MovieVideosDao(database, changeListener);
  }

  @override
  MovieImagesDao get movieImagesDao {
    return _movieImagesDaoInstance ??=
        _$MovieImagesDao(database, changeListener);
  }
}

class _$GenresDao extends GenresDao {
  _$GenresDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _genresInsertionAdapter = InsertionAdapter(
            database,
            'Genres',
            (Genres item) =>
                <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Genres> _genresInsertionAdapter;

  @override
  Future<List<Genres>> findAllGenres() async {
    return _queryAdapter.queryList('SELECT * FROM Genres',
        mapper: (Map<String, Object?> row) =>
            Genres(row['id'] as int, row['name'] as String));
  }

  @override
  Future<Genres?> findGenreById(int id) async {
    return _queryAdapter.query('SELECT * FROM Genres WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Genres(row['id'] as int, row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertGenre(Genres data) async {
    await _genresInsertionAdapter.insert(data, OnConflictStrategy.abort);
  }
}

class _$MovieDataDao extends MovieDataDao {
  _$MovieDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _movieDataInsertionAdapter = InsertionAdapter(
            database,
            'MovieData',
            (MovieData item) => <String, Object?>{
                  'id': item.id,
                  'adult': item.adult ? 1 : 0,
                  'backdropPath': item.backdropPath,
                  'originalLanguage': item.originalLanguage,
                  'originalTitle': item.originalTitle,
                  'overview': item.overview,
                  'popularity': item.popularity,
                  'posterPath': item.posterPath,
                  'releaseDate': item.releaseDate,
                  'title': item.title,
                  'video': item.video ? 1 : 0,
                  'voteAverage': item.voteAverage,
                  'voteCount': item.voteCount
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MovieData> _movieDataInsertionAdapter;

  @override
  Future<List<MovieData>> findAllMovies() async {
    return _queryAdapter.queryList('SELECT * FROM MovieData',
        mapper: (Map<String, Object?> row) => MovieData(
            row['id'] as int,
            (row['adult'] as int) != 0,
            row['backdropPath'] as String,
            row['originalLanguage'] as String,
            row['originalTitle'] as String,
            row['overview'] as String,
            row['popularity'] as double,
            row['posterPath'] as String,
            row['releaseDate'] as String,
            row['title'] as String,
            (row['video'] as int) != 0,
            row['voteAverage'] as double,
            row['voteCount'] as int));
  }

  @override
  Future<List<MovieData>> searchMovies(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM MovieData WHERE title LIKE ?1',
        mapper: (Map<String, Object?> row) => MovieData(
            row['id'] as int,
            (row['adult'] as int) != 0,
            row['backdropPath'] as String,
            row['originalLanguage'] as String,
            row['originalTitle'] as String,
            row['overview'] as String,
            row['popularity'] as double,
            row['posterPath'] as String,
            row['releaseDate'] as String,
            row['title'] as String,
            (row['video'] as int) != 0,
            row['voteAverage'] as double,
            row['voteCount'] as int),
        arguments: [query]);
  }

  @override
  Future<List<MovieData>> searchMoviesByGenre(int genreId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM MovieData WHERE id IN (SELECT movieId FROM MovieGenres WHERE genreId=?1)',
        mapper: (Map<String, Object?> row) => MovieData(row['id'] as int, (row['adult'] as int) != 0, row['backdropPath'] as String, row['originalLanguage'] as String, row['originalTitle'] as String, row['overview'] as String, row['popularity'] as double, row['posterPath'] as String, row['releaseDate'] as String, row['title'] as String, (row['video'] as int) != 0, row['voteAverage'] as double, row['voteCount'] as int),
        arguments: [genreId]);
  }

  @override
  Future<MovieData?> findMovieById(int id) async {
    return _queryAdapter.query('SELECT * FROM MovieData WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MovieData(
            row['id'] as int,
            (row['adult'] as int) != 0,
            row['backdropPath'] as String,
            row['originalLanguage'] as String,
            row['originalTitle'] as String,
            row['overview'] as String,
            row['popularity'] as double,
            row['posterPath'] as String,
            row['releaseDate'] as String,
            row['title'] as String,
            (row['video'] as int) != 0,
            row['voteAverage'] as double,
            row['voteCount'] as int),
        arguments: [id]);
  }

  @override
  Future<int?> deleteAllRecords() async {
    return _queryAdapter.query('DELETE FROM MovieData',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertMovie(MovieData data) {
    return _movieDataInsertionAdapter.insertAndReturnId(
        data, OnConflictStrategy.abort);
  }
}

class _$MovieGenresDao extends MovieGenresDao {
  _$MovieGenresDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _movieGenresInsertionAdapter = InsertionAdapter(
            database,
            'MovieGenres',
            (MovieGenres item) => <String, Object?>{
                  'id': item.id,
                  'movieId': item.movieId,
                  'genreId': item.genreId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MovieGenres> _movieGenresInsertionAdapter;

  @override
  Future<List<MovieGenres>> findAllByMovie(int movieId) async {
    return _queryAdapter.queryList('SELECT * FROM MovieGenres WHERE movieId=?1',
        mapper: (Map<String, Object?> row) => MovieGenres(
            row['id'] as int?, row['movieId'] as int, row['genreId'] as int),
        arguments: [movieId]);
  }

  @override
  Future<List<MovieGenres>> findAllByGenre(int genreId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM MovieGenres WHERE genreId = ?1',
        mapper: (Map<String, Object?> row) => MovieGenres(
            row['id'] as int?, row['movieId'] as int, row['genreId'] as int),
        arguments: [genreId]);
  }

  @override
  Future<List<MovieGenres>> findUniqueGenres() async {
    return _queryAdapter.queryList('SELECT * FROM MovieGenres GROUP BY genreId',
        mapper: (Map<String, Object?> row) => MovieGenres(
            row['id'] as int?, row['movieId'] as int, row['genreId'] as int));
  }

  @override
  Future<int?> deleteByMovie(int movieId) async {
    return _queryAdapter.query('DELETE FROM MovieGenres WHERE movieId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [movieId]);
  }

  @override
  Future<void> insertGenre(MovieGenres data) async {
    await _movieGenresInsertionAdapter.insert(data, OnConflictStrategy.abort);
  }
}

class _$MovieVideosDao extends MovieVideosDao {
  _$MovieVideosDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _movieVideosInsertionAdapter = InsertionAdapter(
            database,
            'MovieVideos',
            (MovieVideos item) => <String, Object?>{
                  'id': item.id,
                  'movieId': item.movieId,
                  'iso_639_1': item.iso_639_1,
                  'iso_3166_1': item.iso_3166_1,
                  'name': item.name,
                  'key': item.key,
                  'site': item.site,
                  'size': item.size,
                  'type': item.type,
                  'official': item.official ? 1 : 0,
                  'publishedAt': item.publishedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MovieVideos> _movieVideosInsertionAdapter;

  @override
  Future<List<MovieVideos>> findAllByMovie(int movieId) async {
    return _queryAdapter.queryList('SELECT * FROM MovieVideos WHERE movieId=?1',
        mapper: (Map<String, Object?> row) => MovieVideos(
            row['id'] as int?,
            row['movieId'] as int,
            row['iso_639_1'] as String,
            row['iso_3166_1'] as String,
            row['name'] as String,
            row['key'] as String,
            row['site'] as String,
            row['size'] as int,
            row['type'] as String,
            (row['official'] as int) != 0,
            row['publishedAt'] as String),
        arguments: [movieId]);
  }

  @override
  Future<int?> deleteByMovie(int movieId) async {
    return _queryAdapter.query('DELETE FROM MovieVideos WHERE movieId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [movieId]);
  }

  @override
  Future<void> insertVideo(MovieVideos data) async {
    await _movieVideosInsertionAdapter.insert(data, OnConflictStrategy.abort);
  }
}

class _$MovieImagesDao extends MovieImagesDao {
  _$MovieImagesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _movieImagesInsertionAdapter = InsertionAdapter(
            database,
            'MovieImages',
            (MovieImages item) => <String, Object?>{
                  'id': item.id,
                  'movieId': item.movieId,
                  'imageType': item.imageType,
                  'aspectRatio': item.aspectRatio,
                  'height': item.height,
                  'iso_639_1': item.iso_639_1,
                  'filePath': item.filePath,
                  'voteAverage': item.voteAverage,
                  'voteCount': item.voteCount,
                  'width': item.width
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MovieImages> _movieImagesInsertionAdapter;

  @override
  Future<List<MovieImages>> findAllByMovie(int movieId) async {
    return _queryAdapter.queryList('SELECT * FROM MovieImages WHERE movieId=?1',
        mapper: (Map<String, Object?> row) => MovieImages(
            row['id'] as int?,
            row['movieId'] as int,
            row['imageType'] as String,
            row['aspectRatio'] as double,
            row['height'] as int,
            row['iso_639_1'] as String,
            row['filePath'] as String,
            row['voteAverage'] as double,
            row['voteCount'] as int,
            row['width'] as int),
        arguments: [movieId]);
  }

  @override
  Future<int?> deleteByMovie(int movieId) async {
    return _queryAdapter.query('DELETE FROM MovieImages WHERE movieId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [movieId]);
  }

  @override
  Future<void> insertImage(MovieImages data) async {
    await _movieImagesInsertionAdapter.insert(data, OnConflictStrategy.abort);
  }
}
