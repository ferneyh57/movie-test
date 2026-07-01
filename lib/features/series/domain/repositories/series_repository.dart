import 'package:movie_test/core/utils/data_state.dart';
import '../entities/series.dart';

abstract interface class SeriesRepository {
  Future<DataState<List<Series>>> getPopularSeries();
  Future<DataState<List<Series>>> getTopRatedSeries();
  Future<DataState<Series>> getSeriesDetail(int id);
  Future<DataState<List<Series>>> searchSeries(String query);
}
