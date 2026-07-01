import '../models/series_model.dart';
import 'series_api_client.dart';

abstract interface class SeriesRemoteDataSource {
  Future<List<SeriesModel>> getPopularSeries();
  Future<List<SeriesModel>> getTopRatedSeries();
  Future<SeriesModel> getSeriesDetail(int id);
  Future<List<SeriesModel>> searchSeries(String query);
}

class SeriesRemoteDataSourceImpl implements SeriesRemoteDataSource {
  final SeriesApiClient _apiClient;

  const SeriesRemoteDataSourceImpl({required SeriesApiClient apiClient})
      : _apiClient = apiClient; // ignore: prefer_initializing_formals

  @override
  Future<List<SeriesModel>> getPopularSeries() async {
    final response = await _apiClient.getPopularSeries();
    return response.results;
  }

  @override
  Future<List<SeriesModel>> getTopRatedSeries() async {
    final response = await _apiClient.getTopRatedSeries();
    return response.results;
  }

  @override
  Future<SeriesModel> getSeriesDetail(int id) =>
      _apiClient.getSeriesDetail(id);

  @override
  Future<List<SeriesModel>> searchSeries(String query) async {
    final response = await _apiClient.searchSeries(query);
    return response.results;
  }
}
