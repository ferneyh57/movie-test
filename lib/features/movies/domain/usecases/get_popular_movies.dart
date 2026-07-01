import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import '../repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  const GetPopularMovies({required this.repository});

  Future<DataState<MovieListResponseModel>> call([int page = 1]) =>
      repository.getPopularMovies(page: page);
}
