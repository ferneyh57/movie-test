import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_test/features/movies/data/mappers/movie_mapper.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';

part 'movie_list_state.freezed.dart';

@freezed
abstract class MovieListState with _$MovieListState {
  const MovieListState._();

  const factory MovieListState({
    MovieListResponseModel? response,
    @Default(false) bool isLoading,
  }) = _MovieListState;

  bool get hasMore {
    final r = response;
    return r != null && r.page < r.totalPages;
  }

  List<Movie> get movies =>
      response?.results.map(MovieMapper.toEntity).toList() ?? [];
}
