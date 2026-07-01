import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';

part 'movie_model.freezed.dart';
part 'movie_model.g.dart';

@freezed
abstract class MovieModel with _$MovieModel {
  const factory MovieModel({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
  }) = _MovieModel;

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);
}

extension MovieModelX on MovieModel {
  Movie toEntity() => Movie(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
      );
}
