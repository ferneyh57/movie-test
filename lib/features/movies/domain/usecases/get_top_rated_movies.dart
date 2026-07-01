import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetTopRatedMovies implements UseCase<DataState<List<Movie>>, NoParams> {
  final MovieRepository repository;

  const GetTopRatedMovies({required this.repository});

  @override
  Future<DataState<List<Movie>>> call(NoParams params) =>
      repository.getTopRatedMovies();
}
