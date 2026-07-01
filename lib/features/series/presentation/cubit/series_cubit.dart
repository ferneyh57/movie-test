import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'series_state.dart';

class SeriesCubit extends Cubit<SeriesState> {
  final UseCase<DataState<List<Series>>, NoParams> getSeries;

  SeriesCubit({required this.getSeries}) : super(const SeriesState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final result = await getSeries(const NoParams());
    if (result is DataSuccess<List<Series>>) {
      emit(state.copyWith(series: result.data, isLoading: false));
    } else if (result is DataFailure<List<Series>>) {
      emit(state.copyWith(isLoading: false, errorMessage: result.failure.message));
    }
  }
}
