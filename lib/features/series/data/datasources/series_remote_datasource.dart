import '../models/series_list_response_model.dart';
import '../models/series_model.dart';
import 'series_api_client.dart';

abstract interface class SeriesRemoteDataSource {
  Future<SeriesListResponseModel> getPopularSeries({required int page});
  Future<SeriesListResponseModel> getTopRatedSeries({required int page});
  Future<SeriesModel> getSeriesDetail(int id);
  Future<SeriesListResponseModel> searchSeries(String query, {int page = 1});
}

class SeriesRemoteDataSourceImpl implements SeriesRemoteDataSource {
  final SeriesApiClient apiClient;

  const SeriesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SeriesListResponseModel> getPopularSeries({required int page}) =>
      apiClient.getPopularSeries(page);

  @override
  Future<SeriesListResponseModel> getTopRatedSeries({required int page}) =>
      apiClient.getTopRatedSeries(page);

  @override
  Future<SeriesModel> getSeriesDetail(int id) => apiClient.getSeriesDetail(id);

  @override
  Future<SeriesListResponseModel> searchSeries(String query, {int page = 1}) =>
      apiClient.searchSeries(query, page: page);
}
