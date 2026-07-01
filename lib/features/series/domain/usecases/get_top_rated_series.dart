import 'package:movie_test/core/usecase/usecase.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class GetTopRatedSeries implements UseCase<List<Series>, NoParams> {
  final SeriesRepository repository;

  const GetTopRatedSeries({required this.repository});

  @override
  Future<List<Series>> call(NoParams params) => repository.getTopRatedSeries();
}
