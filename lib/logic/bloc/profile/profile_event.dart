//file for profile events
part of 'profile_bloc.dart';
/// abstract class for profile events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}
/// event to fetch profile data
class FetchProfileData extends ProfileEvent {}