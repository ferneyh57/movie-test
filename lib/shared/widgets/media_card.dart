import 'package:flutter/material.dart';
import 'package:movie_test/core/config/app_config.dart';

class MediaCard extends StatelessWidget {
  final int id;
  final String title;
  final String? posterPath;
  final double voteAverage;
  final VoidCallback onTap;

  const MediaCard({
    super.key,
    required this.id,
    required this.title,
    this.posterPath,
    required this.voteAverage,
    required this.onTap,
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
              tag: 'media_$id',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: posterPath != null
                    ? Image.network(
                        '${AppConfig.tmdbImageBaseUrl}$posterPath',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, _, _) => Container(
                          color: Colors.grey.shade300,
                          child: const Center(child: Icon(Icons.movie, size: 40)),
                        ),
                      )
                    : Container(
                        color: Colors.grey.shade300,
                        child: const Center(child: Icon(Icons.movie, size: 40)),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
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
