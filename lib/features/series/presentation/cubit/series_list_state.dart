import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_test/features/series/data/mappers/series_mapper.dart';
import 'package:movie_test/features/series/data/models/series_list_response_model.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';

part 'series_list_state.freezed.dart';

@freezed
abstract class SeriesListState with _$SeriesListState {
  const SeriesListState._();

  const factory SeriesListState({
    SeriesListResponseModel? response,
    @Default(false) bool isLoading,
  }) = _SeriesListState;

  bool get hasMore {
    final r = response;
    return r != null && r.page < r.totalPages;
  }

  List<Series> get series =>
      response?.results.map(SeriesMapper.toEntity).toList() ?? [];
}
