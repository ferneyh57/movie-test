import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import 'package:movie_test/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movie_test/features/movies/presentation/cubit/movie_list_state.dart';

class TopRatedMoviesCubit extends Cubit<MovieListState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMoviesCubit({required GetTopRatedMovies getTopRatedMovies})
      : _getTopRatedMovies = getTopRatedMovies,
        super(const MovieListState(isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    final result = await _getTopRatedMovies();
    if (result is DataSuccess<MovieListResponseModel>) {
      emit(MovieListState(response: result.data));
    } else {
      emit(const MovieListState());
    }
  }

  Future<void> loadMore() async {
    final response = state.response;
    if (state.isLoading || !state.hasMore || response == null) return;
    emit(state.copyWith(isLoading: true));
    final result = await _getTopRatedMovies(response.page + 1);
    if (result is DataSuccess<MovieListResponseModel>) {
      emit(MovieListState(
        response: response.copyWith(
          results: [...response.results, ...result.data.results],
          page: result.data.page,
          totalPages: result.data.totalPages,
        ),
      ));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }
}
