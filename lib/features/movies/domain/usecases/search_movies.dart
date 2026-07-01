import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import '../repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  const SearchMovies({required this.repository});

  Future<DataState<MovieListResponseModel>> call(
    String query, {
    int page = 1,
  }) => repository.searchMovies(query, page: page);
}
