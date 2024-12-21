import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/feeds/feed_bloc.dart';
import '../../domain/feeds/feed_event.dart';

class SortBottomSheet extends StatelessWidget {
  final String? currentCategory;
  final String? currentSortBy;

  const SortBottomSheet({
    super.key,
    this.currentCategory,
    this.currentSortBy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sort by',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Newest'),
            selected: currentSortBy == 'createdAt',
            onTap: () {
              context.read<FeedBloc>().add(
                    FetchFeedsEvent(category: currentCategory, sortBy: 'createdAt'),
                  );
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Most Popular'),
            selected: currentSortBy == 'likesCount',
            onTap: () {
              context.read<FeedBloc>().add(
                    FetchFeedsEvent(category: currentCategory, sortBy: 'likesCount'),
                  );
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Alphabetical (A-Z)'),
            selected: currentSortBy == 'title',
            onTap: () {
              context.read<FeedBloc>().add(
                    FetchFeedsEvent(category: currentCategory, sortBy: 'title'),
                  );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
