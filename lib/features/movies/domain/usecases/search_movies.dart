import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovies implements UseCase<DataState<List<Movie>>, String> {
  final MovieRepository repository;

  const SearchMovies({required this.repository});

  @override
  Future<DataState<List<Movie>>> call(String query) =>
      repository.searchMovies(query);
}
