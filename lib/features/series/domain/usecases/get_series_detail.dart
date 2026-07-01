import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class GetSeriesDetail implements UseCase<DataState<Series>, int> {
  final SeriesRepository repository;

  const GetSeriesDetail({required this.repository});

  @override
  Future<DataState<Series>> call(int id) => repository.getSeriesDetail(id);
}
