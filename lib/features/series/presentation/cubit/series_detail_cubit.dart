import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'series_detail_state.dart';

class SeriesDetailCubit extends Cubit<SeriesDetailState> {
  final UseCase<DataState<Series>, int> getSeriesDetail;

  SeriesDetailCubit({required this.getSeriesDetail})
      : super(const SeriesDetailState());

  Future<void> load(int id) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getSeriesDetail(id);
    if (result is DataSuccess<Series>) {
      emit(state.copyWith(series: result.data, isLoading: false));
    } else if (result is DataFailure<Series>) {
      emit(state.copyWith(isLoading: false, errorMessage: result.failure.message));
    }
  }
}
