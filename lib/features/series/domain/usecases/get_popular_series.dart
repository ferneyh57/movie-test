import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class GetPopularSeries implements UseCase<DataState<List<Series>>, int> {
  final SeriesRepository repository;

  const GetPopularSeries({required this.repository});

  @override
  Future<DataState<List<Series>>> call(int page) =>
      repository.getPopularSeries(page: page);
}
