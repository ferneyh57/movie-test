import 'package:dio/dio.dart';
import 'package:movie_test/core/error/failures.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/movies/domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_datasource.dart';
import '../mappers/movie_mapper.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  const MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<MovieListResponseModel>> getPopularMovies({required int page}) =>
      _execute(() => remoteDataSource.getPopularMovies(page: page));

  @override
  Future<DataState<MovieListResponseModel>> getTopRatedMovies({required int page}) =>
      _execute(() => remoteDataSource.getTopRatedMovies(page: page));

  @override
  Future<DataState<Movie>> getMovieDetail(int id) => _execute(
        () async => MovieMapper.toEntity(await remoteDataSource.getMovieDetail(id)),
      );

  @override
  Future<DataState<MovieListResponseModel>> searchMovies(String query, {int page = 1}) =>
      _execute(() => remoteDataSource.searchMovies(query, page: page));

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
