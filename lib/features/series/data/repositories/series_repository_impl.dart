import 'package:dio/dio.dart';
import 'package:movie_test/core/error/failures.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'package:movie_test/features/series/domain/repositories/series_repository.dart';
import '../datasources/series_remote_datasource.dart';
import '../mappers/series_mapper.dart';

class SeriesRepositoryImpl implements SeriesRepository {
  final SeriesRemoteDataSource _remoteDataSource;

  const SeriesRepositoryImpl({required SeriesRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Series>> getPopularSeries() => _execute(
        () async => (await _remoteDataSource.getPopularSeries())
            .map(SeriesMapper.toEntity)
            .toList(),
      );

  @override
  Future<List<Series>> getTopRatedSeries() => _execute(
        () async => (await _remoteDataSource.getTopRatedSeries())
            .map(SeriesMapper.toEntity)
            .toList(),
      );

  @override
  Future<Series> getSeriesDetail(int id) => _execute(
        () async => SeriesMapper.toEntity(
          await _remoteDataSource.getSeriesDetail(id),
        ),
      );

  @override
  Future<List<Series>> searchSeries(String query) => _execute(
        () async => (await _remoteDataSource.searchSeries(query))
            .map(SeriesMapper.toEntity)
            .toList(),
      );

  Future<T> _execute<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (e) {
      throw NetworkFailure(e.message ?? 'Network error');
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}
