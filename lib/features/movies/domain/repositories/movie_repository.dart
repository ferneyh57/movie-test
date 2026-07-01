import '../entities/movie.dart';

abstract interface class MovieRepository {
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getTopRatedMovies();
  Future<Movie> getMovieDetail(int id);
  Future<List<Movie>> searchMovies(String query);
}
