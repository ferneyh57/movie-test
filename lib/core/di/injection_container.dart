import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_test/core/network/network_client.dart';

// Movies
import 'package:movie_test/features/movies/data/datasources/movie_api_client.dart';
import 'package:movie_test/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:movie_test/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:movie_test/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_test/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:movie_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_test/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movie_test/features/movies/domain/usecases/search_movies.dart';
import 'package:movie_test/features/movies/presentation/bloc/movie_detail_cubit.dart';
import 'package:movie_test/features/movies/presentation/bloc/popular_movies_cubit.dart';
import 'package:movie_test/features/movies/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:movie_test/features/search/presentation/cubit/search_cubit.dart';

// Series
import 'package:movie_test/features/series/data/datasources/series_api_client.dart';
import 'package:movie_test/features/series/data/datasources/series_remote_datasource.dart';
import 'package:movie_test/features/series/data/repositories/series_repository_impl.dart';
import 'package:movie_test/features/series/domain/repositories/series_repository.dart';
import 'package:movie_test/features/series/domain/usecases/get_popular_series.dart';
import 'package:movie_test/features/series/domain/usecases/get_series_detail.dart';
import 'package:movie_test/features/series/domain/usecases/get_top_rated_series.dart';
import 'package:movie_test/features/series/domain/usecases/search_series.dart';
import 'package:movie_test/features/series/presentation/cubit/popular_series_cubit.dart';
import 'package:movie_test/features/series/presentation/cubit/series_detail_cubit.dart';
import 'package:movie_test/features/series/presentation/cubit/top_rated_series_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Network
  sl.registerLazySingleton<Dio>(() => createDioClient());

  // Movies - Data
  sl.registerLazySingleton(() => MovieApiClient(sl()));
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: sl()),
  );

  // Movies - Use cases
  sl.registerLazySingleton(() => GetPopularMovies(repository: sl()));
  sl.registerLazySingleton(() => GetTopRatedMovies(repository: sl()));
  sl.registerLazySingleton(() => GetMovieDetail(repository: sl()));
  sl.registerLazySingleton(() => SearchMovies(repository: sl()));

  // Movies - Presentation
  sl.registerFactory(() => PopularMoviesCubit(getPopularMovies: sl()));
  sl.registerFactory(() => TopRatedMoviesCubit(getTopRatedMovies: sl()));
  sl.registerFactory(() => MovieDetailCubit(getMovieDetail: sl<GetMovieDetail>()));

  // Series - Data
  sl.registerLazySingleton(() => SeriesApiClient(sl()));
  sl.registerLazySingleton<SeriesRemoteDataSource>(
    () => SeriesRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<SeriesRepository>(
    () => SeriesRepositoryImpl(remoteDataSource: sl()),
  );

  // Series - Use cases
  sl.registerLazySingleton(() => GetPopularSeries(repository: sl()));
  sl.registerLazySingleton(() => GetTopRatedSeries(repository: sl()));
  sl.registerLazySingleton(() => GetSeriesDetail(repository: sl()));
  sl.registerLazySingleton(() => SearchSeries(repository: sl()));

  // Series - Presentation
  sl.registerFactory(() => PopularSeriesCubit(getPopularSeries: sl()));
  sl.registerFactory(() => TopRatedSeriesCubit(getTopRatedSeries: sl()));
  sl.registerFactory(() => SeriesDetailCubit(getSeriesDetail: sl()));

  // Search - Presentation
  sl.registerFactory(() => SearchCubit(
        searchMovies: sl(),
        searchSeries: sl(),
      ));
}
