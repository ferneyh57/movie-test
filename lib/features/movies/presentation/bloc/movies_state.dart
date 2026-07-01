import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';

part 'movies_state.freezed.dart';

@freezed
abstract class MoviesState with _$MoviesState {
  const factory MoviesState({
    @Default([]) List<Movie> movies,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _MoviesState;
}
