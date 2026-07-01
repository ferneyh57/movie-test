import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_test/core/error/failures.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import 'package:movie_test/features/movies/data/models/movie_model.dart';
import 'package:movie_test/features/movies/data/repositories/movie_repository_impl.dart';

// Note: the repository returns MovieListResponseModel (data-layer DTO) for
// list/search endpoints — it does NOT map to PagedResult<Movie>. This
// matches the existing architecture; mapping to entities happens in the
// presentation state getters.

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}

MovieModel _movieModel({int id = 1}) => MovieModel(
  id: id,
  title: 'Movie $id',
  overview: 'Overview',
  voteAverage: 7.5,
);

MovieListResponseModel _moviePage(
  List<MovieModel> results, {
  int page = 1,
  int totalPages = 3,
}) => MovieListResponseModel(
  results: results,
  page: page,
  totalPages: totalPages,
  totalResults: results.length,
);

void main() {
  late MockMovieRemoteDataSource remote;
  late MovieRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(0);
  });

  setUp(() {
    remote = MockMovieRemoteDataSource();
    repository = MovieRepositoryImpl(remoteDataSource: remote);
  });

  group('MovieRepositoryImpl', () {
    group('getPopularMovies', () {
      test(
        'returns DataSuccess<MovieListResponseModel> with results',
        () async {
          when(
            () => remote.getPopularMovies(page: any(named: 'page')),
          ).thenAnswer((_) async => _moviePage([_movieModel(id: 1)]));

          final result = await repository.getPopularMovies(page: 1);

          expect(result, isA<DataSuccess>());
          final data = (result as DataSuccess).data;
          expect(data.results.length, 1);
          expect(data.results.first.id, 1);
          expect(data.page, 1);
          expect(data.totalPages, 3);
        },
      );

      test('returns DataFailure<NetworkFailure> on DioException', () async {
        when(() => remote.getPopularMovies(page: any(named: 'page'))).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/movie/popular'),
            type: DioExceptionType.connectionError,
            message: 'no network',
          ),
        );

        final result = await repository.getPopularMovies(page: 1);

        expect(result, isA<DataFailure>());
        expect((result as DataFailure).failure, isA<NetworkFailure>());
      });

      test('returns DataFailure<UnknownFailure> on unexpected error', () async {
        when(
          () => remote.getPopularMovies(page: any(named: 'page')),
        ).thenThrow(Exception('boom'));

        final result = await repository.getPopularMovies(page: 1);

        expect(result, isA<DataFailure>());
        expect((result as DataFailure).failure, isA<UnknownFailure>());
      });
    });

    group('getMovieDetail', () {
      test('returns DataSuccess<Movie> mapped from model', () async {
        when(
          () => remote.getMovieDetail(42),
        ).thenAnswer((_) async => _movieModel(id: 42));

        final result = await repository.getMovieDetail(42);

        expect(result, isA<DataSuccess>());
        expect((result as DataSuccess).data.id, 42);
      });

      test('returns DataFailure on DioException', () async {
        when(() => remote.getMovieDetail(99)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/movie/99'),
            type: DioExceptionType.connectionTimeout,
            message: 'timeout',
          ),
        );

        final result = await repository.getMovieDetail(99);

        expect(result, isA<DataFailure>());
      });
    });

    group('searchMovies', () {
      test('returns DataSuccess<MovieListResponseModel>', () async {
        when(
          () => remote.searchMovies('bat', page: any(named: 'page')),
        ).thenAnswer((_) async => _moviePage([_movieModel(id: 7)]));

        final result = await repository.searchMovies('bat', page: 1);

        expect(result, isA<DataSuccess>());
        expect((result as DataSuccess).data.results.first.id, 7);
      });
    });

    group('getTopRatedMovies', () {
      test('returns DataSuccess<MovieListResponseModel>', () async {
        when(
          () => remote.getTopRatedMovies(page: any(named: 'page')),
        ).thenAnswer((_) async => _moviePage([_movieModel(id: 3)]));

        final result = await repository.getTopRatedMovies(page: 1);

        expect(result, isA<DataSuccess>());
        expect((result as DataSuccess).data.results.first.id, 3);
      });
    });
  });
}
