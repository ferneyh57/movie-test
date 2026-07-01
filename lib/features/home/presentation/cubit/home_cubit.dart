import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_test/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'package:movie_test/features/series/domain/usecases/get_popular_series.dart';
import 'package:movie_test/features/series/domain/usecases/get_top_rated_series.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;
  final GetPopularSeries getPopularSeries;
  final GetTopRatedSeries getTopRatedSeries;

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

    final popularMoviesFuture = getPopularMovies(const NoParams());
    final topRatedMoviesFuture = getTopRatedMovies(const NoParams());
    final popularSeriesFuture = getPopularSeries(const NoParams());
    final topRatedSeriesFuture = getTopRatedSeries(const NoParams());

    final popularMovies = await popularMoviesFuture;
    final topRatedMovies = await topRatedMoviesFuture;
    final popularSeries = await popularSeriesFuture;
    final topRatedSeries = await topRatedSeriesFuture;

    emit(state.copyWith(
      isLoading: false,
      popularMovies: popularMovies is DataSuccess<List<Movie>> ? popularMovies.data : [],
      topRatedMovies: topRatedMovies is DataSuccess<List<Movie>> ? topRatedMovies.data : [],
      popularSeries: popularSeries is DataSuccess<List<Series>> ? popularSeries.data : [],
      topRatedSeries: topRatedSeries is DataSuccess<List<Series>> ? topRatedSeries.data : [],
    ));
  }
}
