import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/home/presentation/cubit/popular_movies_cubit.dart';
import 'package:movie_test/features/home/presentation/cubit/popular_series_cubit.dart';
import 'package:movie_test/features/home/presentation/cubit/top_rated_movies_cubit.dart';
import 'package:movie_test/features/home/presentation/cubit/top_rated_series_cubit.dart';
import 'package:movie_test/features/home/presentation/pages/home_page.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import 'package:movie_test/features/movies/data/models/movie_model.dart';
import 'package:movie_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_test/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import 'package:movie_test/features/series/data/models/series_model.dart';
import 'package:movie_test/features/series/domain/usecases/get_popular_series.dart';
import 'package:movie_test/features/series/domain/usecases/get_top_rated_series.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

class MockGetPopularSeries extends Mock implements GetPopularSeries {}

class MockGetTopRatedSeries extends Mock implements GetTopRatedSeries {}

MovieModel _movieModel({int id = 1}) => MovieModel(
  id: id,
  title: 'Movie $id',
  overview: 'Overview',
  voteAverage: 7.5,
);

SeriesModel _seriesModel({int id = 1}) => SeriesModel(
  id: id,
  name: 'Series $id',
  overview: 'Overview',
  voteAverage: 7.5,
);

MovieListResponseModel _moviePage(
  List<MovieModel> results, {
  int totalPages = 5,
}) => MovieListResponseModel(
  results: results,
  page: 1,
  totalPages: totalPages,
  totalResults: results.length,
);

SeriesListResponseModel _seriesPage(List<SeriesModel> results) =>
    SeriesListResponseModel(
      results: results,
      page: 1,
      totalPages: 1,
      totalResults: results.length,
    );

void main() {
  final sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(0);
  });

  setUp(() {
    sl.reset();
    sl.allowReassignment = true;
  });

  void registerCubits({
    required List<MovieModel> movies,
    required List<SeriesModel> series,
  }) {
    final popularMovies = MockGetPopularMovies();
    final topRatedMovies = MockGetTopRatedMovies();
    final popularSeries = MockGetPopularSeries();
    final topRatedSeries = MockGetTopRatedSeries();

    when(
      () => popularMovies(),
    ).thenAnswer((_) async => DataSuccess(_moviePage(movies)));
    when(
      () => popularMovies(any()),
    ).thenAnswer((_) async => DataSuccess(_moviePage(movies)));
    when(
      () => topRatedMovies(),
    ).thenAnswer((_) async => DataSuccess(_moviePage(movies)));
    when(
      () => topRatedMovies(any()),
    ).thenAnswer((_) async => DataSuccess(_moviePage(movies)));
    when(
      () => popularSeries(),
    ).thenAnswer((_) async => DataSuccess(_seriesPage(series)));
    when(
      () => popularSeries(any()),
    ).thenAnswer((_) async => DataSuccess(_seriesPage(series)));
    when(
      () => topRatedSeries(),
    ).thenAnswer((_) async => DataSuccess(_seriesPage(series)));
    when(
      () => topRatedSeries(any()),
    ).thenAnswer((_) async => DataSuccess(_seriesPage(series)));

    sl.registerFactory(
      () => PopularMoviesCubit(getPopularMovies: popularMovies),
    );
    sl.registerFactory(
      () => TopRatedMoviesCubit(getTopRatedMovies: topRatedMovies),
    );
    sl.registerFactory(
      () => PopularSeriesCubit(getPopularSeries: popularSeries),
    );
    sl.registerFactory(
      () => TopRatedSeriesCubit(getTopRatedSeries: topRatedSeries),
    );
  }

  testWidgets('HomePage renders 4 carousel titles with single items', (
    tester,
  ) async {
    registerCubits(movies: [_movieModel(id: 1)], series: [_seriesModel(id: 1)]);
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    expect(find.text('Popular Movies'), findsWidgets);
    expect(find.text('Movie 1'), findsWidgets);
  });

  testWidgets('HomePage carousel scrolls horizontally revealing next items', (
    tester,
  ) async {
    final many = [for (var i = 1; i <= 20; i++) _movieModel(id: i)];
    registerCubits(movies: many, series: []);
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    expect(find.text('Movie 1'), findsWidgets);
    expect(find.text('Movie 20'), findsNothing);

    final carouselFinder = find.byElementPredicate((element) {
      final widget = element.widget;
      return widget is Scrollable &&
          (widget.axisDirection == AxisDirection.left ||
              widget.axisDirection == AxisDirection.right);
    });

    for (var i = 0; i < 10 && find.text('Movie 20').evaluate().isEmpty; i++) {
      await tester.drag(carouselFinder.at(0), const Offset(-600, 0));
      await tester.pumpAndSettle();
    }

    expect(find.text('Movie 20'), findsWidgets);
  });
}
