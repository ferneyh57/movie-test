import 'package:movie_test/core/usecase/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetPopularMovies implements UseCase<List<Movie>, NoParams> {
  final MovieRepository repository;

  const GetPopularMovies({required this.repository});

  @override
  Future<List<Movie>> call(NoParams params) => repository.getPopularMovies();
}
