import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_test/core/error/failures.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/home/presentation/cubit/popular_movies_cubit.dart';
import 'package:movie_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_test/features/movies/presentation/cubit/movie_list_state.dart';

import '../../../helpers/mock_data.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

void main() {
  late MockGetPopularMovies mockUseCase;

  setUp(() => mockUseCase = MockGetPopularMovies());

  PopularMoviesCubit buildCubit() =>
      PopularMoviesCubit(getPopularMovies: mockUseCase);

  group('PopularMoviesCubit', () {
    group('initial load', () {
      blocTest<PopularMoviesCubit, MovieListState>(
        'emits loaded state on success',
        setUp: () {
          when(() => mockUseCase()).thenAnswer((_) async => DataSuccess(moviePage()));
        },
        build: buildCubit,
        expect: () => [MovieListState(response: moviePage())],
      );

      blocTest<PopularMoviesCubit, MovieListState>(
        'emits empty state on failure',
        setUp: () {
          when(() => mockUseCase()).thenAnswer(
            (_) async => const DataFailure(NetworkFailure('error')),
          );
        },
        build: buildCubit,
        expect: () => [const MovieListState()],
      );
    });

    group('loadMore', () {
      final page1 = moviePage(page: 1, totalPages: 2, results: [movieModel(id: 1)]);
      final page2 = moviePage(page: 2, totalPages: 2, results: [movieModel(id: 2)]);

      blocTest<PopularMoviesCubit, MovieListState>(
        'appends results and updates page',
        setUp: () {
          when(() => mockUseCase()).thenAnswer((_) async => DataSuccess(page1));
          when(() => mockUseCase(2)).thenAnswer((_) async => DataSuccess(page2));
        },
        build: buildCubit,
        act: (cubit) async {
          await Future<void>.delayed(Duration.zero); // let _load() complete
          await cubit.loadMore();
        },
        skip: 1,
        expect: () => [
          MovieListState(response: page1, isLoading: true),
          MovieListState(
            response: page1.copyWith(
              results: [...page1.results, ...page2.results],
              page: 2,
              totalPages: 2,
            ),
          ),
        ],
      );

      blocTest<PopularMoviesCubit, MovieListState>(
        'does nothing when on last page',
        setUp: () {
          when(() => mockUseCase())
              .thenAnswer((_) async => DataSuccess(moviePage(page: 3, totalPages: 3)));
        },
        build: buildCubit,
        act: (cubit) async {
          await Future<void>.delayed(Duration.zero);
          await cubit.loadMore();
        },
        skip: 1,
        expect: () => [],
      );

      blocTest<PopularMoviesCubit, MovieListState>(
        'ignores concurrent loadMore calls',
        setUp: () {
          when(() => mockUseCase()).thenAnswer((_) async => DataSuccess(page1));
          when(() => mockUseCase(2)).thenAnswer((_) async => DataSuccess(page2));
        },
        build: buildCubit,
        act: (cubit) async {
          await Future<void>.delayed(Duration.zero);
          final first = cubit.loadMore();
          cubit.loadMore(); // concurrent — blocked by isLoading: true
          await first;
        },
        skip: 1,
        verify: (_) => verify(() => mockUseCase(2)).called(1),
      );
    });
  });
}
