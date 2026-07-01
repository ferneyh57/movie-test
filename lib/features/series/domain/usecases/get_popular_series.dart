import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import '../repositories/series_repository.dart';

class GetPopularSeries {
  final SeriesRepository repository;

  const GetPopularSeries({required this.repository});

  Future<DataState<SeriesListResponseModel>> call([int page = 1]) =>
      repository.getPopularSeries(page: page);
}
