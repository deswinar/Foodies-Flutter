part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserModel updatedProfile;
  final XFile newPhoto;

  UpdateProfile({required this.updatedProfile, required this.newPhoto});
}
