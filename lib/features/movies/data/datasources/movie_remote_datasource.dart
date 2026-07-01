import '../models/movie_list_response_model.dart';
import '../models/movie_model.dart';
import 'movie_api_client.dart';

abstract interface class MovieRemoteDataSource {
  Future<MovieListResponseModel> getPopularMovies({required int page});
  Future<MovieListResponseModel> getTopRatedMovies({required int page});
  Future<MovieModel> getMovieDetail(int id);
  Future<MovieListResponseModel> searchMovies(String query, {int page = 1});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final MovieApiClient apiClient;

  const MovieRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MovieListResponseModel> getPopularMovies({required int page}) =>
      apiClient.getPopularMovies(page);

  @override
  Future<MovieListResponseModel> getTopRatedMovies({required int page}) =>
      apiClient.getTopRatedMovies(page);

  @override
  Future<MovieModel> getMovieDetail(int id) => apiClient.getMovieDetail(id);

  @override
  Future<MovieListResponseModel> searchMovies(String query, {int page = 1}) =>
      apiClient.searchMovies(query, page: page);
}
