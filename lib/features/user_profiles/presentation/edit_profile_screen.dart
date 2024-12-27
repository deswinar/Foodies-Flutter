import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../data/model/user_model.dart';
import '../domain/profile/profile_bloc.dart';
import 'widgets/profile_image_upload_widget.dart';

@RoutePage()
class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({required this.user, super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  XFile? _selectedImage;
  String? _photoURL;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and fields using the passed user data
    _nameController =
        TextEditingController(text: widget.user.displayName ?? '');
    _photoURL = widget.user.photoURL;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _uploadImageAndSaveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Prepare the updated profile
        final updatedProfile = UserModel(
          uid: widget.user.uid,
          email: widget.user.email,
          displayName: _nameController.text,
          photoURL: _photoURL,
          createdAt: widget.user.createdAt,
        );
        // print(updatedProfile);
        if (_selectedImage != null) {
          // Dispatch the profile update event to the Bloc
          context.read<ProfileBloc>().add(UpdateProfile(
              updatedProfile: updatedProfile, newPhoto: _selectedImage!));
        } else {
          context
              .read<ProfileBloc>()
              .add(UpdateProfile(updatedProfile: updatedProfile));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!')),
            );
            Navigator.pop(context);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileImageUploadWidget(
                  existingImageUrl: widget.user.photoURL,
                  onImageUpdated: (image) {
                    setState(() {
                      _selectedImage = image;
                    });
                  }, // Use Cloudinary only if no local file is selected
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Display Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your display name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _uploadImageAndSaveProfile,
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
