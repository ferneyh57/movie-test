import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/movie_list_response_model.dart';
import '../models/movie_model.dart';

part 'movie_api_client.g.dart';

@RestApi()
abstract class MovieApiClient {
  factory MovieApiClient(Dio dio, {String baseUrl}) = _MovieApiClient;

  @GET('/movie/popular')
  Future<MovieListResponseModel> getPopularMovies(@Query('page') int page);

  @GET('/movie/top_rated')
  Future<MovieListResponseModel> getTopRatedMovies(@Query('page') int page);

  @GET('/movie/{id}')
  Future<MovieModel> getMovieDetail(@Path('id') int id);

  @GET('/search/movie')
  Future<MovieListResponseModel> searchMovies(
    @Query('query') String query, {
    @Query('page') int page = 1,
  });
}
