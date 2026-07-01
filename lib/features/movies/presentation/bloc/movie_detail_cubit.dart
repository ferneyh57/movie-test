import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final UseCase<DataState<Movie>, int> getMovieDetail;

  MovieDetailCubit({required this.getMovieDetail})
      : super(const MovieDetailState());

  Future<void> load(int id) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getMovieDetail(id);
    if (result is DataSuccess<Movie>) {
      emit(state.copyWith(movie: result.data, isLoading: false));
    } else if (result is DataFailure<Movie>) {
      emit(state.copyWith(isLoading: false, errorMessage: result.failure.message));
    }
  }
}
