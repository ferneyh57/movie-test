import '../entities/movie.dart';

abstract interface class MovieRepository {
  Future<List<Movie>> getPopularMovies();
  Future<Movie> getMovieDetail(int id);
}
