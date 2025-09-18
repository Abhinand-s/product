//file for profile states
part of 'profile_bloc.dart';

/// abstract class for profile states
abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {} // initial state

class ProfileLoading extends ProfileState {} // loading state

class ProfileLoaded extends ProfileState {
  // loaded state
  final UserProfile userProfile; // assuming UserProfile is a model class
  const ProfileLoaded(this.userProfile); // constructor
  @override
  List<Object> get props => [userProfile];
}

// error state
class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object> get props => [message];
}
