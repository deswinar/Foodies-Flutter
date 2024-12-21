part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserModel updatedProfile;

  UpdateProfile({required this.updatedProfile});
}
