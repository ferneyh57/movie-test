import 'package:dio/dio.dart';
import 'package:movie_test/core/error/failures.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'package:movie_test/features/series/domain/repositories/series_repository.dart';
import '../datasources/series_remote_datasource.dart';
import '../mappers/series_mapper.dart';

class SeriesRepositoryImpl implements SeriesRepository {
  final SeriesRemoteDataSource remoteDataSource;

  const SeriesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<SeriesListResponseModel>> getPopularSeries({required int page}) =>
      _execute(() => remoteDataSource.getPopularSeries(page: page));

  @override
  Future<DataState<SeriesListResponseModel>> getTopRatedSeries({required int page}) =>
      _execute(() => remoteDataSource.getTopRatedSeries(page: page));

  @override
  Future<DataState<Series>> getSeriesDetail(int id) => _execute(
        () async => SeriesMapper.toEntity(await remoteDataSource.getSeriesDetail(id)),
      );

  @override
  Future<DataState<SeriesListResponseModel>> searchSeries(String query, {int page = 1}) =>
      _execute(() => remoteDataSource.searchSeries(query, page: page));

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
