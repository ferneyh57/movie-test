import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import '../repositories/series_repository.dart';

class SearchSeries {
  final SeriesRepository repository;

  const SearchSeries({required this.repository});

  Future<DataState<SeriesListResponseModel>> call(
    String query, {
    int page = 1,
  }) => repository.searchSeries(query, page: page);
}
