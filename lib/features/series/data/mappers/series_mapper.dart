import 'package:movie_test/features/series/data/models/series_model.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';

abstract final class SeriesMapper {
  static Series toEntity(SeriesModel model) => Series(
    id: model.id,
    name: model.name,
    overview: model.overview,
    posterPath: model.posterPath,
    backdropPath: model.backdropPath,
    voteAverage: model.voteAverage,
    voteCount: model.voteCount,
    firstAirDate: model.firstAirDate,
    genreIds: model.genreIds,
  );
}
