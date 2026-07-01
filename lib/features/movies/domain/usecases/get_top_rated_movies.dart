import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import '../repositories/movie_repository.dart';

class GetTopRatedMovies {
  final MovieRepository repository;

  const GetTopRatedMovies({required this.repository});

  Future<DataState<MovieListResponseModel>> call([int page = 1]) =>
      repository.getTopRatedMovies(page: page);
}
