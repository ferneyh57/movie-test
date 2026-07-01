import 'package:movie_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'movies_cubit.dart';

class PopularMoviesCubit extends MoviesCubit {
  PopularMoviesCubit({required GetPopularMovies getPopularMovies})
      : super(getMovies: getPopularMovies);
}
