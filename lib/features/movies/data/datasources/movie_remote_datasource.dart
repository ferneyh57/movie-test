import '../models/movie_model.dart';
import 'movie_api_client.dart';

abstract interface class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies();
  Future<MovieModel> getMovieDetail(int id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final MovieApiClient _apiClient;

  const MovieRemoteDataSourceImpl({required MovieApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await _apiClient.getPopularMovies();
    return response.results;
  }

  @override
  Future<MovieModel> getMovieDetail(int id) => _apiClient.getMovieDetail(id);
}
