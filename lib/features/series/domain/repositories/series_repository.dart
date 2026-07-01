import '../entities/series.dart';

abstract interface class SeriesRepository {
  Future<List<Series>> getPopularSeries();
  Future<List<Series>> getTopRatedSeries();
  Future<Series> getSeriesDetail(int id);
  Future<List<Series>> searchSeries(String query);
}
