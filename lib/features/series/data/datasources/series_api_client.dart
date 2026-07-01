import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/series_list_response_model.dart';
import '../models/series_model.dart';

part 'series_api_client.g.dart';

@RestApi()
abstract class SeriesApiClient {
  factory SeriesApiClient(Dio dio, {String baseUrl}) = _SeriesApiClient;

  @GET('/tv/popular')
  Future<SeriesListResponseModel> getPopularSeries(@Query('page') int page);

  @GET('/tv/top_rated')
  Future<SeriesListResponseModel> getTopRatedSeries(@Query('page') int page);

  @GET('/tv/{id}')
  Future<SeriesModel> getSeriesDetail(@Path('id') int id);

  @GET('/search/tv')
  Future<SeriesListResponseModel> searchSeries(
    @Query('query') String query, {
    @Query('page') int page = 1,
  });
}
