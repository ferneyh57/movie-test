import 'package:dio/dio.dart';
import 'package:movie_test/core/error/failures.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'package:movie_test/features/series/domain/repositories/series_repository.dart';
import '../datasources/series_remote_datasource.dart';
import '../mappers/series_mapper.dart';

class SeriesRepositoryImpl implements SeriesRepository {
  final SeriesRemoteDataSource remoteDataSource;

  const SeriesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<List<Series>>> getPopularSeries({required int page}) => _execute(
        () async => (await remoteDataSource.getPopularSeries(page: page))
            .map(SeriesMapper.toEntity)
            .toList(),
      );

  @override
  Future<DataState<List<Series>>> getTopRatedSeries({required int page}) => _execute(
        () async => (await remoteDataSource.getTopRatedSeries(page: page))
            .map(SeriesMapper.toEntity)
            .toList(),
      );

  @override
  Future<DataState<Series>> getSeriesDetail(int id) => _execute(
        () async => SeriesMapper.toEntity(await remoteDataSource.getSeriesDetail(id)),
      );

  @override
  Future<DataState<List<Series>>> searchSeries(String query) => _execute(
        () async => (await remoteDataSource.searchSeries(query))
            .map(SeriesMapper.toEntity)
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
