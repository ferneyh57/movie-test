import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_test/features/movies/data/mappers/movie_mapper.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/series/data/mappers/series_mapper.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';

part 'search_state.freezed.dart';

@freezed
abstract class SearchState with _$SearchState {
  const SearchState._();

  const factory SearchState({
    MovieListResponseModel? moviesResponse,
    SeriesListResponseModel? seriesResponse,
    @Default(false) bool isLoading,
    @Default('') String query,
    String? errorMessage,
  }) = _SearchState;

  bool get hasMoreMovies {
    final r = moviesResponse;
    return r != null && r.page < r.totalPages;
  }

  bool get hasMoreSeries {
    final r = seriesResponse;
    return r != null && r.page < r.totalPages;
  }

  List<Movie> get movies =>
      moviesResponse?.results.map(MovieMapper.toEntity).toList() ?? [];

  List<Series> get series =>
      seriesResponse?.results.map(SeriesMapper.toEntity).toList() ?? [];
}
