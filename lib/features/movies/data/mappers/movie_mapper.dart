import 'package:movie_test/features/movies/data/models/movie_model.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';

abstract final class MovieMapper {
  static Movie toEntity(MovieModel model) => Movie(
    id: model.id,
    title: model.title,
    overview: model.overview,
    posterPath: model.posterPath,
    backdropPath: model.backdropPath,
    voteAverage: model.voteAverage,
    voteCount: model.voteCount,
    releaseDate: model.releaseDate,
    genreIds: model.genreIds,
  );
}
