import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/movie_list_response_model.dart';
import '../models/movie_model.dart';

part 'movie_api_client.g.dart';

@RestApi()
abstract class MovieApiClient {
  factory MovieApiClient(Dio dio, {String baseUrl}) = _MovieApiClient;

  @GET('/movie/popular')
  Future<MovieListResponseModel> getPopularMovies();

  @GET('/movie/{id}')
  Future<MovieModel> getMovieDetail(@Path('id') int id);
}
