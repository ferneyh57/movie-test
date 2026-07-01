import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import 'package:movie_test/features/series/domain/usecases/get_top_rated_series.dart';
import 'package:movie_test/features/series/presentation/cubit/series_list_state.dart';

class TopRatedSeriesCubit extends Cubit<SeriesListState> {
  final GetTopRatedSeries _getTopRatedSeries;

  TopRatedSeriesCubit({required GetTopRatedSeries getTopRatedSeries})
      : _getTopRatedSeries = getTopRatedSeries,
        super(const SeriesListState(isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    final result = await _getTopRatedSeries();
    if (result is DataSuccess<SeriesListResponseModel>) {
      emit(SeriesListState(response: result.data));
    } else {
      emit(const SeriesListState());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    emit(SeriesListState(response: state.response, isLoading: true));
    final result = await _getTopRatedSeries(state.response!.page + 1);
    if (result is DataSuccess<SeriesListResponseModel>) {
      emit(SeriesListState(
        response: state.response!.copyWith(
          results: [...state.response!.results, ...result.data.results],
          page: result.data.page,
          totalPages: result.data.totalPages,
        ),
      ));
    } else {
      emit(SeriesListState(response: state.response));
    }
  }
}
