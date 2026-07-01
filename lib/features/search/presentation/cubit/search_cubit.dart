import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/movies/domain/usecases/search_movies.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'package:movie_test/features/series/domain/usecases/search_series.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchMovies _searchMovies;
  final SearchSeries _searchSeries;

  // ignore: prefer_initializing_formals
  SearchCubit({
    required SearchMovies searchMovies,
    required SearchSeries searchSeries,
  })  : _searchMovies = searchMovies, // ignore: prefer_initializing_formals
        _searchSeries = searchSeries, // ignore: prefer_initializing_formals
        super(const SearchState());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(const SearchState());
      return;
    }
    emit(state.copyWith(isLoading: true, query: query, errorMessage: null));

    final moviesResult = await _searchMovies(query);
    final seriesResult = await _searchSeries(query);

    final movies = moviesResult is DataSuccess<List<Movie>>
        ? moviesResult.data
        : <Movie>[];
    final series = seriesResult is DataSuccess<List<Series>>
        ? seriesResult.data
        : <Series>[];

    String? errorMessage;
    if (moviesResult is DataFailure<List<Movie>>) {
      errorMessage = moviesResult.failure.message;
    } else if (seriesResult is DataFailure<List<Series>>) {
      errorMessage = seriesResult.failure.message;
    }

    emit(state.copyWith(
      isLoading: false,
      movies: movies,
      series: series,
      errorMessage: errorMessage,
    ));
  }
}
