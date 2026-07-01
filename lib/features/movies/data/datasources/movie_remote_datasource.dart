import '../models/movie_model.dart';
import 'movie_api_client.dart';

abstract interface class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieModel> getMovieDetail(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final MovieApiClient apiClient;

  const MovieRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await apiClient.getPopularMovies();
    return response.results;
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await apiClient.getTopRatedMovies();
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
