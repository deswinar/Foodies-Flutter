import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/features/user_profiles/data/model/user_model.dart';
import 'package:myapp/core/services/cloudinary_service.dart';
import '../../../core/common/widgets/profile_image_widget.dart';
import '../domain/profile/profile_bloc.dart';

@RoutePage()
class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({required this.user, Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final _cloudinaryService = GetIt.instance<CloudinaryService>();

  late TextEditingController _nameController;
  File? _selectedImage;
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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageAndSaveProfile() async {
    if (_formKey.currentState!.validate()) {
      String? uploadedPhotoUrl;

      try {
        // If a new image is selected, upload it to Cloudinary
        if (_selectedImage != null) {
          uploadedPhotoUrl =
              await _cloudinaryService.uploadImage(_selectedImage!);
        }

        // Prepare the updated profile
        final updatedProfile = UserModel(
          uid: widget.user.uid,
          email: widget.user.email,
          displayName: _nameController.text,
          photoURL: uploadedPhotoUrl ?? _photoURL,
          createdAt: widget.user.createdAt,
        );

        // Dispatch the profile update event to the Bloc
        context
            .read<ProfileBloc>()
            .add(UpdateProfile(updatedProfile: updatedProfile));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed: ${e.toString()}')),
        );
      }
    }
  }

  void _showImageSourceSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
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
                GestureDetector(
                  onTap: _showImageSourceSelection,
                  child: ProfileImageWidget(
                    source: _selectedImage != null
                        ? _selectedImage!
                            .path // Use local file path for selected image
                        : (_photoURL ??
                            ''), // Use photo URL or empty string if null
                    size: 100, // Diameter of the profile image
                    placeholder: const Icon(Icons.person, size: 50),
                    errorWidget: const Icon(Icons.error, size: 50),
                    useCloudinary: _selectedImage == null &&
                        _photoURL !=
                            null, // Use Cloudinary only if no local file is selected
                  ),
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
