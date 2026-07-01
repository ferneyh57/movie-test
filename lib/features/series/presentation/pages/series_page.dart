import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_test/core/di/injection_container.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'package:movie_test/features/series/presentation/cubit/popular_series_cubit.dart';
import 'package:movie_test/features/series/presentation/cubit/series_cubit.dart';
import 'package:movie_test/features/series/presentation/cubit/series_state.dart';
import 'package:movie_test/features/series/presentation/cubit/top_rated_series_cubit.dart';
import 'package:movie_test/shared/widgets/media_card.dart';
import 'package:movie_test/shared/widgets/media_grid.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({super.key});

  @override
  State<SeriesPage> createState() => SeriesPageState();
}

class SeriesPageState extends State<SeriesPage> {
  late final SeriesCubit _popularCubit;
  late final SeriesCubit _topRatedCubit;

  @override
  void initState() {
    super.initState();
    _popularCubit = sl<PopularSeriesCubit>()..load();
    _topRatedCubit = sl<TopRatedSeriesCubit>()..load();
  }

  @override
  void dispose() {
    _popularCubit.close();
    _topRatedCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Series'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Popular'), Tab(text: 'Top Rated')],
          ),
        ),
        body: TabBarView(
          children: [
            SeriesTab(cubit: _popularCubit),
            SeriesTab(cubit: _topRatedCubit),
          ],
        ),
      ),
    );
  }
}

class SeriesTab extends StatelessWidget {
  final SeriesCubit cubit;

  const SeriesTab({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<SeriesCubit, SeriesState>(
        builder: (context, state) => MediaGrid<Series>(
          isLoading: state.isLoading,
          errorMessage: state.errorMessage,
          items: state.series,
          itemBuilder: (series) => MediaCard(
            id: series.id,
            title: series.name,
            posterPath: series.posterPath,
            voteAverage: series.voteAverage,
            onTap: () => context.push('/series/${series.id}'),
          ),
        ),
      ),
    );
  }
}
