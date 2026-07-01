import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetail implements UseCase<DataState<Movie>, int> {
  final MovieRepository repository;

  const GetMovieDetail({required this.repository});

  @override
  Future<DataState<Movie>> call(int id) => repository.getMovieDetail(id);
}
