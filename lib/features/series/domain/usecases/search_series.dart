import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class SearchSeries implements UseCase<DataState<List<Series>>, String> {
  final SeriesRepository repository;

  const SearchSeries({required this.repository});

  @override
  Future<DataState<List<Series>>> call(String query) =>
      repository.searchSeries(query);
}
