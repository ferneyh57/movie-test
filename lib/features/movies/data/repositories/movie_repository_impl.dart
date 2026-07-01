import 'package:dio/dio.dart';
import 'package:movie_test/core/error/failures.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/movies/domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_datasource.dart';
import '../mappers/movie_mapper.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  const MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<List<Movie>>> getPopularMovies({required int page}) => _execute(
        () async => (await remoteDataSource.getPopularMovies(page: page))
            .map(MovieMapper.toEntity)
            .toList(),
      );

  @override
  Future<DataState<List<Movie>>> getTopRatedMovies({required int page}) => _execute(
        () async => (await remoteDataSource.getTopRatedMovies(page: page))
            .map(MovieMapper.toEntity)
            .toList(),
      );

  @override
  Future<DataState<Movie>> getMovieDetail(int id) => _execute(
        () async => MovieMapper.toEntity(await remoteDataSource.getMovieDetail(id)),
      );

  @override
  Future<DataState<List<Movie>>> searchMovies(String query) => _execute(
        () async => (await remoteDataSource.searchMovies(query))
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
