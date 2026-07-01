import 'package:dio/dio.dart';
import 'package:movie_test/core/error/failures.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/movies/domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_datasource.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;

  const MovieRepositoryImpl({required MovieRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Movie>> getPopularMovies() async {
    try {
      final models = await _remoteDataSource.getPopularMovies();
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw NetworkFailure(e.message ?? 'Network error');
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<Movie> getMovieDetail(int id) async {
    try {
      final model = await _remoteDataSource.getMovieDetail(id);
      return model.toEntity();
    } on DioException catch (e) {
      throw NetworkFailure(e.message ?? 'Network error');
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}
