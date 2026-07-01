import 'package:movie_test/core/usecase/usecase.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class GetPopularSeries implements UseCase<List<Series>, NoParams> {
  final SeriesRepository repository;

  const GetPopularSeries({required this.repository});

  @override
  Future<List<Series>> call(NoParams params) => repository.getPopularSeries();
}
