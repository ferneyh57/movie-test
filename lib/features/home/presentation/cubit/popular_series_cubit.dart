import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/utils/data_state.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import 'package:movie_test/features/series/domain/usecases/get_popular_series.dart';
import 'package:movie_test/features/series/presentation/cubit/series_list_state.dart';

class PopularSeriesCubit extends Cubit<SeriesListState> {
  final GetPopularSeries _getPopularSeries;

  PopularSeriesCubit({required GetPopularSeries getPopularSeries})
      : _getPopularSeries = getPopularSeries,
        super(const SeriesListState(isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    final result = await _getPopularSeries();
    if (result is DataSuccess<SeriesListResponseModel>) {
      emit(SeriesListState(response: result.data));
    } else {
      emit(const SeriesListState());
    }
  }

  Future<void> loadMore() async {
    final response = state.response;
    if (state.isLoading || !state.hasMore || response == null) return;
    emit(state.copyWith(isLoading: true));
    final result = await _getPopularSeries(response.page + 1);
    if (result is DataSuccess<SeriesListResponseModel>) {
      emit(SeriesListState(
        response: response.copyWith(
          results: [...response.results, ...result.data.results],
          page: result.data.page,
          totalPages: result.data.totalPages,
        ),
      ));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }
}
