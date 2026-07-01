import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';

part 'search_state.freezed.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default([]) List<Movie> movies,
    @Default([]) List<Series> series,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default('') String query,
  }) = _SearchState;
}
