import 'package:movie_test/core/usecase/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetail implements UseCase<Movie, int> {
  final MovieRepository repository;

  const GetMovieDetail({required this.repository});

  @override
  Future<Movie> call(int id) => repository.getMovieDetail(id);
}
