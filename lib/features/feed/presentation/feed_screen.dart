import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../injection/service_locator.dart';
import '../domain/feeds/feed_bloc.dart';
import '../domain/feeds/feed_event.dart';
import '../domain/feeds/feed_state.dart';
import '../domain/search/search_bloc.dart';
import 'widgets/feed_widget.dart';
import 'widgets/search_widget.dart';
import 'widgets/sort_bottom_sheet.dart';

@RoutePage()
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt<FirebaseAuth>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Foodies Feed'),
      ),
      resizeToAvoidBottomInset:
          true, // Ensure the keyboard doesn't cause layout issues
      body: RefreshIndicator(
        onRefresh: () async {
          // Trigger the refresh event in the FeedBloc
          context.read<FeedBloc>().add(const RefreshFeed());
        },
        child: Column(
          children: [
            _buildSearchBar(context),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, searchState) {
                  if (searchState is SearchLoadingState ||
                      searchState is SearchLoadedState ||
                      searchState is SearchErrorState) {
                    // Show the SearchWidget only during an active search
                    return SearchWidget(user: user);
                  }
                  // Default to showing the FeedWidget when not searching
                  return _buildFeed(context, user);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search recipes...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                final searchBloc = context.read<SearchBloc>();
                if (query.isNotEmpty) {
                  searchBloc.add(SearchRecipesEvent(query: query));
                } else {
                  searchBloc.add(ClearSearchEvent());
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              final feedState = context.read<FeedBloc>().state;
              if (feedState is FeedsLoadedState) {
                _showSortBottomSheet(
                  context,
                  currentCategory: feedState.category,
                  currentSortBy: feedState.sortBy,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeed(BuildContext context, User? user) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        if (state is FeedLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FeedsLoadedState) {
          return FeedWidget(user: user); // This must be scrollable.
        } else if (state is FeedsErrorState) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const Center(child: Text('No feeds available.'));
      },
    );
  }

  void _showSortBottomSheet(BuildContext context,
      {String? currentCategory, String? currentSortBy}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<FeedBloc>(),
          child: SortBottomSheet(
            currentCategory: currentCategory,
            currentSortBy: currentSortBy,
          ),
        );
      },
    );
  }
}
