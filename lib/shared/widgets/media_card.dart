import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_test/core/config/app_config.dart';
import 'package:shimmer/shimmer.dart';

class MediaCard extends StatelessWidget {
  final int id;
  final String title;
  final String? posterPath;
  final double voteAverage;
  final VoidCallback onTap;
  final String? heroTag;

  const MediaCard({
    super.key,
    required this.id,
    required this.title,
    this.posterPath,
    required this.voteAverage,
    required this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: heroTag ?? 'media_$id',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox.expand(
                  child: posterPath != null
                      ? CachedNetworkImage(
                          imageUrl: '${AppConfig.tmdbImageBaseUrl}$posterPath',
                          fit: BoxFit.cover,
                          placeholder: (_, _) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade800,
                            highlightColor: Colors.grey.shade600,
                            child: Container(color: Colors.grey),
                          ),
                          errorWidget: (_, _, _) => Container(
                            color: Colors.grey.shade800,
                            child: const Center(
                              child: Icon(Icons.movie, size: 40),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade800,
                          child: const Center(
                            child: Icon(Icons.movie, size: 40),
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 2),
              Text(
                voteAverage.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
