import 'package:freezed_annotation/freezed_annotation.dart';
import 'series_model.dart';

part 'series_list_response_model.freezed.dart';
part 'series_list_response_model.g.dart';

@freezed
abstract class SeriesListResponseModel with _$SeriesListResponseModel {
  const factory SeriesListResponseModel({
    required List<SeriesModel> results,
    required int page,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'total_results') required int totalResults,
  }) = _SeriesListResponseModel;

  factory SeriesListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SeriesListResponseModelFromJson(json);
}
