import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';

part 'movie_detail_state.freezed.dart';

@freezed
abstract class MovieDetailState with _$MovieDetailState {
  const factory MovieDetailState({
    Movie? movie,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _MovieDetailState;
}
