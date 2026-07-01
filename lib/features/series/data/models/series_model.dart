import 'package:freezed_annotation/freezed_annotation.dart';

part 'series_model.freezed.dart';
part 'series_model.g.dart';

@freezed
abstract class SeriesModel with _$SeriesModel {
  const factory SeriesModel({
    required int id,
    required String name,
    required String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'vote_count') int? voteCount,
    @JsonKey(name: 'first_air_date') String? firstAirDate,
    @JsonKey(name: 'genre_ids') List<int>? genreIds,
  }) = _SeriesModel;

  factory SeriesModel.fromJson(Map<String, dynamic> json) =>
      _$SeriesModelFromJson(json);
}
