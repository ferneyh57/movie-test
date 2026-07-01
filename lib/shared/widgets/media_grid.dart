import 'package:flutter/material.dart';

class MediaGrid<T> extends StatelessWidget {
  final List<T> items;
  final bool isLoading;
  final String? errorMessage;
  final Widget Function(T) itemBuilder;

  const MediaGrid({
    super.key,
    required this.items,
    required this.isLoading,
    this.errorMessage,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text(errorMessage!),
          ],
        ),
      );
    }
    if (items.isEmpty) return const Center(child: Text('No results'));
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (_, index) => itemBuilder(items[index]),
    );
  }
}
