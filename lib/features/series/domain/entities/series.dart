import 'package:freezed_annotation/freezed_annotation.dart';

part 'series.freezed.dart';

@freezed
abstract class Series with _$Series {
  const factory Series({
    required int id,
    required String name,
    required String overview,
    String? posterPath,
    String? backdropPath,
    required double voteAverage,
    int? voteCount,
    String? firstAirDate,
    List<int>? genreIds,
  }) = _Series;
}
