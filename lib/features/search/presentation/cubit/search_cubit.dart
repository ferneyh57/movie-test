import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import 'package:movie_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_test/features/movies/domain/usecases/search_movies.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import 'package:movie_test/features/series/domain/usecases/get_popular_series.dart';
import 'package:movie_test/features/series/domain/usecases/search_series.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GetPopularMovies _getPopularMovies;
  final GetPopularSeries _getPopularSeries;
  final SearchMovies _searchMovies;
  final SearchSeries _searchSeries;

  SearchCubit({
    required GetPopularMovies getPopularMovies,
    required GetPopularSeries getPopularSeries,
    required SearchMovies searchMovies,
    required SearchSeries searchSeries,
  })  : _getPopularMovies = getPopularMovies,
        _getPopularSeries = getPopularSeries,
        _searchMovies = searchMovies,
        _searchSeries = searchSeries,
        super(const SearchState(isLoading: true)) {
    _loadPopular();
  }

  Future<void> _loadPopular() async {
    final moviesResult = await _getPopularMovies();
    final seriesResult = await _getPopularSeries();
    emit(state.copyWith(
      isLoading: false,
      moviesResponse: moviesResult is DataSuccess<MovieListResponseModel>
          ? moviesResult.data
          : null,
      seriesResponse: seriesResult is DataSuccess<SeriesListResponseModel>
          ? seriesResult.data
          : null,
    ));
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(const SearchState(isLoading: true));
      await _loadPopular();
      return;
    }
    emit(state.copyWith(isLoading: true, query: query, errorMessage: null));
    final moviesResult = await _searchMovies(query);
    final seriesResult = await _searchSeries(query);
    emit(state.copyWith(
      isLoading: false,
      moviesResponse: moviesResult is DataSuccess<MovieListResponseModel>
          ? moviesResult.data
          : null,
      seriesResponse: seriesResult is DataSuccess<SeriesListResponseModel>
          ? seriesResult.data
          : null,
      errorMessage: moviesResult is DataFailure<MovieListResponseModel>
          ? moviesResult.failure.message
          : null,
    ));
  }

  Future<void> loadMoreMovies() async {
    final moviesResponse = state.moviesResponse;
    if (state.isLoading || !state.hasMoreMovies || moviesResponse == null) return;
    final query = state.query;
    final result = query.isEmpty
        ? await _getPopularMovies(moviesResponse.page + 1)
        : await _searchMovies(query, page: moviesResponse.page + 1);
    if (result is DataSuccess<MovieListResponseModel>) {
      final existingIds = moviesResponse.results.map((m) => m.id).toSet();
      emit(state.copyWith(
        moviesResponse: moviesResponse.copyWith(
          results: [
            ...moviesResponse.results,
            ...result.data.results.where((m) => !existingIds.contains(m.id)),
          ],
          page: result.data.page,
          totalPages: result.data.totalPages,
        ),
      ));
    }
  }

  Future<void> loadMoreSeries() async {
    final seriesResponse = state.seriesResponse;
    if (state.isLoading || !state.hasMoreSeries || seriesResponse == null) return;
    final query = state.query;
    final result = query.isEmpty
        ? await _getPopularSeries(seriesResponse.page + 1)
        : await _searchSeries(query, page: seriesResponse.page + 1);
    if (result is DataSuccess<SeriesListResponseModel>) {
      final existingIds = seriesResponse.results.map((s) => s.id).toSet();
      emit(state.copyWith(
        seriesResponse: seriesResponse.copyWith(
          results: [
            ...seriesResponse.results,
            ...result.data.results.where((s) => !existingIds.contains(s.id)),
          ],
          page: result.data.page,
          totalPages: result.data.totalPages,
        ),
      ));
    }
  }
}
