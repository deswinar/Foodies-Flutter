import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/comment/comment_bloc.dart';

class CommentSection extends StatelessWidget {
  final String recipeId;
  final TextEditingController _controller = TextEditingController();

  CommentSection({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    context.read<CommentBloc>().add(FetchComments(recipeId));
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              if (state is CommentLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CommentError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is CommentLoaded) {
                return ListView.builder(
                  itemCount: state.comments.length,
                  itemBuilder: (context, index) {
                    final comment = state.comments[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0), // Adjust vertical spacing
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage: comment.photoURL != null &&
                                    comment.photoURL!.isNotEmpty
                                ? NetworkImage(comment.photoURL!)
                                : null,
                            child: comment.photoURL == null ||
                                    comment.photoURL!.isEmpty
                                ? const Icon(Icons.person, size: 20)
                                : null,
                          ),
                          const SizedBox(
                              width: 8.0), // Spacing between avatar and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.displayName ?? 'Unknown User',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  comment.comment,
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const Center(child: Text('No comments yet.'));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (text) => _postComment(context, text),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  _postComment(context, _controller.text);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _postComment(BuildContext context, String text) {
    if (text.isNotEmpty) {
      context.read<CommentBloc>().add(PostComment(recipeId, text));
      _controller.clear();
    }
  }
}
