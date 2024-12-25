// Suggested code may be subject to a license. Learn more: ~LicenseLog:2150054707.
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/user_model.dart';
import '../../data/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await profileRepository.getProfile();
        print(profile!.displayName);
        emit(ProfileLoaded(user: profile!));
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    });

    on<UpdateProfile>((event, emit) async {
      emit(ProfileUpdating());
      try {
        await profileRepository.updateProfile(event.updatedProfile, event.newPhoto);
        // final user = await profileRepository.getProfile();
        add(FetchProfile());
        emit(ProfileUpdated(user: event.updatedProfile));
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    });
  }
}
