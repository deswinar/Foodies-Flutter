import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/widgets/recipe_compact_widget.dart';
import '../../../recipes/data/model/recipe_model.dart';
import '../../domain/search/search_bloc.dart';

class SearchWidget extends StatelessWidget {
  final User? user;

  const SearchWidget({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, searchState) {
        if (searchState is SearchLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (searchState is SearchLoadedState) {
          return searchState.searchResults.isEmpty
              ? const Center(child: Text('No recipes found.'))
              : _buildSearchResults(context, searchState.searchResults, user);
        } else if (searchState is SearchErrorState) {
          return Center(child: Text(searchState.errorMessage));
        } else {
          return const SizedBox.shrink(); // No search results or error
        }
      },
    );
  }

  Widget _buildSearchResults(
      BuildContext context, List<Recipe> searchResults, User? user) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final recipe = searchResults[index];
        return RecipeCompactWidget(recipe: recipe);
      },
    );
  }
}
