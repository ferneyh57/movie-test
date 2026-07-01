import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_test/features/movies/domain/usecases/search_movies.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'package:movie_test/features/series/domain/usecases/get_popular_series.dart';
import 'package:movie_test/features/series/domain/usecases/search_series.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GetPopularMovies getPopularMovies;
  final GetPopularSeries getPopularSeries;
  final SearchMovies searchMovies;
  final SearchSeries searchSeries;

  SearchCubit({
    required this.getPopularMovies,
    required this.getPopularSeries,
    required this.searchMovies,
    required this.searchSeries,
  }) : super(const SearchState()) {
    _loadPopular();
  }

  Future<void> _loadPopular() async {
    emit(state.copyWith(isLoading: true));
    final moviesResult = await getPopularMovies(const NoParams());
    final seriesResult = await getPopularSeries(const NoParams());
    emit(state.copyWith(
      isLoading: false,
      movies: moviesResult is DataSuccess<List<Movie>> ? moviesResult.data : [],
      series: seriesResult is DataSuccess<List<Series>> ? seriesResult.data : [],
    ));
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      await _loadPopular();
      return;
    }
    emit(state.copyWith(isLoading: true, query: query, errorMessage: null));

    final moviesResult = await searchMovies(query);
    final seriesResult = await searchSeries(query);

    final movies = moviesResult is DataSuccess<List<Movie>> ? moviesResult.data : <Movie>[];
    final series = seriesResult is DataSuccess<List<Series>> ? seriesResult.data : <Series>[];

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
