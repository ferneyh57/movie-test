import 'package:movie_test/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'movies_cubit.dart';

class TopRatedMoviesCubit extends MoviesCubit {
  TopRatedMoviesCubit({required GetTopRatedMovies getTopRatedMovies})
      : super(getMovies: getTopRatedMovies);
}
