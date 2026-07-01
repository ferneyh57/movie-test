import 'package:flutter/material.dart';
import 'media_card_skeleton.dart';

class MediaCarousel<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final Widget Function(T) itemBuilder;
  final VoidCallback? onLoadMore;
  final bool hasMore;

  const MediaCarousel({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.onLoadMore,
    this.hasMore = true,
  });

  @override
  State<MediaCarousel<T>> createState() => MediaCarouselState<T>();
}

class MediaCarouselState<T> extends State<MediaCarousel<T>> {
  late final ScrollController _scrollController;
  bool _requestingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void didUpdateWidget(MediaCarousel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length != oldWidget.items.length) {
      _requestingMore = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_requestingMore || !_scrollController.hasClients || !widget.hasMore) {
      return;
    }
    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.offset >= threshold) {
      _requestingMore = true;
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Text(
            widget.title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 210,
          child: widget.items.isEmpty
              ? const _HorizontalSkeletonList()
              : ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.items.length,
                  itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 120,
                      child: widget.itemBuilder(widget.items[index]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _HorizontalSkeletonList extends StatelessWidget {
  const _HorizontalSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (_, _) => const Padding(
        padding: EdgeInsets.only(right: 10),
        child: SizedBox(width: 120, child: MediaCardSkeleton()),
      ),
    );
  }
}
