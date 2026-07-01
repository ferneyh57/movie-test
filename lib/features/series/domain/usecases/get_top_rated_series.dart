import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class GetTopRatedSeries implements UseCase<DataState<List<Series>>, int> {
  final SeriesRepository repository;

  const GetTopRatedSeries({required this.repository});

  @override
  Future<DataState<List<Series>>> call(int page) =>
      repository.getTopRatedSeries(page: page);
}
