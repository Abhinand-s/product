//file for profile state management using Bloc pattern
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:product/data/models/user_profile_model.dart';
import 'package:product/data/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<FetchProfileData>((event, emit) async {
      debugPrint(
          "--- ProfileBloc: Received FetchProfileData event ---"); // Debug statement
      emit(ProfileLoading()); // Emit loading state
      try {
        debugPrint(
            "--- ProfileBloc: Calling repository to fetch user profile... ---"); // Debug statement
        final userProfile = await _profileRepository
            .fetchUserProfile(); // Fetch data from repository
        debugPrint(
            "--- ProfileBloc: Repository call successful. Emitting ProfileLoaded. ---"); // Debug statement
        emit(ProfileLoaded(userProfile)); // Emit loaded state with data
      } catch (e) {
        debugPrint(
            "--- ProfileBloc: CAUGHT ERROR: ${e.toString()} ---"); // Debug statement
        emit(ProfileError(e.toString())); // Emit error state
      }
    });
  }
}
