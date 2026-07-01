import 'package:movie_test/core/usecase/usecase.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class GetSeriesDetail implements UseCase<Series, int> {
  final SeriesRepository repository;

  const GetSeriesDetail({required this.repository});

  @override
  Future<Series> call(int id) => repository.getSeriesDetail(id);
}
