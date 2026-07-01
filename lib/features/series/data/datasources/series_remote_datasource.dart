import '../models/series_model.dart';
import 'series_api_client.dart';

abstract interface class SeriesRemoteDataSource {
  Future<List<SeriesModel>> getPopularSeries({required int page});
  Future<List<SeriesModel>> getTopRatedSeries({required int page});
  Future<SeriesModel> getSeriesDetail(int id);
  Future<List<SeriesModel>> searchSeries(String query);
}

class SeriesRemoteDataSourceImpl implements SeriesRemoteDataSource {
  final SeriesApiClient apiClient;

  const SeriesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SeriesModel>> getPopularSeries({required int page}) async {
    final response = await apiClient.getPopularSeries(page);
    return response.results;
  }

  @override
  Future<List<SeriesModel>> getTopRatedSeries({required int page}) async {
    final response = await apiClient.getTopRatedSeries(page);
    return response.results;
  }

  @override
  Future<SeriesModel> getSeriesDetail(int id) => apiClient.getSeriesDetail(id);

  @override
  Future<List<SeriesModel>> searchSeries(String query) async {
    final response = await apiClient.searchSeries(query);
    return response.results;
  }
}
