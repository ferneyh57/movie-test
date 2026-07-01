import 'package:dio/dio.dart';
import 'package:movie_test/core/error/failures.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/movies/domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_datasource.dart';
import '../mappers/movie_mapper.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;

  const MovieRepositoryImpl({required MovieRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource; // ignore: prefer_initializing_formals

  @override
  Future<DataState<List<Movie>>> getPopularMovies() => _execute(
        () async => (await _remoteDataSource.getPopularMovies())
            .map(MovieMapper.toEntity)
            .toList(),
      );

  @override
  Future<DataState<List<Movie>>> getTopRatedMovies() => _execute(
        () async => (await _remoteDataSource.getTopRatedMovies())
            .map(MovieMapper.toEntity)
            .toList(),
      );

  @override
  Future<DataState<Movie>> getMovieDetail(int id) => _execute(
        () async =>
            MovieMapper.toEntity(await _remoteDataSource.getMovieDetail(id)),
      );

  @override
  Future<DataState<List<Movie>>> searchMovies(String query) => _execute(
        () async => (await _remoteDataSource.searchMovies(query))
            .map(MovieMapper.toEntity)
            .toList(),
      );

  Future<DataState<T>> _execute<T>(Future<T> Function() action) async {
    try {
      return DataSuccess(await action());
    } on DioException catch (e) {
      return DataFailure(NetworkFailure(e.message ?? 'Network error'));
    } catch (_) {
      return const DataFailure(UnknownFailure());
    }
  }
}
