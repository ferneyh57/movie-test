import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final UseCase<DataState<List<Movie>>, NoParams> getMovies;

  MoviesCubit({required this.getMovies}) : super(const MoviesState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final result = await getMovies(const NoParams());
    if (result is DataSuccess<List<Movie>>) {
      emit(state.copyWith(movies: result.data, isLoading: false));
    } else if (result is DataFailure<List<Movie>>) {
      emit(state.copyWith(isLoading: false, errorMessage: result.failure.message));
    }
  }
}
