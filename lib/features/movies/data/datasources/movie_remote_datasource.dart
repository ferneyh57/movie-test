import '../models/movie_model.dart';
import 'movie_api_client.dart';

abstract interface class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies({required int page});
  Future<List<MovieModel>> getTopRatedMovies({required int page});
  Future<MovieModel> getMovieDetail(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final MovieApiClient apiClient;

  const MovieRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MovieModel>> getPopularMovies({required int page}) async {
    final response = await apiClient.getPopularMovies(page);
    return response.results;
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies({required int page}) async {
    final response = await apiClient.getTopRatedMovies(page);
    return response.results;
  }

  @override
  Future<MovieModel> getMovieDetail(int id) => apiClient.getMovieDetail(id);

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await apiClient.searchMovies(query);
    return response.results;
  }
}
