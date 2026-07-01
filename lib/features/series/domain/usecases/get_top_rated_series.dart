import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import '../repositories/series_repository.dart';

class GetTopRatedSeries {
  final SeriesRepository repository;

  const GetTopRatedSeries({required this.repository});

  Future<DataState<SeriesListResponseModel>> call([int page = 1]) =>
      repository.getTopRatedSeries(page: page);
}
