import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<Movie> popularMovies,
    @Default([]) List<Movie> topRatedMovies,
    @Default([]) List<Series> popularSeries,
    @Default([]) List<Series> topRatedSeries,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMorePopularMovies,
    @Default(true) bool hasMoreTopRatedMovies,
    @Default(true) bool hasMorePopularSeries,
    @Default(true) bool hasMoreTopRatedSeries,
    String? errorMessage,
  }) = _HomeState;
}
