import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import 'package:movie_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_test/features/movies/presentation/cubit/movie_list_state.dart';

class PopularMoviesCubit extends Cubit<MovieListState> {
  final GetPopularMovies _getPopularMovies;

  PopularMoviesCubit({required GetPopularMovies getPopularMovies})
      : _getPopularMovies = getPopularMovies,
        super(const MovieListState(isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    final result = await _getPopularMovies();
    if (result is DataSuccess<MovieListResponseModel>) {
      emit(MovieListState(response: result.data));
    } else {
      emit(const MovieListState());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    emit(MovieListState(response: state.response, isLoading: true));
    final result = await _getPopularMovies(state.response!.page + 1);
    if (result is DataSuccess<MovieListResponseModel>) {
      emit(MovieListState(
        response: state.response!.copyWith(
          results: [...state.response!.results, ...result.data.results],
          page: result.data.page,
          totalPages: result.data.totalPages,
        ),
      ));
    } else {
      emit(MovieListState(response: state.response));
    }
  }
}
