import 'package:movie_test/core/utils/data_state.dart';
import '../entities/movie.dart';

abstract interface class MovieRepository {
  Future<DataState<List<Movie>>> getPopularMovies();
  Future<DataState<List<Movie>>> getTopRatedMovies();
  Future<DataState<Movie>> getMovieDetail(int id);
  Future<DataState<List<Movie>>> searchMovies(String query);
}
