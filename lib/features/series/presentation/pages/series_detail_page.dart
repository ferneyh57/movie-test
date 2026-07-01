import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/config/app_config.dart';
import 'package:movie_test/core/di/injection_container.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'package:movie_test/features/series/presentation/cubit/series_detail_cubit.dart';
import 'package:movie_test/features/series/presentation/cubit/series_detail_state.dart';

class SeriesDetailPage extends StatelessWidget {
  final int seriesId;

  const SeriesDetailPage({super.key, required this.seriesId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SeriesDetailCubit>()..load(seriesId),
      child: BlocBuilder<SeriesDetailCubit, SeriesDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state.errorMessage != null) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(state.errorMessage!)),
            );
          }
          if (state.series == null) return const SizedBox.shrink();
          return SeriesDetailContent(series: state.series!);
        },
      ),
    );
  }
}

class SeriesDetailContent extends StatelessWidget {
  final Series series;

  const SeriesDetailContent({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(series.name),
              background: series.backdropPath != null
                  ? Hero(
                      tag: 'media_${series.id}',
                      child: Image.network(
                        '${AppConfig.tmdbImageBaseUrl}${series.backdropPath}',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Hero(
                      tag: 'media_${series.id}',
                      child: Container(color: Colors.grey.shade800),
                    ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      series.voteAverage.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (series.voteCount != null) ...[
                      const SizedBox(width: 8),
                      Text('(${series.voteCount} votes)',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                    const Spacer(),
                    if (series.firstAirDate != null)
                      Text(series.firstAirDate!,
                          style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(series.overview),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
