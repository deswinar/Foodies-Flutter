import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../injection/service_locator.dart';
import '../model/user_model.dart';

class ProfileRepository {
  final FirebaseFirestore firestore = getIt<FirebaseFirestore>();
  final user = getIt<FirebaseAuth>().currentUser;

  ProfileRepository();

  /// Fetch the profile of the current logged-in user
  Future<UserModel?> getProfile() async {
    try {
      // Get the currently logged-in user
      if (user == null) {
        throw Exception('User is not logged in.');
      }

      // Fetch the user's profile from Firestore
      final docSnapshot =
          await firestore.collection('users').doc(user?.uid).get();

      if (!docSnapshot.exists) {
        throw Exception('User profile not found.');
      }

      // Convert the Firestore document to a UserModel
      return UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching user profile: $e');
      throw Exception('Failed to fetch user profile.');
    }
  }

  /// Update the profile of the current logged-in user
  Future<void> updateProfile(UserModel updatedProfile, XFile newPhoto) async {
    final cloudinaryService = getIt<CloudinaryService>();
    try {
      // Ensure the user is logged in
      if (user == null) {
        throw Exception('User is not logged in.');
      }

      if (newPhoto.path.isNotEmpty) {
        final imageUrl =
            await cloudinaryService.uploadImage(File(newPhoto.path));
        updatedProfile = updatedProfile.copyWith(photoURL: imageUrl);
      }

      // Update the user's profile in Firestore
      await firestore
          .collection('users')
          .doc(user?.uid)
          .update(updatedProfile.toMap());
    } catch (e) {
      print('Error updating user profile: $e');
      throw Exception('Failed to update user profile.');
    }
  }
}
