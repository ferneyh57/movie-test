import 'package:movie_test/core/usecase/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovies implements UseCase<List<Movie>, String> {
  final MovieRepository repository;

  const SearchMovies({required this.repository});

  @override
  Future<List<Movie>> call(String query) => repository.searchMovies(query);
}
