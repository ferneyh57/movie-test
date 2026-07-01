import 'package:dio/dio.dart';
import '../models/movie_model.dart';

abstract interface class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies();
  Future<MovieModel> getMovieDetail(int id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio _dio;

  const MovieRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await _dio.get('/movie/popular');
    final results = response.data['results'] as List;
    return results
        .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MovieModel> getMovieDetail(int id) async {
    final response = await _dio.get('/movie/$id');
    return MovieModel.fromJson(response.data as Map<String, dynamic>);
  }
}
