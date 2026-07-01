import '../models/series_model.dart';
import 'series_api_client.dart';

abstract interface class SeriesRemoteDataSource {
  Future<List<SeriesModel>> getPopularSeries();
  Future<List<SeriesModel>> getTopRatedSeries();
  Future<SeriesModel> getSeriesDetail(int id);
  Future<List<SeriesModel>> searchSeries(String query);
}

class SeriesRemoteDataSourceImpl implements SeriesRemoteDataSource {
  final SeriesApiClient apiClient;

  const SeriesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SeriesModel>> getPopularSeries() async {
    final response = await apiClient.getPopularSeries();
    return response.results;
  }

  @override
  Future<List<SeriesModel>> getTopRatedSeries() async {
    final response = await apiClient.getTopRatedSeries();
    return response.results;
  }

  @override
  Future<SeriesModel> getSeriesDetail(int id) =>
      apiClient.getSeriesDetail(id);

  @override
  Future<List<SeriesModel>> searchSeries(String query) async {
    final response = await apiClient.searchSeries(query);
    return response.results;
  }
}
