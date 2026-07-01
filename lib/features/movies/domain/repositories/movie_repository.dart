import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import '../entities/movie.dart';

abstract interface class MovieRepository {
  Future<DataState<MovieListResponseModel>> getPopularMovies({required int page});
  Future<DataState<MovieListResponseModel>> getTopRatedMovies({required int page});
  Future<DataState<Movie>> getMovieDetail(int id);
  Future<DataState<MovieListResponseModel>> searchMovies(String query, {int page = 1});
}
