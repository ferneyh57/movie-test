import 'package:movie_test/features/movies/data/models/movie_list_response_model.dart';
import 'package:movie_test/features/movies/data/models/movie_model.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import 'package:movie_test/features/series/data/models/series_model.dart';

MovieModel movieModel({int id = 1}) => MovieModel(
      id: id,
      title: 'Movie $id',
      overview: 'Overview $id',
      voteAverage: 7.5,
    );

SeriesModel seriesModel({int id = 1}) => SeriesModel(
      id: id,
      name: 'Series $id',
      overview: 'Overview $id',
      voteAverage: 7.5,
    );

MovieListResponseModel moviePage({
  int page = 1,
  int totalPages = 3,
  List<MovieModel>? results,
}) =>
    MovieListResponseModel(
      page: page,
      totalPages: totalPages,
      totalResults: totalPages * 20,
      results: results ?? [movieModel(id: page * 10)],
    );

SeriesListResponseModel seriesPage({
  int page = 1,
  int totalPages = 3,
  List<SeriesModel>? results,
}) =>
    SeriesListResponseModel(
      page: page,
      totalPages: totalPages,
      totalResults: totalPages * 20,
      results: results ?? [seriesModel(id: page * 10)],
    );
