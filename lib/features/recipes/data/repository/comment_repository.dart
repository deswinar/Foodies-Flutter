import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../injection/service_locator.dart';
import '../model/recipe_model.dart';

class CommentRepository {
  final FirebaseFirestore firestore;
  final user = getIt<FirebaseAuth>().currentUser;

  CommentRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches comments for a specific recipe
  Future<List<Comment>> fetchComments(String recipeId) async {
    try {
      final snapshot = await firestore
          .collection('recipes')
          .doc(recipeId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Comment.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  /// Posts a new comment to the specified recipe
  Future<void> postComment(String recipeId, String text) async {
    try {
      await firestore
          .collection('recipes')
          .doc(recipeId)
          .collection('comments')
          .add({
        'userId': user!.uid,
        'comment': text,
        'createdAt': Timestamp.now(),
        'displayName': user?.displayName,
        'photoURL': user?.photoURL,
      });
    } catch (e) {
      throw Exception('Failed to post comment: $e');
    }
  }
}
