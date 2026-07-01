import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_test/core/network/network_client.dart';
import 'package:movie_test/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:movie_test/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:movie_test/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_test/features/movies/presentation/bloc/movies_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<Dio>(() => createDioClient());

  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetPopularMovies(repository: sl()));

  sl.registerFactory(() => MoviesCubit(getPopularMovies: sl()));
}
