import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_test/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'package:movie_test/features/series/domain/usecases/get_popular_series.dart';
import 'package:movie_test/features/series/domain/usecases/get_top_rated_series.dart';
import 'home_state.dart';

enum HomeCategory { popularMovies, topRatedMovies, popularSeries, topRatedSeries }

class HomeCubit extends Cubit<HomeState> {
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;
  final GetPopularSeries getPopularSeries;
  final GetTopRatedSeries getTopRatedSeries;

  int _popularMoviesPage = 1;
  int _topRatedMoviesPage = 1;
  int _popularSeriesPage = 1;
  int _topRatedSeriesPage = 1;

  HomeCubit({
    required this.getPopularMovies,
    required this.getTopRatedMovies,
    required this.getPopularSeries,
    required this.getTopRatedSeries,
  }) : super(const HomeState()) {
    load();
  }

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));

    final r1 = getPopularMovies(1);
    final r2 = getTopRatedMovies(1);
    final r3 = getPopularSeries(1);
    final r4 = getTopRatedSeries(1);

    final popularMovies = await r1;
    final topRatedMovies = await r2;
    final popularSeries = await r3;
    final topRatedSeries = await r4;

    _popularMoviesPage = 1;
    _topRatedMoviesPage = 1;
    _popularSeriesPage = 1;
    _topRatedSeriesPage = 1;

    emit(state.copyWith(
      isLoading: false,
      popularMovies: popularMovies is DataSuccess<List<Movie>> ? popularMovies.data : [],
      topRatedMovies: topRatedMovies is DataSuccess<List<Movie>> ? topRatedMovies.data : [],
      popularSeries: popularSeries is DataSuccess<List<Series>> ? popularSeries.data : [],
      topRatedSeries: topRatedSeries is DataSuccess<List<Series>> ? topRatedSeries.data : [],
      hasMorePopularMovies: true,
      hasMoreTopRatedMovies: true,
      hasMorePopularSeries: true,
      hasMoreTopRatedSeries: true,
    ));
  }

  Future<void> loadMore(HomeCategory category) async {
    if (state.isLoadingMore) return;
    if (!_hasMore(category)) return;

    emit(state.copyWith(isLoadingMore: true));

    switch (category) {
      case HomeCategory.popularMovies:
        final result = await getPopularMovies(_popularMoviesPage + 1);
        if (result is DataSuccess<List<Movie>>) {
          _popularMoviesPage++;
          emit(state.copyWith(
            isLoadingMore: false,
            popularMovies: [...state.popularMovies, ...result.data],
            hasMorePopularMovies: result.data.isNotEmpty,
          ));
        } else {
          emit(state.copyWith(isLoadingMore: false));
        }
      case HomeCategory.topRatedMovies:
        final result = await getTopRatedMovies(_topRatedMoviesPage + 1);
        if (result is DataSuccess<List<Movie>>) {
          _topRatedMoviesPage++;
          emit(state.copyWith(
            isLoadingMore: false,
            topRatedMovies: [...state.topRatedMovies, ...result.data],
            hasMoreTopRatedMovies: result.data.isNotEmpty,
          ));
        } else {
          emit(state.copyWith(isLoadingMore: false));
        }
      case HomeCategory.popularSeries:
        final result = await getPopularSeries(_popularSeriesPage + 1);
        if (result is DataSuccess<List<Series>>) {
          _popularSeriesPage++;
          emit(state.copyWith(
            isLoadingMore: false,
            popularSeries: [...state.popularSeries, ...result.data],
            hasMorePopularSeries: result.data.isNotEmpty,
          ));
        } else {
          emit(state.copyWith(isLoadingMore: false));
        }
      case HomeCategory.topRatedSeries:
        final result = await getTopRatedSeries(_topRatedSeriesPage + 1);
        if (result is DataSuccess<List<Series>>) {
          _topRatedSeriesPage++;
          emit(state.copyWith(
            isLoadingMore: false,
            topRatedSeries: [...state.topRatedSeries, ...result.data],
            hasMoreTopRatedSeries: result.data.isNotEmpty,
          ));
        } else {
          emit(state.copyWith(isLoadingMore: false));
        }
    }
  }

  bool _hasMore(HomeCategory category) => switch (category) {
        HomeCategory.popularMovies => state.hasMorePopularMovies,
        HomeCategory.topRatedMovies => state.hasMoreTopRatedMovies,
        HomeCategory.popularSeries => state.hasMorePopularSeries,
        HomeCategory.topRatedSeries => state.hasMoreTopRatedSeries,
      };
}
