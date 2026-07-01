import 'package:movie_test/core/usecase/usecase.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class SearchSeries implements UseCase<List<Series>, String> {
  final SeriesRepository repository;

  const SearchSeries({required this.repository});

  @override
  Future<List<Series>> call(String query) => repository.searchSeries(query);
}
