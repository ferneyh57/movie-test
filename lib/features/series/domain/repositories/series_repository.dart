import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import '../entities/series.dart';

abstract interface class SeriesRepository {
  Future<DataState<SeriesListResponseModel>> getPopularSeries({required int page});
  Future<DataState<SeriesListResponseModel>> getTopRatedSeries({required int page});
  Future<DataState<Series>> getSeriesDetail(int id);
  Future<DataState<SeriesListResponseModel>> searchSeries(String query, {int page = 1});
}
