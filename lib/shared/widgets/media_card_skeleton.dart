import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DetailPageSkeleton extends StatelessWidget {
  const DetailPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: Colors.grey.shade700,
                child: Container(color: Colors.grey),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade800,
                  highlightColor: Colors.grey.shade600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(height: 20, width: 60, color: Colors.grey),
                          const SizedBox(width: 12),
                          Container(height: 16, width: 80, color: Colors.grey),
                          const Spacer(),
                          Container(height: 16, width: 60, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(height: 18, width: 100, color: Colors.grey),
                      const SizedBox(height: 12),
                      Container(height: 14, width: double.infinity, color: Colors.grey),
                      const SizedBox(height: 6),
                      Container(height: 14, width: double.infinity, color: Colors.grey),
                      const SizedBox(height: 6),
                      Container(height: 14, width: double.infinity, color: Colors.grey),
                      const SizedBox(height: 6),
                      Container(height: 14, width: 200, color: Colors.grey),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchResultsSkeleton extends StatelessWidget {
  const SearchResultsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SkeletonSection(),
        const SizedBox(height: 16),
        _SkeletonSection(),
      ],
    );
  }
}

class _SkeletonSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade600,
          child: Container(height: 16, width: 100, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, _) => const SizedBox(width: 120, child: MediaCardSkeleton()),
          ),
        ),
      ],
    );
  }
}

class MediaCardSkeleton extends StatelessWidget {
  const MediaCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(height: 12, width: 90, color: Colors.grey),
          const SizedBox(height: 4),
          Container(height: 10, width: 50, color: Colors.grey),
        ],
      ),
    );
  }
}

class FeaturedBannerSkeleton extends StatelessWidget {
  const FeaturedBannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(color: Colors.grey),
    );
  }
}

